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
flow project deploy --update --network=emulator
read -p "(Deployed) Press key to continue ..."


# Setup ListenNFT Receiver Capabilites for accounts
# setup account for admin-account
flow transactions send ./transactions/ListenNFT/setup_account.cdc --signer="admin-account"

# setup account for user-account1
flow transactions send ./transactions/ListenNFT/setup_account.cdc --signer="user-account1"

# setup account for user-account2
flow transactions send ./transactions/ListenNFT/setup_account.cdc --signer="user-account2"


read -p "(Setup) Press key to continue ..."
# Mint an NFT to admin account
flow transactions send ./transactions/ListenNFT/mint_nft.cdc --signer="admin-account" \
    --args-json '[
                    {   "type": "Address", 
                        "value": "0x01cf0e2f2f715450"
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

# Mint a 2nd NFT
flow transactions send ./transactions/ListenNFT/mint_nft.cdc \
    --args-json '[
                    {   "type": "Address", 
                        "value": "0x01cf0e2f2f715450"
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

# Mint a 3rd NFT with id 2
flow transactions send ./transactions/ListenNFT/mint_nft.cdc \
    --args-json '[
                    {   "type": "Address", 
                        "value": "0x01cf0e2f2f715450"
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

    # Mint a 4rd NFT with id 3
flow transactions send ./transactions/ListenNFT/mint_nft.cdc \
    --args-json '[
                    {   "type": "Address", 
                        "value": "0x01cf0e2f2f715450"
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


# Mint a 5th NFT with id 4
flow transactions send ./transactions/ListenNFT/mint_nft.cdc \
    --args-json '[
                    {   "type": "Address", 
                        "value": "0x01cf0e2f2f715450"
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

# get total supply 
echo "total supply of Listen NFTs:"
flow scripts execute ./scripts/ListenNFT/get_supply.cdc

# test transfer NFT transaction to: 0x179b6b1cb6755e31 
# transfers second nft ID #1 
flow transactions send ./transactions/ListenNFT/transfer_nft.cdc \
    --args-json '[
                    {   
                        "type": "Address",
                        "value": "0x179b6b1cb6755e31"
                    },
                    {
                        "type": "UInt64",
                        "value": "1"
                    }
                ]' \
    --signer="admin-account"


# Check collection length 0x01cf0e2f2f715450 
echo "total NFTs in collection @ 0x01cf0e2f2f715450"
flow scripts execute ./scripts/ListenNFT/get_collection_length.cdc \
    --args-json '[
                    {
                        "type": "Address",
                        "value": "0x01cf0e2f2f715450"
                    }
                ]'

# Check collection length 0x179b6b1cb6755e31
echo "total NFTs in collection @ 0x179b6b1cb6755e31"
flow scripts execute ./scripts/ListenNFT/get_collection_length.cdc \
    --args-json '[
                    {
                        "type": "Address",
                        "value": "0x179b6b1cb6755e31"
                    }
                ]'


# Read collection ids for 0x01cf0e2f2f715450
echo "read token ids from collection @ 0x01cf0e2f2f715450"
flow scripts execute ./scripts/ListenNFT/read_collection_ids.cdc \
     --args-json '[
                    {
                        "type": "Address",
                        "value": "0x01cf0e2f2f715450"
                    }
                ]'


# Read collection ids for 0x179b6b1cb6755e31
echo "read token ids from collection @ 0x179b6b1cb6755e31"
flow scripts execute ./scripts/ListenNFT/read_collection_ids.cdc \
     --args-json '[
                    {
                        "type": "Address",
                        "value": "0x179b6b1cb6755e31"
                    }
                ]'


# Get Metadata for specific token
echo "getting meta data for token 0 @ 0x01cf0e2f2f715450"
flow scripts execute ./scripts/ListenNFT/get_metadata.cdc  \
    --args-json '[
                    {
                        "type": "Address",
                        "value": "0x01cf0e2f2f715450"
                    },
                    {
                        "type": "UInt64",
                        "value": "0"
                    }
                ]'

echo "getting meta data for token 1 @ 0x179b6b1cb6755e31"
flow scripts execute ./scripts/ListenNFT/get_metadata.cdc  \
    --args-json '[
                    {
                        "type": "Address",
                        "value": "0x179b6b1cb6755e31"
                    },
                    {
                        "type": "UInt64",
                        "value": "1"
                    }
                ]'




echo "About to run ListenUSD tests  ------------------------------------------------------------------------------------"
#read -p "Press any key to resume ..."


# Listen Token Tests

# Setup ListenUSD Receiver Capabilites for accounts
# setup account for admin-account
flow transactions send ./transactions/ListenUSD/setup_account.cdc --signer="admin-account"

#read -p "Press any key to resume ..."

# setup account for user-account1
flow transactions send ./transactions/ListenUSD/setup_account.cdc --signer="user-account1"

#read -p "Press any key to resume ..."

# setup account for user-account2
flow transactions send ./transactions/ListenUSD/setup_account.cdc --signer="user-account2"

#read -p "Press any key to resume ..."

# Mint Listen Tokens

echo "Minting 100000 tokens to admin account"
flow transactions send ./transactions/ListenUSD/mint_tokens.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "Address",
            "value": "0x01cf0e2f2f715450"
        },
        {
            "type": "UFix64",
            "value": "100000.0"
        }
    ]'

