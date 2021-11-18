import ListenBatchAuction from "../../contracts/ListenBatchAuction.cdc"

pub fun main(auctionID: UInt64): ListenBatchAuction.AuctionMeta {
    return ListenBatchAuction.getAuctionMeta(auctionID: auctionID)
}
