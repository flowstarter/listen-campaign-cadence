import FungibleToken from "../../contracts/dependencies/FungibleToken.cdc"
import ListenUSD from "../../contracts/ListenUSD.cdc"
import ListenNFT from "../../contracts/ListenNFT.cdc"
import ListenAuction from "../../contracts/ListenAuction.cdc"

transaction(auctionID: UInt64, amount: UFix64) {

    // The Vault resource that holds the tokens that are being transferred
    let sentVault: @ListenUSD.Vault
    // the Fungibel TOken Receiver Capability allows the contract to return tokens to the account
    let ftReceiverCap: Capability // <ListenUSD.Receiver>
    let nftReceiverCap: Capability

    prepare(signer: AuthAccount) {

        // Get a reference to the signer's stored vault
        let vaultRef = signer.borrow<&ListenUSD.Vault>(from: ListenUSD.VaultStoragePath)
			?? panic("Could not borrow reference to the owner's Vault!")

        self.ftReceiverCap = signer.getCapability(ListenUSD.ReceiverPublicPath)
        self.nftReceiverCap = signer.getCapability(ListenNFT.CollectionPublicPath)

        // Withdraw tokens from the signer's stored vault
        let ftVault <- vaultRef.withdraw(amount: amount)
        self.sentVault <- ftVault as! @ListenUSD.Vault
    }

    execute {
        ListenAuction.placeBid( auctionID: auctionID, funds: <- self.sentVault, ftReceiverCap: self.ftReceiverCap, nftReceiverCap: self.nftReceiverCap)
    }
}
