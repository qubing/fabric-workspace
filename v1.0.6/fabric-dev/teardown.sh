docker-compose down
docker rm -f `docker ps -qa`
docker rmi -f `docker images | grep dev-peer | awk '{print$3}'`

rm channel-artifacts/*.block
rm channel-artifacts/*.tx
rm -rf crypto-config/**/*
