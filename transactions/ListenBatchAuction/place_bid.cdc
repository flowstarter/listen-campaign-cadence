import FungibleToken from "../../contracts/dependencies/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/dependencies/NonFungibleToken.cdc"
import ListenUSD from "../../contracts/ListenUSD.cdc"
import ListenNFT from "../../contracts/ListenNFT.cdc"
import ListenBatchAuction from "../../contracts/ListenBatchAuction.cdc"

transaction(auctionID: UInt64, amount: UFix64) {

    // The Vault resource that holds the tokens that are being transferred
    let sentVault: @ListenUSD.Vault
    // The Fungible And NonFungible Token Receiver Capabilities allow the contract to return tokens to the account
    let ftReceiverCap: Capability<&{FungibleToken.Receiver}>
    let nftReceiverCap: Capability<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>

    prepare(signer: AuthAccount) {

        // Get a reference to the signer's stored vault
        let vaultRef = signer.borrow<&ListenUSD.Vault>(from: ListenUSD.VaultStoragePath)
			?? panic("Could not borrow reference to the owner's Vault!")

        self.ftReceiverCap = signer.getCapability<&{FungibleToken.Receiver}>(ListenUSD.ReceiverPublicPath)
        assert(self.ftReceiverCap.borrow() != nil, message: "Missing or mis-typed ListenUSD receiver")
        
        self.nftReceiverCap = signer.getCapability<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>(ListenNFT.CollectionPublicPath)
        assert(self.nftReceiverCap.borrow() != nil, message: "Missing or mis-typed ListenNFT.Collection provider")

        // Withdraw tokens from the signer's stored vault
        let ftVault <- vaultRef.withdraw(amount: amount)
        self.sentVault <- ftVault as! @ListenUSD.Vault
    }

    execute {
        ListenBatchAuction.placeBid( auctionID: auctionID, funds: <- self.sentVault, ftReceiverCap: self.ftReceiverCap, nftReceiverCap: self.nftReceiverCap)
    }
}
