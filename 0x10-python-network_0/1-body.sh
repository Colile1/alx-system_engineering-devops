#!/bin/bash

url=$1

response=$(curl -s "$url")
status_code=$(echo "$response" | head -n 1 | cut -d' ' -f2)

if [ "$status_code" -eq 200 ]; then
  echo "${response##*$'\r'}"
fi
