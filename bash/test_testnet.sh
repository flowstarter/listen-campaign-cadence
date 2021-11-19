#!/bin/sh
service=service-account
admin=testnet-admin
user1=testnet-user01
user2=testnet-user02
user3=testnet-user03
user4=testnet-user04
network=testnet

# # Flow tokens required for admin-account to be able to deploy contracts
# flow transactions send ./transactions/demo/mintFlowTokens.cdc

# Deploy Project
echo "Deploy project to testnet (as per flow.json config)"
flow project deploy --update --network=$network
read -p "(Deployed) Press key to continue ..."

# # Setup ListenNFT Receiver Capabilites for accounts
# # setup account for admin-account
flow transactions send ./transactions/Listen/setup_account.cdc --signer=$admin --network=$network

# # setup account for user-account1
# flow transactions send ./transactions/ListenNFT/setup_account.cdc --signer=$user1 --network=$network

# # setup account for user-account2
# flow transactions send ./transactions/ListenNFT/setup_account.cdc --signer=$user2 --network=$network

# # setup account for user-account3
# flow transactions send ./transactions/ListenNFT/setup_account.cdc --signer=$user4 --network=$network
read -p "(Deployed) Press key to continue ..."

# read -p "(Setup all account) Press key to continue ..."
# Mint an NFT to admin account
flow transactions send ./transactions/ListenNFT/mint_nft.cdc --network=$network --signer=$admin \
    --args-json '[
                    {   "type": "Address", 
                        "value": "0x7ee4f37a50357b84"
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
                ]'

# # Mint a 2nd NFT
# flow transactions send ./transactions/ListenNFT/mint_nft.cdc  --network=$network --signer=$admin \
#     --args-json '[
#                     {   "type": "Address", 
#                         "value": "0x7ee4f37a50357b84"
#                     }, 
#                     {
#                         "type": "Dictionary", 
#                         "value": [
#                             { 
#                                 "key": {
#                                     "type": "String",
#                                     "value": "name"
#                                 }, 
#                                 "value": {
#                                     "type": "String",
#                                     "value": "Listen Second"
#                                 }
#                             },
#                             {
#                                 "key": {
#                                     "type": "String",
#                                     "value": "description"
#                                 },
#                                 "value": {
#                                     "type": "String",
#                                     "value": "The very second Listen NFT!"
#                                 }
#                             },
#                             {
#                                 "key": {
#                                     "type": "String",
#                                     "value": "mediaUrl"
#                                 },
#                                 "value" : {
#                                     "type": "String",
#                                     "value": "https://media.listencampaign.com/nfts/second-1.png"
#                                 }
#                             },
#                             {
#                                 "key": {
#                                     "type": "String",
#                                     "value": "media/type"
#                                 },
#                                 "value": {
#                                     "type": "String",
#                                     "value": "image/png"
#                                 }
#                             },
#                             {
#                                 "key": {
#                                     "type": "String",
#                                     "value": "externalLink"
#                                 },
#                                 "value": {
#                                     "type": "String",
#                                     "value": "https://listencampaign.com/nfts/second-2"
#                                 }
#                             }
#                         ]
#                     },
#                     {   "type": "String", 
#                         "value": "QmWPie7Mxt6Xes2e9QsJqm77cVFArqmaLRS5Gogx6cyTpR"
#                     }
#                 ]'

# read -p "(Minted NFTs) Press key to continue ..."
# get total supply 
echo "total supply of Listen NFTs:"
flow scripts execute ./scripts/ListenNFT/get_supply.cdc --network=$network

read -p "(Get Nft info) Press key to continue ..."
# Get Metadata for specific token
echo "getting meta data for token 0 @ 0x7ee4f37a50357b84"
flow scripts execute ./scripts/ListenNFT/get_metadata.cdc --network=network  \
    --args-json '[
                    {
                        "type": "Address",
                        "value": "0xab502047621a8b08"
                    },
                    {
                        "type": "UInt64",
                        "value": "0"
                    }
                ]'
                
flow scripts execute ./scripts/ListenNFT/get_metadata.cdc --network=$network  \
    --args-json '[
                    {
                        "type": "Address",
                        "value": "0x7ee4f37a50357b84"
                    },
                    {
                        "type": "UInt64",
                        "value": "2"
                    }
                ]'

