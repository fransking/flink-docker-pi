#!/bin/bash

docker build -t fransking/flink:1.12.2-arm32v7 .
docker image inspect fransking/flink:1.12.2-arm32v7 --format='{{.Size}}'
