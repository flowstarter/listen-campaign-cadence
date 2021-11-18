/*

    ListenBatchAuction 

    Auction Resource represents an Auction and is always held internally by the contract
    
    Admin resource is required to create Auctions

 */

import FungibleToken from "./dependencies/FungibleToken.cdc"
import NonFungibleToken from "./dependencies/NonFungibleToken.cdc"

import ListenNFT from "./ListenNFT.cdc"
import ListenUSD from "./ListenUSD.cdc"

pub contract ListenBatchAuction {

    access(contract) var nextID: UInt64                 // internal ticker for auctionIDs
    access(contract) var auctions: @{UInt64 : Auction}  // Dictionary of Auctions in existence

    access(contract) var EXTENSION_TIME : UFix64        // Currently globally set for all running auctions, consider refactoring to per auction basis for flexibility
    
    pub let AdminStoragePath : StoragePath
    pub let AdminCapabilityPath : CapabilityPath

    pub event ContractDeployed()
    pub event AuctionCreated( startTime: UFix64, endTime: UFix64, startingPrice: UFix64, bidStep: UFix64, prizeIDs: [UInt64] )
    pub event BidPlaced( auctionID: UInt64, biddersAddress: Address, amount: UFix64 )
    pub event AuctionExtended( endTime: UFix64 )
    pub event AuctionSettled(id: UInt64, winnersAddresses: [Address], finalSalesPrices: [UFix64])

    pub resource Auction {
        access(contract) let startingPrice : UFix64
        access(contract) var bidStep : UFix64       // New bids must be at least bidStep greater than current highest bid
        access(contract) let startTime : UFix64
        
        access(contract) var nftCollection : @ListenNFT.Collection 
        access(contract) var endTime : UFix64       // variable as can be extended if there is a bid in last 30min
        access(contract) var bids : @[Bid]             

        init( startTime: UFix64, endTime: UFix64, startingPrice: UFix64, bidStep: UFix64, nftCollection: @ListenNFT.Collection) {
            self.startTime = startTime
            self.endTime = endTime
            self.startingPrice = startingPrice
            self.bids <- []
            self.bidStep = bidStep
            self.nftCollection <- nftCollection
            self.bids <- [] // .append(<- create Bid(funds: <- ListenUSD.createEmptyVault(), ftReceiverCap: nil, nftReceiverCap: nil))
        }

        access(contract) fun extendAuction() {
            self.endTime = self.endTime + ListenBatchAuction.EXTENSION_TIME
            emit AuctionExtended( endTime: self.endTime)
        }

        pub fun getBidValues(): [UFix64] {
            let bidValues: [UFix64] = []
            var i = 0
            while i < self.bids.length {
                bidValues.append(self.bids[i].vault.balance)
                i = i + 1
            }
            return bidValues
        }

        access(contract) fun placeBid( bid: @ListenBatchAuction.Bid ) {
            let insertionPosition = self.find(value: bid.vault.balance, bids: self.getBidValues())
            self.bids.insert(at: insertionPosition, <- bid)
        }

        // Binary Lookup helper
        // returns sorted insertion point of value in bids array
        pub fun find(value: UFix64, bids: [UFix64]) : Int {
            var lo = 0
            var hi = bids.length
            while (hi > lo)
            {
                var mid = Int((lo+hi) / 2)
                if ( value <= bids[mid]) {      // too small 
                    lo = mid + 1                // use right side of array
                } else {
                    hi = mid                    // use left side of array
                }
            }
            return hi
        }

        access(contract) fun updateBidStep(_ bidStep: UFix64 ) {
            pre {
                bidStep != self.bidStep : "Bid step already set"
                !self.auctionHasStarted() : "Bid step cannot be changed once auction has started" 
            }
            self.bidStep = bidStep
        }

        pub fun hasBids() : Bool {
            return self.bids.length > 0  
        }

        pub fun auctionHasStarted() : Bool {
            return ListenBatchAuction.now() >= self.startTime
        }
        
        pub fun getAuctionState(): AuctionState {
            let currentTime = ListenBatchAuction.now()
            if (currentTime < self.startTime ){
                return AuctionState.Upcoming
            }

            if (currentTime > self.endTime){
                return AuctionState.Complete
            }

            if (currentTime < self.endTime - ListenBatchAuction.EXTENSION_TIME){
                return AuctionState.Open
            } else {
                return AuctionState.Closing
            }
        }
 
        destroy() {
            if self.nftCollection.getIDs().length > 0 {
                let depositRef = ListenBatchAuction.account.getCapability(ListenNFT.CollectionPublicPath)
                    .borrow<&{NonFungibleToken.CollectionPublic}>()
                    ?? panic("Could not borrow a reference to accounts's collection") // possible safer alternative would be to store in contract 
                
                for id in self.nftCollection.getIDs() {
                    let nft <- self.nftCollection.withdraw(withdrawID: id)
                    depositRef.deposit(token: <- nft)
                }
            }
            destroy self.nftCollection 
            destroy self.bids
        }
    }

    // borrowAuction
    //
    // convenience function to borrow an auction by ID
    access(contract) fun borrowAuction(id: UInt64) : &Auction? {
        if ListenBatchAuction.auctions[id] != nil {
            return &ListenBatchAuction.auctions[id] as &Auction
        } else {
            return nil
        }
    }

    pub struct AuctionMeta {
        pub let startTime : UFix64
        pub let endTime: UFix64
        pub let startingPrice : UFix64
        pub let bidStep : UFix64
        pub let nftIDs : [UInt64]
        pub let currentBids: [UFix64]
        pub let auctionState: String

        init( startTime: UFix64, endTime: UFix64, startingPrice: UFix64, bidStep: UFix64, nftIDs: [UInt64], currentBids: [UFix64], auctionState: String ) {
            self.startTime = startTime
            self.endTime = endTime
            self.startingPrice = startingPrice
            self.bidStep = bidStep
            self.nftIDs = nftIDs
            self.currentBids = currentBids
            self.auctionState = auctionState
        } 
    }

    pub enum AuctionState: UInt8 {
        pub case Open
        pub case Closing
        pub case Complete
        pub case Upcoming
    }

    pub fun stateToString(_ auctionState: AuctionState): String {
        switch auctionState{
            case AuctionState.Open:
                return "Open"
            case AuctionState.Closing:
                return "Closing"
            case AuctionState.Complete:
                return "Complete"
            case AuctionState.Upcoming:
                return "Upcoming"
            default:
                return "Upcoming"
        }
    }

    pub fun getAuctionMeta( auctionID: UInt64 ) : AuctionMeta {
        let auctionRef = ListenBatchAuction.borrowAuction( id: auctionID ) ?? panic("No Auction with that ID exists")    
        let auctionState = ListenBatchAuction.stateToString( auctionRef.getAuctionState() )

        return AuctionMeta( startTime: auctionRef.startTime, 
                            endTime: auctionRef.endTime, 
                            startingPrice: auctionRef.startingPrice, 
                            bidStep: auctionRef.bidStep,
                            nftIDs: auctionRef.nftCollection.getIDs(), 
                            currentBids: auctionRef.getBidValues(),
                            auctionState: auctionState )
    }

    pub fun getAuctions() : [UInt64] {
        return ListenBatchAuction.auctions.keys
    }

    pub resource Bid {
        pub var vault: @ListenUSD.Vault
        pub var ftReceiverCap: Capability<&{FungibleToken.Receiver}>? 
        pub var nftReceiverCap: Capability<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>?

        init(   funds: @ListenUSD.Vault, 
                ftReceiverCap: Capability<&{FungibleToken.Receiver}>?,
                nftReceiverCap: Capability<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>?) {
            self.vault <- funds
            self.ftReceiverCap =  ftReceiverCap
            self.nftReceiverCap = nftReceiverCap
        }

        access(contract) fun returnBidToOwner() {
            let ftReceiverCap = self.ftReceiverCap!
            var ownersVaultRef = ftReceiverCap.borrow()! 
            let funds <- self.vault.withdraw(amount: self.vault.balance)
            ownersVaultRef.deposit( from: <- funds )
        }

        destroy() {
            if self.vault.balance > 0.0 {
                self.returnBidToOwner() 
            }
            destroy self.vault
        }
    }

    pub fun now() : UFix64 {
        return getCurrentBlock().timestamp
    }

    // Function to place Bid
    pub fun placeBid( 
                auctionID: UInt64, 
                funds: @ListenUSD.Vault, 
                ftReceiverCap: Capability<&{FungibleToken.Receiver}>,
                nftReceiverCap: Capability<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>
            ) {

        let auctionRef = ListenBatchAuction.borrowAuction(id: auctionID) ?? panic("Auction ID does not exist")
        assert( funds.balance >= auctionRef.startingPrice, message: "Bid must be above starting bid" )
        assert( ListenBatchAuction.now() > auctionRef.startTime, message: "Auction hasn't started")
        assert( ListenBatchAuction.now() < auctionRef.endTime, message: "Auction has finished")

        let newBidAmount = funds.balance
        
        if auctionRef.hasBids() {
            let lowestBidRef = &auctionRef.bids[auctionRef.bids.length-1] as &Bid
            let currentLowestBid = lowestBidRef.vault.balance
            let insertionPosition = auctionRef.find(value: newBidAmount, bids: auctionRef.getBidValues())
            let nearestBid =  &auctionRef.bids[insertionPosition] as &Bid
            let nearestBidValue = nearestBid.vault.balance
            // bid step only enforced after first bid is placed
            assert( newBidAmount >= nearestBidValue + auctionRef.bidStep , message: "Bid must be greater than lowest bid + bid step" )
            // we only need to track as many bids as there are prizes, anything else we pop off the stack 
            log(auctionRef.bids.length)
            log(auctionRef.nftCollection.getIDs().length)
            if auctionRef.bids.length >= auctionRef.nftCollection.getIDs().length {
                log("return bid to owner")
                lowestBidRef.returnBidToOwner()
                log(lowestBidRef.vault.balance)
                destroy <- auctionRef.bids.removeLast()
            }
        } 

        // create new bid
        var bid <- create Bid(funds: <- funds, ftReceiverCap: ftReceiverCap, nftReceiverCap: nftReceiverCap)
        auctionRef.placeBid( bid: <- bid)
        
        // extend auction endTime if bid is in final 30mins
        if (ListenBatchAuction.now() > auctionRef.endTime - ListenBatchAuction.EXTENSION_TIME ) {
            auctionRef.extendAuction()
        }

        emit BidPlaced( auctionID: auctionID, biddersAddress: ftReceiverCap.address, amount: newBidAmount )
    }

    pub resource Admin {
        pub fun createAuction(  startTime: UFix64, 
                                duration: UFix64, 
                                startingPrice: UFix64, 
                                bidStep: UFix64, 
                                nftCollection: @ListenNFT.Collection) {
            
            var auction <- create Auction(  startTime: startTime, 
                                            endTime: startTime + duration, 
                                            startingPrice: startingPrice, 
                                            bidStep: bidStep, 
                                            nftCollection: <- nftCollection)

            emit AuctionCreated(    startTime: auction.startTime, 
                                    endTime: auction.endTime, 
                                    startingPrice: auction.startingPrice, 
                                    bidStep: auction.bidStep, 
                                    prizeIDs: auction.nftCollection.getIDs() )
            
            let temp <- ListenBatchAuction.auctions.insert(key: ListenBatchAuction.nextID, <- auction)
            destroy temp
            
            ListenBatchAuction.nextID = ListenBatchAuction.nextID + 1
        }


        pub fun updateExtensionTime(duration: UFix64) {
            ListenBatchAuction.EXTENSION_TIME = duration
        } 

        pub fun settleAuction( auctionID: UInt64 ) {
            let auctionRef = ListenBatchAuction.borrowAuction(id: auctionID)!
            let finalSalePrices = auctionRef.getBidValues()

            assert( ListenBatchAuction.now() > auctionRef.endTime, message: "Auction must be finished to settle")
            let ftReceiverCap = ListenBatchAuction.account.getCapability(ListenUSD.ReceiverPublicPath) 
            let auctionHouseVaultRef = ftReceiverCap.borrow<&{FungibleToken.Receiver}>()!
            let winnersAddresses: [Address] = []
            var i = 0 
            while i < auctionRef.bids.length {
                let bidRef = &auctionRef.bids[i] as &Bid
                var nftReceiverCap = bidRef.nftReceiverCap as Capability<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>?
                let fallbackNFTReceiver = ListenBatchAuction.account.getCapability<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>(ListenNFT.CollectionPublicPath)
                // in case no bids there will be no receiverCap so return nft to collection in account where contract is deployed
                // also if capability has been unlinked or replaced with different type will use fallbackNFTReceiver 
                if !nftReceiverCap!.check() {
                    nftReceiverCap = fallbackNFTReceiver
                }
                let receiverRef = nftReceiverCap!.borrow()!
                let id = auctionRef.nftCollection.getIDs()[0] // peel the prizes from the top
                let nft <- auctionRef.nftCollection.withdraw(withdrawID: id)
                receiverRef.deposit(token: <- nft)
                winnersAddresses.append(nftReceiverCap!.address)
                let funds <- bidRef.vault.withdraw(amount: bidRef.vault.balance)
                auctionHouseVaultRef.deposit(from: <- funds)
                i = i + 1
            }
            let auction <- ListenBatchAuction.auctions.remove(key: auctionID)
            destroy auction

            emit AuctionSettled(id: auctionID, winnersAddresses: winnersAddresses, finalSalesPrices: finalSalePrices)
        }

    }

    init() {
        self.nextID = 0
        self.auctions <- {}

        self.EXTENSION_TIME = 1800.0 // = 30 * 60 seconds

        self.AdminStoragePath = /storage/ListenBatchAuctionAdmin
        self.AdminCapabilityPath = /private/ListenBatchAuctionAdmin

        self.account.save(<- create Admin(), to: ListenBatchAuction.AdminStoragePath)
        self.account.link<&ListenBatchAuction.Admin>(ListenBatchAuction.AdminCapabilityPath, target: ListenBatchAuction.AdminStoragePath)

        emit ContractDeployed()
    }
}
 