import NonFungibleToken from "../../contracts/dependencies/NonFungibleToken.cdc"
import ListenNFT from "../../contracts/ListenNFT.cdc"

// This transaction returns an array of all the nft ids in the collection

pub fun main(address: Address): [{UInt64: {String:String}}] {

    let collectionRef = getAccount(address)
        .getCapability(ListenNFT.CollectionPublicPath)
        .borrow<&{ListenNFT.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.getExistsNFTs()
}