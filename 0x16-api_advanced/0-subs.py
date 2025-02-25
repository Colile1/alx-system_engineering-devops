#!/usr/bin/python3
"""Query Reddit API for subreddit subscriber count"""
import requests


def number_of_subscribers(subreddit):
    """Return number of subscribers for given subreddit"""
    url = f"https://www.reddit.com/r/{subreddit}/about.json"
    headers = {"User-Agent": "ALX-API-Advanced"}

    response = requests.get(url, headers=headers, allow_redirects=False)
    if response.status_code != 200:
        return 0
    return response.json().get("data", {}).get("subscribers", 0)
