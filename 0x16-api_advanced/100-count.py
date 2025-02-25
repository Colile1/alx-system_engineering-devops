#!/usr/bin/python3
"""Count keywords in Reddit hot posts recursively"""
import re
import requests


def count_words(subreddit, word_list, counts=None, after=None):
    """Count and print sorted keyword occurrences"""
    if counts is None:
        counts = {word.lower(): 0 for word in word_list}
        word_list = [word.lower() for word in word_list]

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
        return

    data = response.json().get("data", {})
    for post in data.get("children", []):
        title = post.get("data", {}).get("title", "").lower()
        for word in re.findall(r"\b\w+\b", title):
            if word in counts:
                counts[word] += 1

    after = data.get("after")
    if after:
        return count_words(subreddit, word_list, counts, after)
    else:
        sorted_counts = sorted(
            counts.items(),
            key=lambda item: (-item[1], item[0])
        )
        for word, count in sorted_counts:
            if count > 0:
                print(f"{word}: {count}")
