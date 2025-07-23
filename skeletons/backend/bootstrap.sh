#!/bin/bash

if [ ! -f "start.sh" ]; then
  echo "🌌 Welcome to the Bradyverse"
  cp -rT /template /server
  rm /server/bootstrap.sh
fi

./start.sh
