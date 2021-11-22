import ListenAuction from "../../contracts/ListenAuction.cdc"

pub fun main(auctionState: String): [ListenAuction.AuctionMeta] { 
    let auctionsMeta : [ListenAuction.AuctionMeta] = []
    for auctionId in ListenAuction.getAuctionIDs() {
        let auction: ListenAuction.AuctionMeta = ListenAuction.getAuctionMeta(auctionID: auctionId)
        if auction.auctionState ==  auctionState {
            auctionsMeta.append(auction)
        }
    }     
    return auctionsMeta
}