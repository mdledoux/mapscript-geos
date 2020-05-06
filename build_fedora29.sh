#!/bin/bash
source .env

docker build -t fedora29 . -f fedora29.Dockerfile
