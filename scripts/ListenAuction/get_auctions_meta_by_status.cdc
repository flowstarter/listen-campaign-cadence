import ListenAuction from "../../contracts/ListenAuction.cdc"

pub fun main(auctionState: String): [{UInt64:ListenAuction.AuctionMeta}] { 
    let auctionsMeta : [{UInt64: ListenAuction.AuctionMeta}] = []
    for auctionId in ListenAuction.getAuctionIDs() {
        let auction: ListenAuction.AuctionMeta = ListenAuction.getAuctionMeta(auctionID: auctionId)
        if auction.auctionState ==  auctionState {
            auctionsMeta.append({auctionId : auction})
        }
    }     
    return auctionsMeta
}