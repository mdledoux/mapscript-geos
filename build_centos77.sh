#!/bin/bash
source .env

$CONTAINER build -t centos77_php_mapscript . -f centos77.Dockerfile  --target=php_mapscript
$CONTAINER build -t centos77_php_geos . -f centos77.Dockerfile  --target=php_geos
