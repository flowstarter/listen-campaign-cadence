import ListenBatchAuction from "../../contracts/ListenBatchAuction.cdc"

transaction( duration: UFix64) {

    prepare(acct: AuthAccount) {
        let admin = acct.borrow<&ListenBatchAuction.Admin>(from: ListenBatchAuction.AdminStoragePath) ?? panic("Could not borrow ListenAuction.Admin")
        admin.updateExtensionTime(duration: duration)
    }
}
