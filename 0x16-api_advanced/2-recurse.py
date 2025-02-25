#!/usr/bin/python3
"""Recursively query Reddit API for all hot posts"""
import requests


def recurse(subreddit, hot_list=[], after=None):
    """Return list containing all hot post titles"""
    url = f"https://www.reddit.com/r/{subreddit}/hot.json"
    headers = {"User-Agent": "ALX-API-Advanced"}
    params = {"after": after} if after else {}

    response = requests.get(
        url,
        headers=headers,
        params=params,
        allow_redirects=False
    )
    if response.status_code != 200:
        return None

    data = response.json().get("data", {})
    hot_list.extend(
        [post.get("data", {}).get("title")
         for post in data.get("children", [])]
    )
    after = data.get("after")
    return recurse(subreddit, hot_list, after) if after else hot_list
