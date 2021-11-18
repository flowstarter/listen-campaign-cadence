# listen-campaign-cadence

Listen Campaign NFT Auction House and p2p marketplace cadence contracts, transactions and scripts.

Each Listen NFT is minted and stored in a collection
NFTs can be minted single or in batches.

ListenUSD is utility token for bidding in auctions.

Auction and Storefront are hardcoded to use ListenNFT and ListenUSD for payments.

ListenStorefront is based on NFTStoreFront by Rhea Myers

## Contracts

### ListenNFT
- mint batch collection
- mint nft
- setup account
- transfer nft


### ListenUSD
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