#!/bin/sh

docker stop flink-jobmanager
docker rm flink-jobmanager

docker run -d \
    -p 6123:6123 \
    -p 8081:8081 \
    --name flink-jobmanager fransking/flink:1.11.1-arm32v7 jobmanager
