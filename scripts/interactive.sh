#!/usr/bin/env bash

if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

docker pull ghcr.io/pgmffenthusiasts/bradyverse-backend:latest
docker run --rm -it --name "brady-$BRADY_SERVER" -p "127.0.0.1:$BRADY_PORT:25565" --network nats_default --network stats-db_default --env-file .env -e TERM="$TERM" -v ../merge:/merge -v ./logs:/server/logs ghcr.io/pgmffenthusiasts/bradyverse-backend:latest
