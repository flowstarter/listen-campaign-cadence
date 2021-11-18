import FungibleToken from "../../contracts/dependencies/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/dependencies/NonFungibleToken.cdc"
import ListenUSD from "../../contracts/ListenUSD.cdc"
import ListenNFT from "../../contracts/ListenNFT.cdc"

// This transaction is a template for a transaction
// to add a Vault resource to their account
// so that they can use the ListenUSD

transaction { 

    prepare(signer: AuthAccount) {

        // Return early if the account already has a collection
        let collection = signer.borrow<&ListenNFT.Collection>(from: ListenNFT.CollectionStoragePath) 

        if collection == nil {
            // create a new empty collection
            // save it to the account
            signer.save(<- ListenNFT.createEmptyCollection(), to: ListenNFT.CollectionStoragePath)
        
            // create a public capability for the collection
            signer.link<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>(
                ListenNFT.CollectionPublicPath, target: ListenNFT.CollectionStoragePath)

            log("Saved and linked ListenNFT ")
        }

        let vault = signer.borrow<&ListenUSD.Vault>(from: ListenUSD.VaultStoragePath)
        
        if vault == nil {
            // Create a new ListenUSD Vault and put it in storage
            signer.save(<-ListenUSD.createEmptyVault(), to: ListenUSD.VaultStoragePath)

            // Create a public capability to the Vault that only exposes
            // the deposit function through the Receiver interface
            signer.link<&{FungibleToken.Receiver}>(
                ListenUSD.ReceiverPublicPath, target: ListenUSD.VaultStoragePath)

            // Create a public capability to the Vault that only exposes
            // the balance field through the Balance interface
            signer.link<&{FungibleToken.Balance}>(
                ListenUSD.BalancePublicPath, target: ListenUSD.VaultStoragePath)

            log("Saved and linked ListenUSD ")
        }
    }
}