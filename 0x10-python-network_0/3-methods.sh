#!/bin/bash

url=$1

methods=$(curl -X OPTIONS $url -s -o /dev/null -w '%{http_code}' | tail -n 1)

echo $methods
