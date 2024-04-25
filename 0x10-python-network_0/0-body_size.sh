#!/bin/bash

url=$1

size=$(curl -s $url | wc -c)

echo $size
