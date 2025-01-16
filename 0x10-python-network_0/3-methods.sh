#!/bin/bash
# This script sends a request and displays the accepted HTTP methods.
curl -s -I "$1" | grep Allow | cut -d ' ' -f2-
