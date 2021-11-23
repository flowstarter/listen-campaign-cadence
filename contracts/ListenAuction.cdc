/*
    ListenAuction 
    Author: Flowstarter
    Auction Resource represents an Auction and is always held internally by the contract
    Admin resource is required to create Auctions
 */

import FungibleToken from "./dependencies/FungibleToken.cdc"
import NonFungibleToken from "./dependencies/NonFungibleToken.cdc"

import ListenNFT from "./ListenNFT.cdc"
import ListenUSD from "./ListenUSD.cdc"

pub contract ListenAuction {

    access(contract) var nextID: UInt64                 // internal ticker for auctionIDs
    access(contract) var auctions: @{UInt64 : Auction}  // Dictionary of Auctions in existence

    access(contract) var EXTENSION_TIME : UFix64        // Currently globally set for all running auctions, consider refactoring to per auction basis for flexibility
    
    pub let AdminStoragePath : StoragePath
    pub let AdminCapabilityPath : CapabilityPath

    pub event ContractDeployed()
    pub event AuctionCreated(auctionID: UInt64, startTime: UFix64, endTime: UFix64, startingPrice: UFix64, bidStep: UFix64, prizeIDs: [UInt64] )
    pub event BidPlaced( auctionID: UInt64, bidderAddress: String, amount: UFix64 )
    pub event AuctionExtended( auctionID: UInt64, endTime: UFix64 )
    pub event AuctionSettled(id: UInt64, winnersAddresses: [String], finalSalesPrices: [UFix64])
    pub event AuctionRemoved(auctionID: UInt64)

    pub resource Auction {
        access(contract) let startingPrice : UFix64
        access(contract) var bidStep : UFix64       // New bids must be at least bidStep greater than current highest bid
        access(contract) let startTime : UFix64
        
        access(contract) var nftCollection : @ListenNFT.Collection 
        access(contract) var endTime : UFix64       // variable as can be extended if there is a bid in last 30min
        access(contract) var bids : @[Bid]     
        access(contract) var history : [History]
        
        init( startTime: UFix64, endTime: UFix64, startingPrice: UFix64, bidStep: UFix64, nftCollection: @ListenNFT.Collection) {
            self.startTime = startTime
            self.endTime = endTime
            self.startingPrice = startingPrice
            self.bidStep = bidStep
            self.nftCollection <- nftCollection
            self.bids <- []
            self.history = []
        }

        access(contract) fun extendAuction() {
            self.endTime = self.endTime + ListenAuction.EXTENSION_TIME
        }

        access(contract) fun placeBid( bid: @ListenAuction.Bid ) {
            let insertionPosition = self.find(value: bid.vault.balance, bids: self.getBidValues())
            self.bids.insert(at: insertionPosition, <- bid)
        }

        access(contract) fun updateHistory(history: History) {
            self.history.append(history)
        }

        access(contract) fun getHistory(): [History]{
            return self.history
        }

        access(contract) fun updateBidStep(_ bidStep: UFix64 ) {
            pre {
                bidStep != self.bidStep : "Bid step already set"
                !self.auctionHasStarted() : "Bid step cannot be changed once auction has started" 
            }
            self.bidStep = bidStep
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



        pub fun auctionHasStarted() : Bool {
            return ListenAuction.now() >= self.startTime
        }
        
        pub fun getAuctionState(): AuctionState {
            let currentTime = ListenAuction.now()
            if currentTime < self.startTime {
                return AuctionState.Upcoming
            }

            if currentTime >= self.endTime {
                return AuctionState.Complete
            }

            if currentTime < self.endTime - ListenAuction.EXTENSION_TIME {
                return AuctionState.Open
            }

            return AuctionState.Closing
        }
        destroy() {
            if self.nftCollection.getIDs().length > 0 {
                let depositRef = ListenAuction.account.getCapability(ListenNFT.CollectionPublicPath)
                    .borrow<&{NonFungibleToken.CollectionPublic}>()
                    ?? panic("Could not borrow a reference to accounts's collection") // possible safer alternative would be to store in contract 
                
                for id in self.nftCollection.getIDs() {
                    let nft <- self.nftCollection.withdraw(withdrawID: id)
                    depositRef.deposit(token: <- nft)
                }
            }
            destroy self.nftCollection
            if self.bids.length > 0 {
                var i=0
                while i < self.bids.length {
                    self.bids[i].returnBidToOwner()
                    i = i + 1
                }
            }
            destroy self.bids
        }
    }

    pub struct History{
        pub let auctionID : UInt64
        pub let amount: UFix64
        pub let time : UFix64
        pub let bidderAddress : String

        init(auctionID: UInt64, amount: UFix64, time: UFix64, bidderAddress: String ) {
            self.auctionID = auctionID
            self.amount = amount
            self.time = time
            self.bidderAddress = bidderAddress
        }
    }

    pub resource Bid {
        pub var vault: @ListenUSD.Vault
        pub var ftReceiverCap: Capability<&{FungibleToken.Receiver}>?
        pub var nftReceiverCap:Capability<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>?

        init( funds: @ListenUSD.Vault, ftReceiverCap: Capability<&{FungibleToken.Receiver}>?, nftReceiverCap: Capability<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>?) {
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

    pub resource Admin {
        pub fun createAuction(startTime: UFix64, duration: UFix64, startingPrice: UFix64, bidStep: UFix64, nftCollection: @ListenNFT.Collection) {
            var auction <- create Auction(startTime: startTime, endTime: startTime + duration, startingPrice: startingPrice, bidStep: bidStep, nftCollection: <- nftCollection)
            emit AuctionCreated(auctionID: ListenAuction.nextID, startTime: auction.startTime, endTime: auction.endTime, startingPrice: auction.startingPrice, bidStep: auction.bidStep, prizeIDs: auction.nftCollection.getIDs() )
            
            let temp <- ListenAuction.auctions.insert(key: ListenAuction.nextID, <- auction)
            destroy temp
            
            ListenAuction.nextID = ListenAuction.nextID + 1
        }

        pub fun removeAuction(auctionID: UInt64) {
            let auctionRef = ListenAuction.borrowAuction(id: auctionID) ?? panic("Auction ID does not exist")
            assert( auctionRef.bids.length > 0, message: "Auction still has bids, can't remove")
            for id in auctionRef.nftCollection.getIDs() {
                let nft <- auctionRef.nftCollection.withdraw(withdrawID: id)
                destroy nft
            }

            let auction <- ListenAuction.auctions.remove(key: auctionID)
            destroy auction

            emit AuctionRemoved(auctionID:auctionID)
        }

        pub fun updateExtensionTime(duration: UFix64) {
            pre {
                ListenAuction.auctions.keys.length == 0 : "Must be no active auctions to update rules"
            }
            ListenAuction.EXTENSION_TIME = duration
        }

        pub fun settleAuction( auctionID: UInt64 ) {
            let auctionRef = ListenAuction.borrowAuction(id: auctionID)!
            let finalSalesPrices = auctionRef.getBidValues()

            assert( ListenAuction.now() > auctionRef.endTime, message: "Auction must be finished to settle")
            let ftReceiverCap = ListenAuction.account.getCapability(ListenUSD.ReceiverPublicPath) 
            let auctionHouseVaultRef = ftReceiverCap.borrow<&{FungibleToken.Receiver}>()!
            let winnersAddresses: [String] = []
            var i = 0 
            while i < auctionRef.bids.length {
                let bidRef = &auctionRef.bids[i] as &Bid
                var nftReceiverCap = bidRef.nftReceiverCap as Capability<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>?
                let fallbackNFTReceiver = ListenAuction.account.getCapability<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>(ListenNFT.CollectionPublicPath)
                // in case no bids there will be no receiverCap so return nft to collection in account where contract is deployed
                // also if capability has been unlinked or replaced with different type will use fallbackNFTReceiver 
                if !nftReceiverCap!.check() {
                    nftReceiverCap = fallbackNFTReceiver
                }
                let receiverRef = nftReceiverCap!.borrow()!
                let id = auctionRef.nftCollection.getIDs()[0] // peel the prizes from the top
                let nft <- auctionRef.nftCollection.withdraw(withdrawID: id)
                receiverRef.deposit(token: <- nft)
                winnersAddresses.append(nftReceiverCap!.address.toString())
                let funds <- bidRef.vault.withdraw(amount: bidRef.vault.balance)
                auctionHouseVaultRef.deposit(from: <- funds)
                i = i + 1
            }
            let auction <- ListenAuction.auctions.remove(key: auctionID)
            destroy auction

            emit AuctionSettled(id: auctionID, winnersAddresses: winnersAddresses, finalSalesPrices: finalSalesPrices)
        }
    }

    pub struct AuctionMeta {
        pub let auctionID: UInt64
        pub let startTime : UFix64
        pub let endTime: UFix64
        pub let startingPrice : UFix64
        pub let bidStep : UFix64
        pub let nftIDs : [UInt64]
        pub let nftCollection: [{String:String}]
        pub let currentBids: [UFix64]
        pub let auctionState: String
        pub let history: [History]

        init( auctionID: UInt64, startTime: UFix64, endTime: UFix64, startingPrice: UFix64, 
                bidStep: UFix64, nftIDs: [UInt64], nftCollection: [{String:String}],
                currentBids: [UFix64], auctionState: String, history: [History]) {
            self.auctionID = auctionID
            self.startTime = startTime
            self.endTime = endTime
            self.startingPrice = startingPrice
            self.bidStep = bidStep
            self.nftIDs = nftIDs
            self.nftCollection = nftCollection
            self.currentBids = currentBids
            self.auctionState = auctionState
            self.history = history
        }
    }

    pub enum AuctionState: UInt8 {
        pub case Open
        pub case Closing
        pub case Complete
        pub case Upcoming
    }

    pub fun now() : UFix64 {
        return getCurrentBlock().timestamp
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

    // borrowAuction
    //
    // convenience function to borrow an auction by ID
    access(contract) fun borrowAuction( id: UInt64) : &Auction? {
        if ListenAuction.auctions[id] != nil {
            return &ListenAuction.auctions[id] as &Auction
        } else {
            return nil
        }
    }

    pub fun getAuctionMeta( auctionID: UInt64 ) : AuctionMeta {
        let auctionRef = ListenAuction.borrowAuction( id: auctionID ) ?? panic("No Auction with that ID exists")

        let auctionState = ListenAuction.stateToString(auctionRef.getAuctionState())

        let history: [History] = auctionRef.getHistory()
        let nftCollection : [{String:String}] = []
        for id in auctionRef.nftCollection.getIDs() {
            nftCollection.append(auctionRef.nftCollection.getListenNFTMetadata(id: id))
        }
        return AuctionMeta( 
            auctionID: auctionID,
            startTime: auctionRef.startTime, 
            endTime: auctionRef.endTime, 
            startingPrice: auctionRef.startingPrice, 
            bidStep: auctionRef.bidStep,
            nftIDs: auctionRef.nftCollection.getIDs(), 
            nftCollection: nftCollection, 
            currentBids: auctionRef.getBidValues(),
            auctionState: auctionState,
            history: history)
    }

       pub fun placeBid( 
                auctionID: UInt64, 
                funds: @ListenUSD.Vault, 
                ftReceiverCap: Capability<&{FungibleToken.Receiver}>,
                nftReceiverCap: Capability<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>
            ) {

        let auctionRef = ListenAuction.borrowAuction(id: auctionID) ?? panic("Auction ID does not exist")
        assert( funds.balance >= auctionRef.startingPrice, message: "Bid must be above starting bid" )
        assert( ListenAuction.now() > auctionRef.startTime, message: "Auction hasn't started")
        assert( ListenAuction.now() < auctionRef.endTime, message: "Auction has finished")

        let newBidAmount = funds.balance
        
        if auctionRef.bids.length > 0 {
            let lowestBidRef = &auctionRef.bids[auctionRef.bids.length-1] as &Bid
            let currentLowestBid = lowestBidRef.vault.balance
            let insertionPosition = auctionRef.find(value: newBidAmount, bids: auctionRef.getBidValues())
            let nearestBid =  &auctionRef.bids[insertionPosition] as &Bid
            let nearestBidValue = nearestBid.vault.balance
            assert( newBidAmount >= nearestBidValue + auctionRef.bidStep , message: "Bid must be greater than closest bid + bid step" )
            // we only need to track as many bids as there are prizes, anything else we pop off the stack and return to the owner of the bid
            if auctionRef.bids.length >= auctionRef.nftCollection.getIDs().length  {
                log("return bid to owner")
                lowestBidRef.returnBidToOwner()
                log(lowestBidRef.vault.balance)
                destroy <- auctionRef.bids.removeLast()
            }
        } 

        // create new bid
        let bid <- create Bid(funds: <- funds, ftReceiverCap: ftReceiverCap, nftReceiverCap: nftReceiverCap)
        auctionRef.placeBid( bid: <- bid)
        let history = History(
            auctionID: auctionID,
            amount: newBidAmount,
            time: ListenAuction.now(),
            bidderAddress:ftReceiverCap.address.toString(), 
        )
        auctionRef.updateHistory(history:history)
        // extend auction endTime if bid is in final 30mins
        if (ListenAuction.now() > auctionRef.endTime - ListenAuction.EXTENSION_TIME ) {
            auctionRef.extendAuction()
            emit AuctionExtended( auctionID: auctionID, endTime: auctionRef.endTime)
        }

        emit BidPlaced( auctionID: auctionID, bidderAddress: ftReceiverCap.address.toString(), amount: newBidAmount )
    }
    pub fun getAuctionIDs(): [UInt64] {
        return self.auctions.keys
    }

    init() {
        self.nextID = 0
        self.auctions <- {}

        self.EXTENSION_TIME = 1800.0 // = 30 * 60 seconds

        self.AdminStoragePath = /storage/ListenAuctionAdmin
        self.AdminCapabilityPath = /private/ListenAuctionAdmin

        self.account.save(<- create Admin(), to: ListenAuction.AdminStoragePath)
        self.account.link<&ListenAuction.Admin>(ListenAuction.AdminCapabilityPath, target: ListenAuction.AdminStoragePath)

        emit ContractDeployed()
    }
}
 