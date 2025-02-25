#!/usr/bin/env bash
# run_tests.sh
# This script creates test files in the tests/ subfolder and runs them.
# Each test file validates the functionality of one of the project modules.

set -e

# Create tests directory if it doesn't exist
mkdir -p tests

# Test for 0-subs.py: number_of_subscribers
cat > tests/test_0_subs.py << 'EOF'
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
EOF

# Test for 1-top_ten.py: top_ten
cat > tests/test_1_top_ten.py << 'EOF'
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
EOF

# Test for 2-recurse.py: recurse
cat > tests/test_2_recurse.py << 'EOF'
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
EOF

# Test for 100-count.py: count_words
cat > tests/test_100_count.py << 'EOF'
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
EOF

# Make all test files executable
chmod +x tests/test_0_subs.py tests/test_1_top_ten.py tests/test_2_recurse.py tests/test_100_count.py

# Run all test files
echo "Running tests..."
for test_file in tests/*.py; do
    echo "Running $test_file..."
    "$test_file"
done

echo "All tests passed."
