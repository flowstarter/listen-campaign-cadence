import NonFungibleToken from "../../contracts/dependencies/NonFungibleToken.cdc"
import ListenNFT from "../../contracts/ListenNFT.cdc"
import ListenAuction from "../../contracts/ListenAuction.cdc"

transaction(auctionID: UInt64, position: UInt64) {

    prepare(acct: AuthAccount) {
        let admin = acct.borrow<&ListenAuction.Admin>(from: ListenAuction.AdminStoragePath) ?? panic("Could not borrow ListenAuction.Admin")
        admin.updatePosition(auctionID: auctionID, position: position)
    }
}
