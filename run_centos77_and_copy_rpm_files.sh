#!/bin/bash
source .env

echo STARTING CONTAINERS
$CONTAINER_ENGINE run -t --rm --name php_mapscript -v $PWD/RPMs:/RPMs  centos77_php_mapscript
$CONTAINER_ENGINE run -t --rm --name php_geos -v $PWD/RPMs:/RPMs  centos77_php_geos
echo The RPM files should be found in ./RPMs