#!/usr/bin/python3
"""Test for number_of_subscribers function from 0-subs.py"""
import sys

def test_valid_subreddit():
    number_of_subscribers = __import__('0-subs').number_of_subscribers
    subscribers = number_of_subscribers("python")
    if not isinstance(subscribers, int) or subscribers <= 0:
        print("FAIL: number_of_subscribers did not return a positive integer for 'python'")
        sys.exit(1)

def test_invalid_subreddit():
    number_of_subscribers = __import__('0-subs').number_of_subscribers
    subscribers = number_of_subscribers("this_subreddit_does_not_exist_12345")
    if subscribers != 0:
        print("FAIL: number_of_subscribers did not return 0 for an invalid subreddit")
        sys.exit(1)

if __name__ == '__main__':
    test_valid_subreddit()
    test_invalid_subreddit()
    print("PASS: 0-subs.py tests passed")
