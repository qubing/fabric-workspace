rm -rf crypto-config/*
rm -rf channel-artifacts/*

export PATH=${PWD}/../fabric-bin/bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}

cryptogen generate --config=crypto-config.yaml

configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel01.tx -channelID channel01

configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/channel01_Org1MSPanchors.tx -channelID channel01 -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/channel01_Org2MSPanchors.tx -channelID channel01 -asOrg Org2MSP

rm ./base/docker-compose-base.yaml
cp ./base/docker-compose-base-tmpl.yaml ./base/docker-compose-base.yaml

# The next steps will replace the template's contents with the
# actual values of the private key file names for the two CAs.
ARCH=$(uname -s | grep Darwin)
  if [ "$ARCH" == "Darwin" ]; then
    OPTS="-it"
  else
    OPTS="-i"
fi
CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/org1.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" ./base/docker-compose-base.yaml
cd crypto-config/peerOrganizations/org2.example.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA2_PRIVATE_KEY/${PRIV_KEY}/g" ./base/docker-compose-base.yaml
# If MacOSX, remove the temporary backup of the docker-compose file
if [ "$ARCH" == "Darwin" ]; then
    rm base/docker-compose-base.yamlt
fi
