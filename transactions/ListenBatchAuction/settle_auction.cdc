import NonFungibleToken from "../../contracts/dependencies/NonFungibleToken.cdc"
import ListenNFT from "../../contracts/ListenNFT.cdc"
import ListenBatchAuction from "../../contracts/ListenBatchAuction.cdc"

transaction( auctionID: UInt64) {

    prepare(acct: AuthAccount) {
        let admin = acct.borrow<&ListenBatchAuction.Admin>(from: ListenBatchAuction.AdminStoragePath) ?? panic("Could not borrow ListenAuction.Admin")
        admin.settleAuction(auctionID: auctionID)
    }
}
