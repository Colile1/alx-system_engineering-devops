#!/usr/bin/python3
""" Module for counting keyword occurrences in hot articles of a subreddit """
import requests

def count_words(subreddit, word_list, hot_list=[], after=None):
    url = f"https://www.reddit.com/r/{subreddit}/hot.json"
    headers = {'User-Agent': 'ALX-API-Advanced'}
    params = {'after': after}
    response = requests.get(url, headers=headers, params=params, allow_redirects=False)

    if response.status_code == 200:
        data = response.json().get('data', {})
        after = data.get('after')
        hot_list.extend([post.get('data', {}).get('title').lower() for post in data.get('children', [])])

        if after:
            return count_words(subreddit, word_list, hot_list, after)

        word_count = {}
        for word in word_list:
            word_lower = word.lower()
            word_count[word_lower] = sum(title.split().count(word_lower) for title in hot_list)

        for word, count in sorted(word_count.items(), key=lambda item: (-item[1], item[0])):
            if count > 0:
                print(f"{word}: {count}")
