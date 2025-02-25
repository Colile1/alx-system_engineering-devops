#!/usr/bin/python3
"""Test for count_words function from 100-count.py"""
import sys
import io
from contextlib import redirect_stdout

def test_valid_subreddit():
    count_words = __import__('100-count').count_words
    f = io.StringIO()
    with redirect_stdout(f):
        count_words("python", ["python", "java"])
    output = f.getvalue().strip()
    if output == "":
        print("FAIL: count_words printed no output for 'python' with keywords")
        sys.exit(1)

def test_invalid_subreddit():
    count_words = __import__('100-count').count_words
    f = io.StringIO()
    with redirect_stdout(f):
        count_words("this_subreddit_does_not_exist_12345", ["python", "java"])
    output = f.getvalue().strip()
    if output != "":
        print("FAIL: count_words printed output for an invalid subreddit")
        sys.exit(1)

if __name__ == '__main__':
    test_valid_subreddit()
    test_invalid_subreddit()
    print("PASS: 100-count.py tests passed")
