#!/usr/bin/env bash
# setup_and_run.sh
# This script sets up the main files inside the "name" directory and runs them.

set -e  # Exit immediately if a command exits with a non-zero status.

# Create 'name' directory if it doesn't exist
mkdir -p name

# Create subs.py (formerly 0-subs.py)
cat > name/subs.py << 'EOF'
#!/usr/bin/python3
""" Module for querying subreddit subscribers """
import requests

def number_of_subscribers(subreddit):
    url = f"https://www.reddit.com/r/{subreddit}/about.json"
    headers = {'User-Agent': 'ALX-API-Advanced'}
    response = requests.get(url, headers=headers, allow_redirects=False)

    if response.status_code == 200:
        return response.json().get('data', {}).get('subscribers', 0)
    return 0
EOF

# Create top_ten.py (formerly 1-top_ten.py)
cat > name/top_ten.py << 'EOF'
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
EOF

# Create recurse.py (formerly 2-recurse.py)
cat > name/recurse.py << 'EOF'
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
EOF

# Create count.py (formerly 100-count.py)
cat > name/count.py << 'EOF'
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
EOF

# Make all module files executable
chmod +x name/subs.py name/top_ten.py name/recurse.py name/count.py

# Update main files
cat > name/0-main.py << 'EOF'
#!/usr/bin/python3
"""
0-main
"""
import sys

if __name__ == '__main__':
    number_of_subscribers = __import__('subs').number_of_subscribers
    if len(sys.argv) < 2:
        print("Please pass an argument for the subreddit to search.")
    else:
        print("{:d}".format(number_of_subscribers(sys.argv[1])))
EOF

cat > name/1-main.py << 'EOF'
#!/usr/bin/python3
"""
1-main
"""
import sys

if __name__ == '__main__':
    top_ten = __import__('top_ten').top_ten
    if len(sys.argv) < 2:
        print("Please pass an argument for the subreddit to search.")
    else:
        top_ten(sys.argv[1])
EOF

cat > name/2-main.py << 'EOF'
#!/usr/bin/python3
"""
2-main
"""
import sys

if __name__ == '__main__':
    recurse = __import__('recurse').recurse
    if len(sys.argv) < 2:
        print("Please pass an argument for the subreddit to search.")
    else:
        result = recurse(sys.argv[1])
        if result is not None:
            print(len(result))
        else:
            print("None")
EOF

cat > name/100-main.py << 'EOF'
#!/usr/bin/python3
"""
100-main
"""
import sys

if __name__ == '__main__':
    count_words = __import__('count').count_words
    if len(sys.argv) < 3:
        print("Usage: {} <subreddit> <list of keywords>".format(sys.argv[0]))
        print("Ex: {} programming 'python java javascript'".format(sys.argv[0]))
    else:
        result = count_words(sys.argv[1], [x for x in sys.argv[2].split()])
EOF

# Make all main files executable
chmod +x name/0-main.py name/1-main.py name/2-main.py name/100-main.py

# Run all tests
python3 name/0-main.py programming
python3 name/1-main.py programming
python3 name/2-main.py programming
python3 name/100-main.py programming 'python java javascript'
