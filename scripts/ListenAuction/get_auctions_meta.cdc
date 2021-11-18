import ListenAuction from "../../contracts/ListenAuction.cdc"

pub fun main(): [{UInt64:ListenAuction.AuctionMeta}] {
    return ListenAuction.getMetadataAuctions()
}
