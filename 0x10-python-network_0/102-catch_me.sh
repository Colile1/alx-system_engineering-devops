#!/bin/bash
# This script sends a request to catch_me and displays the response body.
curl -H "User-Agent: YouGotMe" -s "0.0.0.0:5000/catch_me"
