#!/usr/bin/python3
""" Module for getting the top 10 hot posts of a subreddit """
import requests

def top_ten(subreddit):
    url = f"https://www.reddit.com/r/{subreddit}/hot.json?limit=10"
    headers = {'User-Agent': 'ALX-API-Advanced'}
    response = requests.get(url, headers=headers, allow_redirects=False)

    if response.status_code == 200:
        for post in response.json().get('data', {}).get('children', []):
            print(post.get('data', {}).get('title'))
    else:
        print(None)
