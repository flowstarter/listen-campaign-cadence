import ListenBatchAuction from "../../contracts/ListenBatchAuction.cdc"

pub fun main(): [UInt64] {
    return ListenBatchAuction.getAuctions()
}