import ListenAuction from "../../contracts/ListenAuction.cdc"

pub fun main(auctionState: String): [ListenAuction.AuctionMeta] {
    return ListenAuction.getMetadataAuctionsByStatus(auctionState:auctionState)
}
