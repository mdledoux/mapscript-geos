#!/bin/bash
source .env

$CONTAINER build -t centos77 . -f centos77.Dockerfile
