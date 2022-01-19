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
read -p "(deployed) Press key to continue ..."


# Setup ListenNFT Receiver Capabilites for accounts
# setup account for admin-account
flow transactions send ./transactions/Listen/setup_account.cdc --signer="admin-account"

# setup account for user-account1
flow transactions send ./transactions/Listen/setup_account.cdc --signer="user-account1"

# setup account for user-account2
flow transactions send ./transactions/Listen/setup_account.cdc --signer="user-account2"

read -p "(setup-account) Press key to continue ..."
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
                        "value": ""
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
                        "value": ""
                    }
                ]' \
    --signer="admin-account" 

# Mint a 3nd NFT
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
                                    "value": "Listen #3"
                                }
                            },
                            {
                                "key": {
                                    "type": "String",
                                    "value": "description"
                                },
                                "value": {
                                    "type": "String",
                                    "value": "The very #3 Listen NFT!"
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
                                    "value": "https://listencampaign.com/nfts/second-3"
                                }
                            }
                        ]
                    },
                    {   "type": "String", 
                        "value": ""
                    }
                ]' \
    --signer="admin-account" 

read -p "(minted-nft) Press key to continue ..."
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

# Read exits nft for 0x179b6b1cb6755e31
echo "read token ids from collection @ 0x179b6b1cb6755e31"
flow scripts execute ./scripts/ListenNFT/get_collection_meta.cdc \
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
read -p "(got-metadata) Press key to continue ..."
echo "About to run ListenUSD tests  ------------------------------------------------------------------------------------"
#read -p "Press any key to resume ..."


# Listen Token Tests

# Setup ListenUSD Receiver Capabilites for accounts
# setup account for admin-account
# flow transactions send ./transactions/ListenUSD/setup_account.cdc --signer="admin-account"

#read -p "Press any key to resume ..."

# setup account for user-account1
# flow transactions send ./transactions/ListenUSD/setup_account.cdc --signer="user-account1"

#read -p "Press any key to resume ..."

# setup account for user-account2
# flow transactions send ./transactions/ListenUSD/setup_account.cdc --signer="user-account2"

#read -p "Press any key to resume ..."

# Mint Listen Tokens

echo "Minting 100 tokens to admin account"
flow transactions send ./transactions/ListenUSD/mint_tokens.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "Address",
            "value": "0x01cf0e2f2f715450"
        },
        {
            "type": "UFix64",
            "value": "100.0"
        }
    ]'

echo "Total Supply:"
flow scripts execute ./scripts/ListenUSD/get_supply.cdc

#read -p "Press any key to resume ..."

echo "Transferring 20 tokens to user1"
flow transactions send ./transactions/ListenUSD/transfer_tokens.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UFix64",
            "value": "20.0"
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
            "value": "50.0"
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

read -p "(minted-transferred) Press key to continue ..."
echo "Auction Tests-------------------------------------------------------------------------------------------------------------------------------------------"
read -p "Press any key to create an auction ...50seconds..... starting 10.0   bidStep: 5"
#transaction( startTime: UFix64, duration: UFix64, startingPrice: UFix64, bidStep: UFix64, tokenID: UInt64) { 
flow transactions send ./transactions/ListenAuction/create_auction.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UFix64",
            "value": "1.0"
        },
        {
            "type": "UFix64",
            "value": "50.0"
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
            "type": "UInt64",
            "value": "2"
        },
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'



flow transactions send ./transactions/ListenAuction/create_auction_from_ids.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UFix64",
            "value": "1.0"
        },
        {
            "type": "UFix64",
            "value": "5.0"
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
            "type": "UInt64",
            "value": "1"
        },
        {
            "type": "Array",
            "value": [
                {
                    "type": "UInt64",
                    "value": "2"
                }
            ]
        }
    ]'


    

read -p "Press any key to resume ..."
echo "Read metadata of auction #0 -> position = 2"

flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

read -p "Press any key to resume ..."
echo "Update position from 2 to 3"

flow transactions send ./transactions/ListenAuction/update_position.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UInt64",
            "value": "3"
        }
    ]'

read -p "Press any key to resume ..."
echo "Read metadata of auction #0 -> position = 3"

flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

echo "Place bid below starting bid (**should fail**)"
read -p "Press any key to resume ..."
flow transactions send ./transactions/ListenAuction/place_bid.cdc --signer="user-account1" \
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

flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

flow scripts execute ./scripts/ListenAuction/get_auctions_meta_by_status.cdc \
    --args-json '[
        {
            "type": "String",
            "value": "Complete"
        },
        {
            "type": "UInt64",
            "value": "2"
        }
    ]'

flow scripts execute ./scripts/ListenAuction/get_auctions_meta_by_status.cdc \
    --args-json '[
        {
            "type": "String",
            "value": "Open"
        },
        {
            "type": "UInt64",
            "value": "1"
        }
    ]'

read -p "(Get auction_metadata by status) Press any key to resume ..."

echo "place bid of 10.0 for user 1"
read -p "Press any key to resume ..."

flow transactions send ./transactions/ListenAuction/place_bid.cdc --signer="user-account1" \
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

flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

echo "place bid of 14.99 user 2 (**should fail**) -> bidStep"
read -p "Press any key to resume ..."

flow transactions send ./transactions/ListenAuction/place_bid.cdc --signer="user-account2" \
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

flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

echo "place bid of 15.0 user 2"
read -p "Press any key to resume ..."

flow transactions send ./transactions/ListenAuction/place_bid.cdc --signer="user-account2" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        },
        {
            "type": "UFix64",
            "value": "20.0"
        }
    ]'

flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'

read -p "(got-auction-metadata & bided) Press key to continue ..."

echo "settle auction"
read -p "Press any key to resume ..."

flow transactions send ./transactions/ListenAuction/settle_auction.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'


flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'


flow transactions send ./transactions/ListenAuction/settle_auction.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'


flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "0"
        }
    ]'
 
flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "1"
        }
    ]'
# Get Metadata for specific token
echo "getting meta data for token #2 of 0x01cf0e2f2f715450 - before remove auction"
flow scripts execute ./scripts/ListenNFT/get_metadata.cdc  \
    --args-json '[
                    {
                        "type": "Address",
                        "value": "0x01cf0e2f2f715450"
                    },
                    {
                        "type": "UInt64",
                        "value": "2"
                    }
                ]'

echo "remove auction #1"
read -p "Press any key to resume ..."
 flow transactions send ./transactions/ListenAuction/remove_auction.cdc --signer="admin-account" \
    --args-json '[
        {
            "type": "UInt64",
            "value": "1"
        }
    ]'

echo "check auction #1"
flow scripts execute ./scripts/ListenAuction/get_auction_meta.cdc \
    --args-json '[
        {
            "type": "UInt64",
            "value": "1"
        }
    ]'

# Get Metadata for specific token
echo "getting meta data for token #2 of 0x01cf0e2f2f715450"
flow scripts execute ./scripts/ListenNFT/get_metadata.cdc  \
    --args-json '[
                    {
                        "type": "Address",
                        "value": "0x01cf0e2f2f715450"
                    },
                    {
                        "type": "UInt64",
                        "value": "2"
                    }
                ]'
