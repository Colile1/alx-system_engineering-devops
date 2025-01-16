#!/bin/bash
# This script takes a URL, sends a request, and displays the size of the body in bytes.
curl -s -w "%{size_download}" "$1" -o /dev/null
