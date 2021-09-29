// ListenNFT NFT Contract
//
// Extends the NonFungibleToken standard with an ipfs pin field and metadata for each ListenNFT. 

import NonFungibleToken from "./dependencies/NonFungibleToken.cdc"

pub contract ListenNFT: NonFungibleToken {

    // Total number of ListenNFT's in existance
    pub var totalSupply: UInt64 

    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)

    pub let MinterStoragePath : StoragePath 
    pub let CollectionStoragePath : StoragePath     
    pub let CollectionPublicPath : PublicPath      

    // ListenNFTPublic
    //
    // allows access to read the metadata and ipfs pin of the nft
    pub resource interface ListenNFTPublic {
        pub fun getMetadata() : {String:String}
        pub let ipfsPin: String
    } 

    pub resource NFT: NonFungibleToken.INFT, ListenNFTPublic {
        pub let id: UInt64

        // Meta data initalized on creation and unalterable
        access(contract) let metadata: {String: String}

        // string with ipfs pin of media data
        pub let ipfsPin: String

        init(initID: UInt64, metadata: {String: String}, ipfsPin: String) {
            self.id = initID
            self.ipfsPin = ipfsPin
            self.metadata = metadata
        }

        pub fun getMetadata() : {String:String} {
            let metadata = self.metadata
            metadata.insert(key: "ipfsPin", self.ipfsPin)
            return metadata
        }
    }


    // Public Interface for ListenNFTs Collection to expose metadata as required.
    pub resource interface CollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowListenNFT(id:UInt64) : &ListenNFT.NFT? {
            // If the result isn't nil, the id of the returned reference
            // should be the same as the argument to the function
            post {
                (result == nil) || (result?.id == id):
                    "Cannot borrow ListenNFT reference: The ID of the returned reference is incorrect"
            }
        }
    }

    // standard implmentation for managing a collection of NFTs
    pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, CollectionPublic {
        // dictionary of NFT conforming tokens
        // NFT is a resource type with an `UInt64` ID field
        // pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        init () {
            self.ownedNFTs <- {}
        }

        // withdraw removes an NFT from the collection and moves it to the caller
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")
            emit Withdraw(id: token.id, from: self.owner?.address)
            return <-token
        }

        // deposit takes a NFT and adds it to the collections dictionary
        // and adds the ID to the id array
        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @ListenNFT.NFT

            let id: UInt64 = token.id

            // add the new token to the dictionary which removes the old one
            let oldToken <- self.ownedNFTs[id] <- token

            emit Deposit(id: id, to: self.owner?.address)

            destroy oldToken
        }

        // getIDs returns an array of the IDs that are in the collection
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        // borrowNFT gets a reference to an NFT in the collection
        // so that the caller can read its metadata and call its methods
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return &self.ownedNFTs[id] as &NonFungibleToken.NFT
        }

        // borrowListenNFT gets a reference to an ListenNFT from the collection
        // so the caller can read the NFT's extended information
        pub fun borrowListenNFT(id: UInt64): &ListenNFT.NFT? {
            if self.ownedNFTs[id] != nil {
                    let ref = &self.ownedNFTs[id] as auth &NonFungibleToken.NFT
                    return ref as! &ListenNFT.NFT
                } else {
                    return nil
            }
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    // public function that anyone can call to create a new empty collection
    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    // Resource that an admin or something similar would own to be
    // able to mint new NFTs
    //
    pub resource NFTMinter {

        // mintNFT mints a new NFT with a new ID
        // and deposit it in the recipients collection using their collection reference
        pub fun mintNFT(recipient: &{NonFungibleToken.CollectionPublic}, metadata: {String: String}, ipfsPin: String) {

            // create a new NFT
            var newNFT <- create NFT(initID: ListenNFT.totalSupply, metadata: metadata, ipfsPin: ipfsPin)

            // deposit it in the recipient's account using their reference
            recipient.deposit(token: <-newNFT)

            ListenNFT.totalSupply = ListenNFT.totalSupply + (1 as UInt64)
        }
    }

    init() {
        // Initialize the total supply
        self.totalSupply = 0

        // Initalize paths for scripts and transactions usage
        self.MinterStoragePath = /storage/ListenNFTMinter
        self.CollectionStoragePath = /storage/ListenNFTCollection
        self.CollectionPublicPath = /public/ListenNFTCollection

        // Create a Collection resource and save it to storage
        let collection <- create Collection()
        self.account.save(<-collection, to: ListenNFT.CollectionStoragePath)

        // create a public capability for the collection
        self.account.link<&{NonFungibleToken.CollectionPublic, ListenNFT.CollectionPublic}>(
            ListenNFT.CollectionPublicPath,
            target: ListenNFT.CollectionStoragePath
        )

        // Create a Minter resource and save it to storage
        let minter <- create NFTMinter()

        self.account.save(<-minter, to: ListenNFT.MinterStoragePath)

        emit ContractInitialized()
    }
}
 