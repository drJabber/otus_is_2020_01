#!/bin/sh

docker build --no-cache=true -t webapp-simple-image:0.1 .
docker save -o webapp-simple.zip "webapp-simple-image:0.1"

