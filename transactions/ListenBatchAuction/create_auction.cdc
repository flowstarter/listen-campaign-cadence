// This Transaction template creates a single auction for a single NFT.

import NonFungibleToken from "../../contracts/dependencies/NonFungibleToken.cdc"
import ListenNFT from "../../contracts/ListenNFT.cdc"
import ListenBatchAuction from "../../contracts/ListenBatchAuction.cdc"

transaction( startTime: UFix64, duration: UFix64, startingPrice: UFix64, bidStep: UFix64, tokenIDs: [UInt64]) {

    prepare(acct: AuthAccount) {
        // Auction starts x seconds from now...... 
        // for convenince when testing remove in production and pass in startTime as unix starttime
        let startAt = ListenBatchAuction.now() + startTime 

        let collectionRef = acct.borrow<&ListenNFT.Collection>(from: ListenNFT.CollectionStoragePath)
            ?? panic("Could not borrow a reference to the owner's collection")

        let auctionPrizeCollection <- ListenNFT.createEmptyCollection() as! @ListenNFT.Collection
        for tokenID in tokenIDs {
            let prizeNFT <- collectionRef.withdraw(withdrawID: tokenID) as! @ListenNFT.NFT // as! @NonFungibleToken.NFT
            auctionPrizeCollection.deposit(token: <- prizeNFT)
        }
        
        let admin = acct.borrow<&ListenBatchAuction.Admin>(from: ListenBatchAuction.AdminStoragePath)!
        admin.createAuction( startTime: startAt, duration: duration, startingPrice: startingPrice, bidStep: bidStep, nftCollection: <- auctionPrizeCollection )
    }
}