echo "Total Supply:"
flow scripts execute ./scripts/ListenUSD/get_supply.cdc

#read -p "Press any key to resume ..."

echo "Transferring 50000 tokens to user1"
flow transactions send ./transactions/ListenUSD/transfer_tokens.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UFix64",
            "value": "50000.0"
        },
        {
            "type": "Address",
            "value": "0x179b6b1cb6755e31"
        }
    ]'

echo "Transferring 50 tokens to user2"
flow transactions send ./transactions/ListenUSD/transfer_tokens.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UFix64",
            "value": "5000.0"
        },
        {
            "type": "Address",
            "value": "0xf3fcd2c1a78f5eee"
        }
    ]'


echo "Burning 20 of admins tokens"
flow transactions send ./transactions/ListenUSD/burn_tokens.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UFix64",
            "value": "20.0"
        }
    ]'

echo "Total Supply:"
flow scripts execute ./scripts/ListenUSD/get_supply.cdc


#read -p "Press any key to resume ..."
echo "admin account balance:"
flow scripts execute ./scripts/ListenUSD/get_balance.cdc \
    --args-json '[
        {
            "type": "Address", 
            "value": "0x01cf0e2f2f715450"
        }
    ]'



echo "user1 account balance:"
flow scripts execute ./scripts/ListenUSD/get_balance.cdc \
    --args-json '[
        {
            "type": "Address", 
            "value": "0x179b6b1cb6755e31"
        }
    ]'




echo "Auction Tests-------------------------------------------------------------------------------------------------------------------------------------------"
read -p "Press any key to create an auction ...20seconds..... starting 10.0   bidStep: 5"
#transaction( startTime: UFix64, duration: UFix64, startingPrice: UFix64, bidStep: UFix64, tokenID: UInt64) { 
flow transactions send ./transactions/ListenBatchAuction/create_auction.cdc --signer="admin-account" \
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
            "value": "10.0"
        },
        {
            "type": "UFix64",
            "value": "5.0"
        },
        {
            "type": "Array",
            "value": [
                {
                    "type": "UInt64",
                    "value": "0"
                },                {
                    "type": "UInt64",
                    "value": "3"
                },                {
                    "type": "UInt64",
                    "value": "4"
                },
                {
                    "type": "UInt64",
                    "value": "2"
                }
            ]
        }
    ]'

echo "Updating extension time to zero for testing" 
flow transactions send ./transactions/ListenBatchAuction/update_extension_time.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UFix64",
            "value": "0.0"
        }
    ]'

flow scripts execute ./scripts/ListenBatchAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

echo "Place bid below starting bid (**should fail**)"
read -p "Press any key to resume ..."
flow transactions send ./transactions/ListenBatchAuction/place_bid.cdc --signer="user-account1" \
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

flow scripts execute ./scripts/ListenBatchAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

echo "place bid of 10.0 for user 1"
read -p "Press any key to resume ..."

flow transactions send ./transactions/ListenBatchAuction/place_bid.cdc --signer="user-account1" \
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

flow scripts execute ./scripts/ListenBatchAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

echo "place bid of 14.99 user 2 (**should fail**) -> bidStep"
read -p "Press any key to resume ..."

flow transactions send ./transactions/ListenBatchAuction/place_bid.cdc --signer="user-account2" \
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

flow scripts execute ./scripts/ListenBatchAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

echo "place bid of 25.1 user 2"
read -p "Press any key to resume ..."

flow transactions send ./transactions/ListenBatchAuction/place_bid.cdc --signer="user-account2" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "25.1"
        }
    ]'

flow transactions send ./transactions/ListenBatchAuction/place_bid.cdc --signer="user-account1" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "380.0"
        }
    ]'
    
    flow transactions send ./transactions/ListenBatchAuction/place_bid.cdc --signer="user-account2" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "170.0"
        }
    ]'
    
    flow transactions send ./transactions/ListenBatchAuction/place_bid.cdc --signer="user-account1" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "39.0"
        }
    ]'
    
    flow transactions send ./transactions/ListenBatchAuction/place_bid.cdc --signer="user-account2" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "85.0"
        }
    ]'
    
    flow transactions send ./transactions/ListenBatchAuction/place_bid.cdc --signer="user-account1" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "55.0"
        }
    ]'

    flow transactions send ./transactions/ListenBatchAuction/place_bid.cdc --signer="user-account1" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "105.0"
        }
    ]'

    flow transactions send ./transactions/ListenBatchAuction/place_bid.cdc --signer="user-account1" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "205.0"
        }
    ]'

echo "SHOULD FAIL!!!!!"
    flow transactions send ./transactions/ListenBatchAuction/place_bid.cdc --signer="user-account1" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "59.9"
        }
    ]'

        flow transactions send ./transactions/ListenBatchAuction/place_bid.cdc --signer="user-account1" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "60.0
        }
    ]'


flow scripts execute ./scripts/ListenBatchAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

echo "settle auction"
read -p "Press any key to resume ..."

flow transactions send ./transactions/ListenBatchAuction/settle_auction.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'


flow scripts execute ./scripts/ListenBatchAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'


flow transactions send ./transactions/ListenBatchAuction/settle_auction.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'
