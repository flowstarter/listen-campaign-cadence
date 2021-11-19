#!/bin/sh

# create accounts
echo "Creating Admin account: 0x01cf0e2f2f715450"
flow accounts create --key="2921bbc5acf75417b09ef1cc7981f2a57cc7ee00df71afaddde94991b6f26fb4da66a4b9bea1ee8a555dbba62626ba7c0437e4c6800d25203c915161bed6e4f2"

echo "Creating User1 account 0x179b6b1cb6755e31"
flow accounts create --key="e5b78d3e1d28ecccaa62bbf869df5b6b06a3f0330a46651b2e29c5a0e53b4cd9659f2a0a0555c6de55caedc08475a81e6670ec62c93acbcfe62a45a20226a323"

echo "Creating User2 account 0xf3fcd2c1a78f5eee"
flow accounts create --key="62410c9c523d7a04f8b5c1b478cbada16d70125be9c8e137baa843a16a430da70d215fb6d6fc9ca68d4b7b3f2e7624db8785006b3fe977e25ca459612178723a"


# Flow tokens required for admin-account to be able to deploy contracts
flow transactions send ./transactions/demo/mintFlowTokens.cdc

# Deploy Project
echo "Deploy project to emulator (as per flow.json config)"
#read -p "Press key to continue ..."
flow project deploy --network=emulator


# Setup ListenNFT Receiver Capabilites for accounts
# setup account for admin-account
flow transactions send ./transactions/ListenNFT/setup_account.cdc --signer="admin-account"
flow transactions send ./transactions/ListenNFT/setup_account.cdc --signer="user-account1"
flow transactions send ./transactions/ListenNFT/setup_account.cdc --signer="user-account2"

# Mint an NFT to user1 account
flow transactions send ./transactions/ListenNFT/mint_nft.cdc --signer="admin-account" \
    --args-json '[
                    {   "type": "Address", 
                        "value": "0x179b6b1cb6755e31"
                    }, 
                    {
                        "type": "Dictionary", 
                        "value": [
                            { 
                                "key": {
                                    "type": "String",
                                    "value": "name"
                                }, 
                                "value": {
                                    "type": "String",
                                    "value": "Listen First"
                                }
                            },
                            {
                                "key": {
                                    "type": "String",
                                    "value": "description"
                                },
                                "value": {
                                    "type": "String",
                                    "value": "The very first Listen NFT!"
                                }
                            },
                            {
                                "key": {
                                    "type": "String",
                                    "value": "mediaUrl"
                                },
                                "value" : {
                                    "type": "String",
                                    "value": "https://media.listencampaign.com/nfts/first-1.png"
                                }
                            },
                            {
                                "key": {
                                    "type": "String",
                                    "value": "media/type"
                                },
                                "value": {
                                    "type": "String",
                                    "value": "image/png"
                                }
                            },
                            {
                                "key": {
                                    "type": "String",
                                    "value": "externalLink"
                                },
                                "value": {
                                    "type": "String",
                                    "value": "https://listencampaign.com/nfts/first-1"
                                }
                            }
                        ]
                    },
                    {   "type": "String", 
                        "value": "QmWPie7Mxt6Xes2e9QsJqm77cVFArqmaLRS5Gogx6cyTpR"
                    }
                ]' \
    --signer="admin-account" 

# Mint a 2nd NFT to user2 account
flow transactions send ./transactions/ListenNFT/mint_nft.cdc \
    --args-json '[
                    {   "type": "Address", 
                        "value": "0xf3fcd2c1a78f5eee"
                    }, 
                    {
                        "type": "Dictionary", 
                        "value": [
                            { 
                                "key": {
                                    "type": "String",
                                    "value": "name"
                                }, 
                                "value": {
                                    "type": "String",
                                    "value": "Listen Second"
                                }
                            },
                            {
                                "key": {
                                    "type": "String",
                                    "value": "description"
                                },
                                "value": {
                                    "type": "String",
                                    "value": "The very second Listen NFT!"
                                }
                            },
                            {
                                "key": {
                                    "type": "String",
                                    "value": "mediaUrl"
                                },
                                "value" : {
                                    "type": "String",
                                    "value": "https://media.listencampaign.com/nfts/second-1.png"
                                }
                            },
                            {
                                "key": {
                                    "type": "String",
                                    "value": "media/type"
                                },
                                "value": {
                                    "type": "String",
                                    "value": "image/png"
                                }
                            },
                            {
                                "key": {
                                    "type": "String",
                                    "value": "externalLink"
                                },
                                "value": {
                                    "type": "String",
                                    "value": "https://listencampaign.com/nfts/second-2"
                                }
                            }
                        ]
                    },
                    {   "type": "String", 
                        "value": "QmWPie7Mxt6Xes2e9QsJqm77cVFArqmaLRS5Gogx6cyTpR"
                    }
                ]' \
    --signer="admin-account" 


