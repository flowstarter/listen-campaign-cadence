import NonFungibleToken from "../../contracts/dependencies/NonFungibleToken.cdc"
import ListenNFT from "../../contracts/ListenNFT.cdc"

transaction {

    prepare(acct: AuthAccount) {

        // Return early if the account already has a collection
        if acct.borrow<&ListenNFT.Collection>(from: ListenNFT.CollectionStoragePath) != nil {
            log("account already has ListenNFT.Collection")
            return
        }

        // Create a new empty collection
        let collection <- ListenNFT.createEmptyCollection()

        // save it to the account
        acct.save(<-collection, to: ListenNFT.CollectionStoragePath)

        // create a public capability for the collection
        acct.link<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>(
            ListenNFT.CollectionPublicPath,
            target: ListenNFT.CollectionStoragePath
        )

        log("saved and linked collection ")
    }
}
