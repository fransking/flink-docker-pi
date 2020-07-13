#!/bin/bash

docker build -t fransking/flink:arm32v7 .
docker image inspect fransking/flink:arm32v7 --format='{{.Size}}'
