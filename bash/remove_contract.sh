#!/bin/sh

network=testnet
account=testnet-admin-1
# remove all accounts
echo "Remove all contract"
# echo "Remove ListenMarketplace"
# flow accounts remove-contract ListenMarketplace --signer=$account --network=$network

# echo "Remove ListenAution"
# flow accounts remove-contract ListenAuction --signer=$account --network=$network

# echo "Remove ListenUSD"
# flow accounts remove-contract ListenUSD --signer=$account --network=$network

# echo "Remove ListenNFT"
# flow accounts remove-contract ListenNFT --signer=$account --network=$network

echo "Removed"


flow project deploy --update --signer=$account --network=$network