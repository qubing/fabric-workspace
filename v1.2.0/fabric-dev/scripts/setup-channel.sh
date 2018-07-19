CHANNEL_NAME=channel01

peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ../channel-artifacts/$CHANNEL_NAME.tx
echo "===================== Channel \"$CHANNEL_NAME\" is created successfully ===================== "
echo

peer channel join -b $CHANNEL_NAME.block
echo "===================== Channel \"$CHANNEL_NAME\" joined successfully ===================== "
echo

peer chaincode install -n mycc -v 1.0 -p chaincodes/chaincode_example02

echo "===================== Channel \"$CHANNEL_NAME\" chaincode installed successfully ===================== "
echo

peer chaincode instantiate -o orderer.example.com:7050 -C $CHANNEL_NAME -n mycc -v 1.0 -c '{"Args":["init","a","100","b","100"]}'
echo "===================== Channel \"$CHANNEL_NAME\" chaincode instantiated successfully ===================== "
echo

sleep 10

peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'