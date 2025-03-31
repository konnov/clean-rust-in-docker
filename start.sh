#!/usr/bin/env bash

set -e
docker build -t rusty .

docker run -d -p 2222:22 --name clean-rust rusty

# ssh into the container with port-forwarding enabled
ssh -A rustdev@localhost -p 2222

read -p "Stop the container and delete it now? (y/N): " ans
if [ "$ans" == "Y" -o "$ans" == "y" ]; then
    docker stop clean-rust && docker rm clean-rust
fi
