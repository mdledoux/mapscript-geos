#!/bin/bash
source .env

$CONTAINER_ENGINE build -t fedora29 . -f fedora29.Dockerfile
ECHO "THIS Dockerfile DOES NOT YET EXIST!!!  Migrate it from ./fedpra29.setup.sh"