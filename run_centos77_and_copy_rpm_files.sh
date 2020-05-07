#!/bin/bash

docker run -it --rm --name php_mapscript -d centos77_php_mapscript
docker run -it --rm --name php_geos -d centos77_php_geos


docker cp php_geos:RPM .
docker cp php_mapscript:RPM .


docker stop php_geos
docker stop php_mapscript

