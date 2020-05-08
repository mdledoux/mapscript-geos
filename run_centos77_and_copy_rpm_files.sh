#!/bin/bash
source .env

echo STARTING CONTAINERS
$CONTAINER_ENGINE run -it --rm --name php_mapscript -d centos77_php_mapscript
$CONTAINER_ENGINE run -it --rm --name php_geos -d centos77_php_geos


echo COPYING FILES
$CONTAINER_ENGINE cp php_geos:RPM .
$CONTAINER_ENGINE cp php_mapscript:RPM .

echo STOPPING CONTAINERS
$CONTAINER_ENGINE stop php_geos
$CONTAINER_ENGINE stop php_mapscript

