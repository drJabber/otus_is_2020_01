#!/bin/sh

docker build -t webapp-simple-image .
docker save -o webapp-simple.zip webapp-simple-image

