#!/bin/bash

docker build -t fransking/flink:1.11.1-arm32v7 .
docker image inspect fransking/flink:1.11.1-arm32v7 --format='{{.Size}}'
