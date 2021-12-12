import ListenAuction from "../../contracts/ListenAuction.cdc"

pub fun main(auctionState: String, position: UInt64): [ListenAuction.AuctionMeta] { 
    let auctionsMeta : [ListenAuction.AuctionMeta] = []
    for auctionId in ListenAuction.getAuctionIDs() {
        let auction: ListenAuction.AuctionMeta = ListenAuction.getAuctionMeta(auctionID: auctionId)
        if (auction.auctionState ==  auctionState)  && (auction.position == position) {
            auctionsMeta.append(auction)
        }
    }     
    return auctionsMeta
}