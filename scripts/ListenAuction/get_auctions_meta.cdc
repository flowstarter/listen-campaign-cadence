import ListenAuction from "../../contracts/ListenAuction.cdc"

pub fun main(): [{UInt64:ListenAuction.AuctionMeta}] {
    let auctionsMeta : [{UInt64: ListenAuction.AuctionMeta}] = []
    for auctionId in ListenAuction.getAuctionIDs() {
        let auction: ListenAuction.AuctionMeta = ListenAuction.getAuctionMeta(auctionID: auctionId)
        if auction.auctionState != ListenAuction.stateToString(AuctionState.Complete) {
            auctionsMeta.append({auctionId : auction})
        }
    }     
    return auctionsMeta
}