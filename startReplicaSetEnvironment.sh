#!/bin/bash

DELAY=20

docker-compose down
docker rm -f $(docker ps -a -q)
docker volume rm $(docker volume ls -q)

docker-compose up -d

echo "****** Waiting for ${DELAY} seconds for containers to go up ******"
sleep $DELAY

docker exec localmongo1 //scripts/rs-init.sh

sleep 120