# Reddit API Project

This project contains Python scripts that interact with the Reddit API to fetch and analyze data from subreddits.

## Files

- **0-subs.py**: Returns the number of subscribers for a given subreddit.
- **1-top_ten.py**: Prints the titles of the top 10 hot posts for a given subreddit.
- **2-recurse.py**: Recursively retrieves all hot post titles for a given subreddit.
- **100-count.py**: Recursively counts the occurrences of given keywords in hot post titles.

## Overview
This project consists of several Python scripts that interact with the Reddit API.
Each script performs a specific task such as:
- Retrieving the number of subscribers for a subreddit.
- Printing the titles of the top 10 hot posts in a subreddit.
- Recursively fetching all hot post titles.
- Recursively counting keyword occurrences in hot post titles.

All scripts adhere to best practices including:
- A proper shebang (`#!/usr/bin/python3`).
- PEP 8 compliant code.
- Usage of the `requests` library for HTTP requests.
- Recursive implementations for handling paginated data from the Reddit API.

## Requirements
- **Python 3**
- **requests** module

To install the `requests` module, run:
```bash
pip install requests
