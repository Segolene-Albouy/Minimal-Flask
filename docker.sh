#!/bin/bash

# MODIFY THOSE VARIABLES TO MATCH YOUR SYSTEM
DEMO_UID=1019


docker kill minimalflask || true;
docker build --rm -t minimalflask . -f Dockerfile --build-arg USERID="$DEMO_UID";
cd ../;

docker rm minimalflask

docker run -d --name minimalflask -p 127.0.0.1:8002:8002 \
   --restart unless-stopped --ipc=host minimalflask
