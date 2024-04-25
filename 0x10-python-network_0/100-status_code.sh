#!/bin/bash

url=$1
status_code=$(curl -s -o /dev/null -w "%{http_code}" $url)
echo "$status_code"
