#!/bin/bash
source .env

$CONTAINER_ENGINE build -t centos78_php_mapscript . -f centos78.Dockerfile \
                  --target=php_mapscript \
                  --build-arg UID=1000
$CONTAINER_ENGINE build -t centos78_php_geos . -f centos78.Dockerfile \
                  --target=php_geos \
                  --build-arg UID=1000
