#!/usr/bin/python3
""" Module for getting all hot articles of a subreddit recursively """
import requests

def recurse(subreddit, hot_list=[], after=None):
    url = f"https://www.reddit.com/r/{subreddit}/hot.json"
    headers = {'User-Agent': 'ALX-API-Advanced'}
    params = {'after': after}
    response = requests.get(url, headers=headers, params=params, allow_redirects=False)

    if response.status_code == 200:
        data = response.json().get('data', {})
        after = data.get('after')
        hot_list.extend([post.get('data', {}).get('title') for post in data.get('children', [])])

        if after:
            return recurse(subreddit, hot_list, after)
        return hot_list
    return None