# setup ListenUSD
flow transactions send ./transactions/ListenUSD/setup_account.cdc --signer="admin-account"
flow transactions send ./transactions/ListenUSD/setup_account.cdc --signer="user-account1"
flow transactions send ./transactions/ListenUSD/setup_account.cdc --signer="user-account2"

# Mint Listen Tokens

echo "Minting 1000 tokens to admin account"
flow transactions send ./transactions/ListenUSD/mint_tokens.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "Address",
            "value": "0x01cf0e2f2f715450"
        },
        {
            "type": "UFix64",
            "value": "1000.0"
        }
    ]'

echo "Transferring 111 tokens to user1"
flow transactions send ./transactions/ListenUSD/transfer_tokens.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UFix64",
            "value": "111.0"
        },
        {
            "type": "Address",
            "value": "0x179b6b1cb6755e31"
        }
    ]'

echo "Transferring 222 tokens to user2"
flow transactions send ./transactions/ListenUSD/transfer_tokens.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UFix64",
            "value": "222.0"
        },
        {
            "type": "Address",
            "value": "0xf3fcd2c1a78f5eee"
        }
    ]'




echo "Test P2P Marketplace"
read -p "Press any key to setup accounts ..."

echo "setup_account.cdc"
flow transactions send ./transactions/Listen/setup.cdc --signer="admin-account"
flow transactions send ./transactions/Listen/setup.cdc --signer="user-account1"
flow transactions send ./transactions/Listen/setup.cdc --signer="user-account2"
 

echo "About to run: create_listing.cdc"
# transaction(saleItemIDs: [UInt64], saleCollectionPrice: UFix64) {
flow transactions send ./transactions/ListenMarketplace/create_listing.cdc --signer="user-account1" \
    --args-json '[
        {
            "type": "Array",
            "value": [
                {
                    "type": "UInt64",
                    "value": "0"
                }
            ]
        },
        {
            "type": "UFix64",
            "value": "100.0"
        }
    ]'

flow transactions send ./transactions/ListenMarketplace/create_listing.cdc --signer="user-account2" \
    --args-json '[
        {
            "type": "Array",
            "value": [
                {
                    "type": "UInt64",
                    "value": "1"
                }
            ]
        },
        {
            "type": "UFix64",
            "value": "100.0"
        }
    ]'


echo "About to run: read_marketplace_ids.cdc"
read -p "Press any key to resume ..."

# pub fun main(account: Address): [UInt64] {
flow scripts execute ./scripts/ListenMarketplace/read_marketplace_ids.cdc \
    --args-json '[
        {
            "type": "Address",
            "value": "0x179b6b1cb6755e31"
        }
    ]'

flow scripts execute ./scripts/ListenMarketplace/read_marketplace_ids.cdc \
    --args-json '[
        {
            "type": "Address",
            "value": "0xf3fcd2c1a78f5eee"
        }
    ]'



echo "About to run: read_listing_details.cdc"
read -p "Press any key to resume ..."

# pub fun main(account: Address, listingResourceID: UInt64): ListenMarketplace.ListingDetails {
flow scripts execute ./scripts/ListenMarketplace/read_listing_details.cdc \
    --args-json '[
        {
            "type": "Address",
            "value": "0x179b6b1cb6755e31"
        },
        {
            "type": "UInt64",
            "value": "46"
        }
    ]'

flow scripts execute ./scripts/ListenMarketplace/read_listing_details.cdc \
    --args-json '[
        {
            "type": "Address",
            "value": "0xf3fcd2c1a78f5eee"
        },
        {
            "type": "UInt64",
            "value": "47"
        }
    ]'


echo "About to run purchase_listing.cdc"
echo "purchasing 46 from 0x179b6b1cb6755e31 with user-account2"
read -p "Press any key to resume ..."

# transaction(listingResourceID: UInt64, ListenStorefrontAddress: Address) {
flow transactions send ./transactions/ListenMarketplace/purchase_listing.cdc --signer="user-account2" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "46"
        },
        {
            "type": "Address",
            "value": "0x179b6b1cb6755e31"
        }
    ]'

echo "purchasing 47 from 0xf3fcd2c1a78f5eee with user-account1"
read -p "Press any key to resume ..."


flow transactions send ./transactions/ListenMarketplace/purchase_listing.cdc --signer="user-account1" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "47"
        },
        {
            "type": "Address",
            "value": "0xf3fcd2c1a78f5eee"
        }
    ]'



# cleanup_listing.cdc
# remove_item.cdc

