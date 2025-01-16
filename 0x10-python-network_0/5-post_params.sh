#!/bin/bash
# This script sends a POST request with specified parameters and displays the body.
curl -X POST -d "email=test@gmail.com&subject=I will always be here for PLD" -s "$1"
