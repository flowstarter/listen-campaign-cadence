import NonFungibleToken from "../../contracts/dependencies/NonFungibleToken.cdc"
import ListenNFT from "../../contracts/ListenNFT.cdc"

pub fun main(account: Address): {UInt64: {String:String}} {
    let collectionRef = getAccount(account)
        .getCapability(ListenNFT.CollectionPublicPath)
        .borrow<&{ListenNFT.CollectionPublic, NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    var nftsMeta : {UInt64: {String:String}} = {}
    
    for id in collectionRef.getIDs() {
        if collectionRef!.getIDs().contains(id) != nil {
            nftsMeta.insert( 
                key: id, 
                collectionRef.getListenNFTMetadata(id: id)
            )
        }
    }
    return nftsMeta  
}