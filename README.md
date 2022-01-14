# Listen Collectibles Auction and Shop

Listen Collectibles Auction and Shop (LCAS) and p2p marketplace cadence contracts, transactions and scripts.

Each Listen NFT is minted and stored in a collection
NFTs can be minted single or in batches.

ListenUSD is utility token for bidding in auctions.

Auction and Storefront are hardcoded to use ListenNFT and ListenUSD for payments.

ListenStorefront is based on NFTStoreFront by Rhea Myers

# Listen Collectibles Auction and Shop (LCAS)

- The Listen Collectibles Auction and Shop is the official destination for social impact digital collectibles from the world’s top creative artists from music, film and the arts. It is the first digital collectibles platform with an integrated pipeline of NFTs (scarce digital collectibles on the blockchain) from Star Creative Artists and the best of Citizen Artists (non-professionals) from around the world. The platform benefits from being part of ‘The Listen Campaign’, a new global campaign to 100s of millions worldwide, creating a global community driving social impact through the production and consumption of digital art and collectibles on the blockchain.

- The Star Creative Artist’s NFTs (blockchain-based digital collectibles) will be auctioned in monthly auctions and the best of the citizen art will be sold in the Listen Collectibles Auction and Shop. Each of the Star Collectibles will be highly unique and of great quality (e.g. there might be a piece of art by Jeff Koons, footage of Rihanna and Eric Clapton arranging a classic song together, a manuscript with handwritten notes of Margaret Atwood, a special short performance by Samuel L Jackson). 15 percent of the income from the sales/auction will pay for the Listen Collectibles Auction and Shop platform with the other 85 percent of the sales/auction income to cover the costs of the campaign. All subsequent sales of the NFT will incur a 10 percent royalty, with 5 percent funding buybacks of $LSTN to replenish staking rewards for the token community and 5 percent raising funds for The Listen Campaign – the annual surplus of each annual campaign will be distributed to The Listen Charity to support over 75 children’s charity projects around the world.

# LCAS Contracts

## ListenNFT
- mint batch collection
- mint nft
- setup account
- transfer nft


## ListenUSD
- burn tokens
- mint tokens
- setup account
- transfer tokens


### ListenAuction
- create_auction from collection
- create_auction from ids
- create_auction
- place bid
- settle auction


### ListenStorefront
- buy item
- cleanup item
- remove item
- sell item
- setup account

### Testing

- To run the tests in the repo:

1. Run flow-cli `flow project start-emulator --config-path=flow.json --verbose`.
2. For testing auction contract: execute auction_test.sh `./auction_test.sh`. ( Should set execute right to this file: `chmod +x ./bash/auction_test.sh`)
3. For testing auction marketplace auction_test.sh `./marketplace_test.sh`. ( Should set execute right to this file: `chmod +x ./bash/marketplace_test.sh` )

# License 

This is free and unencumbered software released into the public domain.

For more information, please refer to <https://github.com/flowstarter/listen-campaign-cadence/blob/master/LICENSE>
