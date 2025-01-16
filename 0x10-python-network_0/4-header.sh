#!/bin/bash
# This script sends a GET request with a custom header and displays the body.
curl -H "X-School-User-Id: 98" -s "$1"
