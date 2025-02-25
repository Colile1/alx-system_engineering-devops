#!/usr/bin/python3
"""Test for recurse function from 2-recurse.py"""
import sys

def test_valid_subreddit():
    recurse = __import__('2-recurse').recurse
    result = recurse("python")
    if not isinstance(result, list) or len(result) == 0:
        print("FAIL: recurse did not return a non-empty list for 'python'")
        sys.exit(1)

def test_invalid_subreddit():
    recurse = __import__('2-recurse').recurse
    result = recurse("this_subreddit_does_not_exist_12345")
    if result is not None:
        print("FAIL: recurse did not return None for an invalid subreddit")
        sys.exit(1)

if __name__ == '__main__':
    test_valid_subreddit()
    test_invalid_subreddit()
    print("PASS: 2-recurse.py tests passed")
