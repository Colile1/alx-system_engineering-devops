#!/bin/bash

url=$1
filename=$2
curl -s -X POST -H "Content-Type: application/json" -d "@$filename" $url

