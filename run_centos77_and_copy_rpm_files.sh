#!/bin/bash
source .env

echo STARTING CONTAINERS
$CONTAINER run -it --rm --name php_mapscript -d centos77_php_mapscript
$CONTAINER run -it --rm --name php_geos -d centos77_php_geos


echo COPYING FILES
$CONTAINER cp php_geos:RPM .
$CONTAINER cp php_mapscript:RPM .

echo STOPPING CONTAINERS
$CONTAINER stop php_geos
$CONTAINER stop php_mapscript

