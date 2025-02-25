#!/usr/bin/python3
"""Test for top_ten function from 1-top_ten.py"""
import sys
import io
from contextlib import redirect_stdout

def test_valid_subreddit():
    top_ten = __import__('1-top_ten').top_ten
    f = io.StringIO()
    with redirect_stdout(f):
        top_ten("python")
    output = f.getvalue().strip()
    if output == "None" or len(output) == 0:
        print("FAIL: top_ten did not print expected output for 'python'")
        sys.exit(1)

def test_invalid_subreddit():
    top_ten = __import__('1-top_ten').top_ten
    f = io.StringIO()
    with redirect_stdout(f):
        top_ten("this_subreddit_does_not_exist_12345")
    output = f.getvalue().strip()
    if output != "None":
        print("FAIL: top_ten did not print 'None' for an invalid subreddit")
        sys.exit(1)

if __name__ == '__main__':
    test_valid_subreddit()
    test_invalid_subreddit()
    print("PASS: 1-top_ten.py tests passed")