read -p "(Tranfer NFTs) Press key to continue ..."
# test transfer NFT transaction to: user01 0x4fc59aea0d91d6ed 
# transfers second nft ID #1 
# flow transactions send ./transactions/ListenNFT/transfer_nft.cdc --signer=$admin --network=$network \
#     --args-json '[
#                     {   
#                         "type": "Address",
#                         "value": "0x4fc59aea0d91d6ed"
#                     },
#                     {
#                         "type": "UInt64",
#                         "value": "1"
#                     }
#                 ]'

read -p "(Get Collection length) Press key to continue ..."
# Admin: Check collection length 0x7ee4f37a50357b84 
echo "Admin: Total NFTs in collection 0x7ee4f37a50357b84"
flow scripts execute ./scripts/ListenNFT/get_collection_length.cdc --network=testnet \
    --args-json '[
                    {
                        "type": "Address",
                        "value": "0xab502047621a8b08"
                    }
                ]'

# User1: Check collection length 0x4fc59aea0d91d6ed
echo "User1: total NFTs in collection @ 0x4fc59aea0d91d6ed"
flow scripts execute ./scripts/ListenNFT/get_collection_length.cdc --network=$network \
    --args-json '[
                    {
                        "type": "Address",
                        "value": "0x4fc59aea0d91d6ed"
                    }
                ]'


# Admin: Read collection ids for 0x7ee4f37a50357b84
echo "User2: read token ids from collection @ 0x7ee4f37a50357b84"
flow scripts execute ./scripts/ListenNFT/read_collection_ids.cdc  --network=$network \
     --args-json '[
                    {
                        "type": "Address",
                        "value": "0x7ee4f37a50357b84"
                    }
                ]'


# User1: Read collection ids for 0x4fc59aea0d91d6ed
echo "User1: read token ids from collection @ 0x4fc59aea0d91d6ed"
flow scripts execute ./scripts/ListenNFT/read_collection_ids.cdc --network=$network \
     --args-json '[
                    {
                        "type": "Address",
                        "value": "0x4fc59aea0d91d6ed"
                    }
                ]'


read -p "(Get Nfts info) Press key to continue ..."
# # Get Metadata for specific token
# echo "getting meta data for token 0 @ 0x7ee4f37a50357b84"
# flow scripts execute ./scripts/ListenNFT/get_metadata.cdc --network=$network \
#     --args-json '[
#                     {
#                         "type": "Address",
#                         "value": "0x7ee4f37a50357b84"
#                     },
#                     {
#                         "type": "UInt64",
#                         "value": "0"
#                     }
#                 ]'

# echo "getting meta data for token 1 @ 0x4fc59aea0d91d6ed"
# flow scripts execute ./scripts/ListenNFT/get_metadata.cdc --network=$network \
#     --args-json '[
#                     {
#                         "type": "Address",
#                         "value": "0x4fc59aea0d91d6ed"
#                     },
#                     {
#                         "type": "UInt64",
#                         "value": "1"
#                     }
#                 ]'

echo "About to run ListenUSD tests  ------------------------------------------------------------------------------------"
#read -p "Press any key to resume ..."


read -p "(Setup ListenUSD) Press any key to continue ..."
# # Listen Token Tests

# # Setup ListenUSD Receiver Capabilites for accounts
# # setup account for admin-account
# flow transactions send ./transactions/ListenUSD/setup_account.cdc --signer=$admin --network=$network

# #read -p "Press any key to resume ..."

# # setup account for user-account1
# flow transactions send ./transactions/ListenUSD/setup_account.cdc --signer=$user1 --network=$network

# #read -p "Press any key to resume ..."

# # setup account for user-account2
# flow transactions send ./transactions/ListenUSD/setup_account.cdc --signer=$user2 --network=$network

#read -p "Press any key to resume ..."

read -p "(Mint ListenUSD) Press any key to continue ..."
# Mint Listen Tokens

echo "Minting 100 tokens to admin account"
flow transactions send ./transactions/ListenUSD/mint_tokens.cdc --signer=testnet-admin --network=testnet \
    --args-json '[
        {
            "type": "Address",
            "value": "0xab502047621a8b08"
        },
        {
            "type": "UFix64",
            "value": "100000.0"
        }
    ]'

echo "Total Supply:"
flow scripts execute ./scripts/ListenUSD/get_supply.cdc --network=$network

#read -p "Press any key to resume ..."

read -p "(Transfer ListenUSD) Press any key to continue ..."
echo "Transferring 20 tokens to user1"
# flow transactions send ./transactions/ListenUSD/transfer_tokens.cdc --signer=$admin --network=$network \
#     --args-json '[
#         {
#             "type": "UFix64",
#             "value": "20.0"
#         },
#         {
#             "type": "Address",
#             "value": "0x4fc59aea0d91d6ed"
#         }
#     ]'

