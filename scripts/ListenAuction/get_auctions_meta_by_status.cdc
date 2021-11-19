import ListenAuction from "../../contracts/ListenAuction.cdc"

pub fun main(auctionState: String): [{UInt64:ListenAuction.AuctionMeta}] {
    return ListenAuction.getMetadataAuctionsByStatus(auctionState:auctionState)
}
