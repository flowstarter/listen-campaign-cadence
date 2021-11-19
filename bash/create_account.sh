#!/bin/sh

service=service-account
admin=testnet-admin
user1=testnet-user01
user2=testnet-user02
network=mainet

for i in {1..10}
do
    # echo "\n-------------------------------------"
    # current_date_time1=`date +%Y%m%d%H%M%S`
    # echo "start time: $current_date_time1"

    # flow accounts create \
    # --key 19799e3572e1e55bb44863c8120edf8ad15fc838dd0c90dd5abd3eb07cec34b8a5e4f17348871fdce6861dd2014db8daf386417ca3e0f3532b40afe06465abaa \
    # --signer mainnet-account \
    # --sig-algo=ECDSA_secp256k1 \
    # --network=mainnet

    # echo "\n"
    # current_date_time2=`date +%Y%m%d%H%M%S`
    # time_block = $(expr $current_date_time2 - $current_date_time1)
    # echo "end time: $current_date_time2"
    # echo "\n"
    # echo "Total time: $time_block"
    # echo "\n-------------------------------------"

    flow accounts create --key='c3f6c1f0b092aacc9a952a0d986244e78ffd394c5880f9ac2c604c2ef5cd1e0c2038a754d3ce97b915ae53522c6e759a1907ca6b821cad476e4abd51370d9a05' \
        --signer=$admin --network=$mainet >> output.txt
    # output1="$(grep Address output.txt)"
    # admin_address="${output1:9}"
    # echo "Admin: $admin_address"
    # flow transactions send ./transactions/demo/sendFlowToken.cdc --signer="testnet-admin" --network=testnet \
    # --args-json '[
    #                 {
    #                     "type": "UFix64",
    #                     "value": "1.0"
    #                 },
    #                 {   
    #                     "type": "Address",
    #                     "value": "0x300d5599b7b2cbfd"
    #                 }
    #             ]'
done

# create accounts
echo "Creating Admin account: "
flow accounts create --key='c3f6c1f0b092aacc9a952a0d986244e78ffd394c5880f9ac2c604c2ef5cd1e0c2038a754d3ce97b915ae53522c6e759a1907ca6b821cad476e4abd51370d9a05' \
    --signer=$service --network=$network > output.txt
output1="$(grep Address output.txt)"
admin="${output1:9}"
echo "Admin: $admin"

echo "Creating User1 account: "
flow accounts create --key="c3f6c1f0b092aacc9a952a0d986244e78ffd394c5880f9ac2c604c2ef5cd1e0c2038a754d3ce97b915ae53522c6e759a1907ca6b821cad476e4abd51370d9a05" \
    --signer=$service --network=$network > output.txt
output1="$(grep Address output.txt)"
user1="${output1:9}"
echo "User1: $user1"

echo "Creating User2 account: "
flow accounts create --key="c3f6c1f0b092aacc9a952a0d986244e78ffd394c5880f9ac2c604c2ef5cd1e0c2038a754d3ce97b915ae53522c6e759a1907ca6b821cad476e4abd51370d9a05" \
    --signer=$service --network=$network > output.txt
output1="$(grep Address output.txt)"
user2="${output1:9}"
echo "User2: $user2"

read -p "(Created Accounts) Press key to continue ..."

# flow accounts create \
#     --key 19799e3572e1e55bb44863c8120edf8ad15fc838dd0c90dd5abd3eb07cec34b8a5e4f17348871fdce6861dd2014db8daf386417ca3e0f3532b40afe06465abaa \
#     --signer mainnet-account \
#     --sig-algo=ECDSA_secp256k1 \
#     --network=mainnet

flow transactions send ./transactions/demo/sendFlowToken.cdc --signer="testnet-admin" --network=testnet \
    --args-json '[
                    {
                        "type": "UFix64",
                        "value": "100.0"
                    },
                    {   
                        "type": "Address",
                        "value": "0x300d5599b7b2cbfd"
                    }
                ]'