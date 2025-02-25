#!/usr/bin/python3
"""Query Reddit API for top 10 hot posts"""
import requests


def top_ten(subreddit):
    """Print titles of top 10 hot posts"""
    url = f"https://www.reddit.com/r/{subreddit}/hot.json?limit=10"
    headers = {"User-Agent": "ALX-API-Advanced"}

    response = requests.get(url, headers=headers, allow_redirects=False)
    if response.status_code != 200:
        print(None)
        return

    posts = response.json().get("data", {}).get("children", [])
    [print(post.get("data", {}).get("title")) for post in posts]