echo "Transferring 50 tokens to user2"
flow transactions send ./transactions/ListenUSD/transfer_tokens.cdc --signer=testnet-admin --network=testnet \
    --args-json '[
        {
            "type": "UFix64",
            "value": "500.0"
        },
        {
            "type": "Address",
            "value": "0x5083429655453b33"
        }
    ]'


read -p "(Burn ListenUSD) Press any key to continue ..."
echo "Burning 20 of admins tokens"
# flow transactions send ./transactions/ListenUSD/burn_tokens.cdc --signer=$admin --network=$network \
#     --args-json '[
#         {
#             "type": "UFix64",
#             "value": "20.0"
#         }
#     ]'

echo "Total Supply:"
flow scripts execute ./scripts/ListenUSD/get_supply.cdc --network=$network

#read -p "Press any key to resume ..."
echo "admin account balance:"
flow scripts execute ./scripts/ListenUSD/get_balance.cdc --network=testnet \
    --args-json '[
        {
            "type": "Address", 
            "value": "0x1f4eddad5e8b7329"
        }
    ]'

echo "user1 account balance:"
flow scripts execute ./scripts/ListenUSD/get_balance.cdc --network=$network \
    --args-json '[
        {
            "type": "Address", 
            "value": "0x4fc59aea0d91d6ed"
        }
    ]'

echo "user2 account balance:"
flow scripts execute ./scripts/ListenUSD/get_balance.cdc --network=$network \
    --args-json '[
        {
            "type": "Address", 
            "value": "0x4a5083a6ebd08477"
        }
    ]'


echo "Auction Tests-------------------------------------------------------------------------------------------------------------------------------------------"
read -p "Press any key to create an auction ...20seconds..... starting 10.0   bidStep: 5"
#transaction( startTime: UFix64, duration: UFix64, startingPrice: UFix64, bidStep: UFix64, tokenID: UInt64) { 
flow transactions send ./transactions/ListenAuction/create_auction.cdc --signer=$admin --network=$network \
    --args-json '[
        {
            "type": "UFix64",
            "value": "1.0"
        },
        {
            "type": "UFix64",
            "value": "20.0"
        },
        {
            "type": "UFix64",
            "value": "3600.0"
        },
        {
            "type": "UFix64",
            "value": "5.0"
        },
        {
            "type": "UInt64",
            "value": "2"
        }
    ]'

flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc --network=$network \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

echo "Place bid below starting bid (**should fail**)"
read -p "Press any key to resume ..."
flow transactions send ./transactions/ListenAuction/place_bid.cdc --signer=$user1 --network=$network \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "9.99"
        }
    ]'

flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc --network=testnet \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

echo "place bid of 10.0 for user 1"
read -p "Press any key to resume ..."

flow transactions send ./transactions/ListenAuction/place_bid.cdc --signer=$user1 --network=$network \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "10.0"
        }
    ]'

flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc --network=$network \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

cho "read token ids from collection @ 0x179b6b1cb6755e31"
flow scripts execute ./scripts/ListenNFT/get_collection_meta.cdc --network=testnet \
     --args-json '[
                    {
                        "type": "Address",
                        "value": "0xab502047621a8b08"
                    }
                ]'

echo "place bid of 14.99 user 2 (**should fail**) -> bidStep"
read -p "Press any key to resume ..."

flow transactions send ./transactions/ListenAuction/place_bid.cdc --signer=$user2 --network=$network \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "14.99"
        }
    ]'

flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc --network=$network \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

# Get all auction haven't finished yet
flow scripts execute ./scripts/ListenAuction/get_auctions_meta.cdc --network=testnet

echo "place bid of 15.0 user 2"
read -p "Press any key to resume ..."

flow transactions send ./transactions/ListenAuction/place_bid.cdc --signer=$user2 --network=$network \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "15.0"
        }
    ]'

flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc --network=$network \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

echo "settle auction"
read -p "Press any key to resume ..."

flow transactions send ./transactions/ListenAuction/settle_auction.cdc --signer=$admin --network=$network \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

flow transactions send ./transactions/ListenAuction/remove_auction.cdc --signer=$admin --network=$network \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'


flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc --network=$network \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'


flow transactions send ./transactions/ListenAuction/settle_auction.cdc --signer=$admin --network=$network \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'


flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc --network=$network \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'
 