import ListenAuction from "../../contracts/ListenAuction.cdc"

pub fun main(): [ListenAuction.AuctionMeta] {
    return ListenAuction.getMetadata_Auctions()
}
