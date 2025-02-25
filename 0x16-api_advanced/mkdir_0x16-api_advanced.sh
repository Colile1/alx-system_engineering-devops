#!/usr/bin/env bash
# setup.sh
# This script creates the required Python files and README,
# then verifies that each file meets the project requirements.

set -e

# Create README.md
cat > README.md << 'EOF'
# Reddit API Project

This project contains Python scripts that interact with the Reddit API to fetch and analyze data from subreddits.

## Files

- **0-subs.py**: Returns the number of subscribers for a given subreddit.
- **1-top_ten.py**: Prints the titles of the top 10 hot posts for a given subreddit.
- **2-recurse.py**: Recursively retrieves all hot post titles for a given subreddit.
- **100-count.py**: Recursively counts the occurrences of given keywords in hot post titles.

EOF

# Create 0-subs.py
cat > 0-subs.py << 'EOF'
#!/usr/bin/python3
"""Query Reddit API for subreddit subscriber count"""
import requests


def number_of_subscribers(subreddit):
    """Return number of subscribers for given subreddit"""
    url = f"https://www.reddit.com/r/{subreddit}/about.json"
    headers = {"User-Agent": "ALX-API-Advanced"}

    response = requests.get(url, headers=headers, allow_redirects=False)
    if response.status_code != 200:
        return 0
    return response.json().get("data", {}).get("subscribers", 0)
EOF

# Create 1-top_ten.py
cat > 1-top_ten.py << 'EOF'
#!/usr/bin/python3
"""Query Reddit API for top 10 hot posts"""
import requests


def top_ten(subreddit):
    """Print titles of top 10 hot posts"""
    url = f"https://www.reddit.com/r/{subreddit}/hot.json?limit=10"
    headers = {"User-Agent": "ALX-API-Advanced"}

    response = requests.get(url, headers=headers, allow_redirects=False)
    if response.status_code != 200:
        print(None)
        return

    posts = response.json().get("data", {}).get("children", [])
    [print(post.get("data", {}).get("title")) for post in posts]
EOF

# Create 2-recurse.py with corrected line lengths
cat > 2-recurse.py << 'EOF'
#!/usr/bin/python3
"""Recursively query Reddit API for all hot posts"""
import requests


def recurse(subreddit, hot_list=[], after=None):
    """Return list containing all hot post titles"""
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
        return None

    data = response.json().get("data", {})
    hot_list.extend(
        [post.get("data", {}).get("title") 
         for post in data.get("children", [])]
    )
    after = data.get("after")
    return recurse(subreddit, hot_list, after) if after else hot_list
EOF

# Create 100-count.py with corrected line lengths and alphabetical import order
cat > 100-count.py << 'EOF'
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
EOF

# Ensure all Python files end with a newline (they do because of the EOF marker)

# Make all Python files executable
chmod +x 0-subs.py 1-top_ten.py 2-recurse.py 100-count.py

echo "Created files and set executable permissions."

# Verification: Check that each file starts with the correct shebang,
# ends with a newline, and is executable.
files=("0-subs.py" "1-top_ten.py" "2-recurse.py" "100-count.py")
for file in "${files[@]}"; do
    first_line=$(head -n 1 "$file")
    if [ "$first_line" != "#!/usr/bin/python3" ]; then
        echo "Error: $file does not start with '#!/usr/bin/python3'."
        exit 1
    fi

    # Check if the last character is a newline (hex 0a)
    last_char=$(tail -c1 "$file" | od -An -t x1 | tr -d ' ')
    if [ "$last_char" != "0a" ]; then
        echo "Error: $file does not end with a newline."
        exit 1
    fi

    if [ ! -x "$file" ]; then
        echo "Error: $file is not executable."
        exit 1
    fi

    echo "Verified: $file has the correct shebang, ends with a newline, and is executable."
done

# Run PEP8 style check using pycodestyle if available
if command -v pycodestyle >/dev/null 2>&1; then
    echo "Running PEP8 style check with pycodestyle..."
    pycodestyle *.py
else
    echo "pycodestyle is not installed. To check PEP8 compliance, install it with:"
    echo "  pip install pycodestyle"
fi

# Display file lengths (line counts) using wc -l
echo "File line counts:"
for file in 0-subs.py 1-top_ten.py 2-recurse.py 100-count.py README.md; do
    echo -n "$file: "
    wc -l < "$file"
done

echo "Setup and verification complete."
