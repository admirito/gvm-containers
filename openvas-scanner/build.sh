#!/bin/bash

TAG=22.4.1-3
IMAGE=openvas-scanner
DOCKER_BUILDKIT=1 docker build -t konvergence/$IMAGE:$TAG .