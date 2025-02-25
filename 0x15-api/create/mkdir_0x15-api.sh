#!/usr/bin/env bash
# setup.sh
# This script creates the required Python files for the 0x15-api project,
# sets them as executable, and performs verification steps.
#
# Implementation Notes:
# - Each file starts with "#!/usr/bin/python3" and has a module-level docstring.
# - API calls are made using the requests module with a custom User-Agent.
# - Lines are broken to avoid exceeding 79 characters.
# - Two blank lines separate top-level function definitions.
# - No extraneous blank lines appear at the end of files.
#
# Verification:
# - Files are made executable.
# - PEP8 compliance is checked via pycodestyle (if installed).
# - Test cases are executed to verify file outputs.

set -e

# Create project directory if it doesn't exist
mkdir -p 0x15-api

# Create 0-gather_data_from_an_API.py
cat > 0x15-api/0-gather_data_from_an_API.py << 'EOF'
#!/usr/bin/python3
"""Gather data from an API for a given employee's TODO list progress.
Usage: ./0-gather_data_from_an_API.py EMPLOYEE_ID
"""

import requests
import sys


def main():
    """Main function to display an employee's TODO list progress."""
    if len(sys.argv) != 2:
        print("Usage: {} EMPLOYEE_ID".format(sys.argv[0]))
        sys.exit(1)

    try:
        employee_id = int(sys.argv[1])
    except ValueError:
        print("Employee ID must be an integer.")
        sys.exit(1)

    user_url = (
        "https://jsonplaceholder.typicode.com/users/{}"
        .format(employee_id)
    )
    todos_url = (
        "https://jsonplaceholder.typicode.com/todos?userId={}"
        .format(employee_id)
    )
    headers = {"User-Agent": "ALX-API-Advanced"}

    user_response = requests.get(user_url, headers=headers)
    todos_response = requests.get(todos_url, headers=headers)

    if user_response.status_code != 200 or todos_response.status_code != 200:
        sys.exit(1)

    user_data = user_response.json()
    todos_data = todos_response.json()

    employee_name = user_data.get("name")
    total_tasks = len(todos_data)
    completed_tasks = [task for task in todos_data
                       if task.get("completed") is True]
    num_completed = len(completed_tasks)

    print(
        "Employee {} is done with tasks({}/{}):".format(
            employee_name, num_completed, total_tasks
        )
    )
    for task in completed_tasks:
        print("\t {}".format(task.get("title")))


if __name__ == '__main__':
    main()
EOF

# Create 1-export_to_CSV.py
cat > 0x15-api/1-export_to_CSV.py << 'EOF'
#!/usr/bin/python3
"""Export an employee's TODO list progress to CSV.
Usage: ./1-export_to_CSV.py EMPLOYEE_ID
Format: "USER_ID","USERNAME","TASK_COMPLETED_STATUS","TASK_TITLE"
File: EMPLOYEE_ID.csv
"""

import csv
import requests
import sys


def main():
    """Main function to export TODO list to CSV."""
    if len(sys.argv) != 2:
        print("Usage: {} EMPLOYEE_ID".format(sys.argv[0]))
        sys.exit(1)

    try:
        employee_id = int(sys.argv[1])
    except ValueError:
        print("Employee ID must be an integer.")
        sys.exit(1)

    user_url = (
        "https://jsonplaceholder.typicode.com/users/{}"
        .format(employee_id)
    )
    todos_url = (
        "https://jsonplaceholder.typicode.com/todos?userId={}"
        .format(employee_id)
    )
    headers = {"User-Agent": "ALX-API-Advanced"}

    user_response = requests.get(user_url, headers=headers)
    todos_response = requests.get(todos_url, headers=headers)

    if user_response.status_code != 200 or todos_response.status_code != 200:
        sys.exit(1)

    user_data = user_response.json()
    todos_data = todos_response.json()

    username = user_data.get("username")
    filename = "{}.csv".format(employee_id)
    with open(filename, "w", newline="") as csvfile:
        writer = csv.writer(csvfile, quoting=csv.QUOTE_ALL)
        for task in todos_data:
            writer.writerow([
                employee_id,
                username,
                task.get("completed"),
                task.get("title")
            ])


if __name__ == '__main__':
    main()
EOF

# Create 2-export_to_JSON.py
cat > 0x15-api/2-export_to_JSON.py << 'EOF'
#!/usr/bin/python3
"""Export an employee's TODO list progress to JSON.
Usage: ./2-export_to_JSON.py EMPLOYEE_ID
Format: { "USER_ID": [{"task": "TASK_TITLE", "completed": TASK_COMPLETED_STATUS,
"username": "USERNAME"}, ... ] }
File: EMPLOYEE_ID.json
"""

import json
import requests
import sys


def main():
    """Main function to export TODO list to JSON for an employee."""
    if len(sys.argv) != 2:
        print("Usage: {} EMPLOYEE_ID".format(sys.argv[0]))
        sys.exit(1)

    try:
        employee_id = int(sys.argv[1])
    except ValueError:
        print("Employee ID must be an integer.")
        sys.exit(1)

    user_url = (
        "https://jsonplaceholder.typicode.com/users/{}"
        .format(employee_id)
    )
    todos_url = (
        "https://jsonplaceholder.typicode.com/todos?userId={}"
        .format(employee_id)
    )
    headers = {"User-Agent": "ALX-API-Advanced"}

    user_response = requests.get(user_url, headers=headers)
    todos_response = requests.get(todos_url, headers=headers)

    if user_response.status_code != 200 or todos_response.status_code != 200:
        sys.exit(1)

    user_data = user_response.json()
    todos_data = todos_response.json()

    username = user_data.get("username")
    tasks = []
    for task in todos_data:
        tasks.append({
            "task": task.get("title"),
            "completed": task.get("completed"),
            "username": username
        })

    data = {str(employee_id): tasks}
    filename = "{}.json".format(employee_id)
    with open(filename, "w") as jsonfile:
        json.dump(data, jsonfile)


if __name__ == '__main__':
    main()
EOF

# Create 3-dictionary_of_list_of_dictionaries.py
cat > 0x15-api/3-dictionary_of_list_of_dictionaries.py << 'EOF'
#!/usr/bin/python3
"""Export all employees' TODO list progress to JSON.
Usage: ./3-dictionary_of_list_of_dictionaries.py
Format: { "USER_ID": [ {"username": "USERNAME", "task": "TASK_TITLE",
"completed": TASK_COMPLETED_STATUS}, ... ], ... }
File: todo_all_employees.json
"""

import json
import requests


def main():
    """Main function to export all employees' TODO list progress to JSON."""
    users_url = "https://jsonplaceholder.typicode.com/users"
    todos_url = "https://jsonplaceholder.typicode.com/todos"
    headers = {"User-Agent": "ALX-API-Advanced"}

    users_response = requests.get(users_url, headers=headers)
    todos_response = requests.get(todos_url, headers=headers)

    if users_response.status_code != 200 or todos_response.status_code != 200:
        exit(1)

    users_data = users_response.json()
    todos_data = todos_response.json()

    user_dict = {user["id"]: user["username"] for user in users_data}

    all_tasks = {}
    for task in todos_data:
        user_id = task.get("userId")
        if user_id not in all_tasks:
            all_tasks[user_id] = []
        all_tasks[user_id].append({
            "username": user_dict.get(user_id),
            "task": task.get("title"),
            "completed": task.get("completed")
        })

    with open("todo_all_employees.json", "w") as jsonfile:
        json.dump(all_tasks, jsonfile)


if __name__ == '__main__':
    main()
EOF

# Ensure all files end with a newline
for file in 0x15-api/*.py; do
    sed -i -e '$a\' "$file"
done

# Make all Python files executable
chmod +x 0x15-api/*.py

echo "Created Python files in 0x15-api and set them as executable."

# Verification: Check shebang, trailing newline, and executable flag for each file
for file in 0x15-api/*.py; do
    first_line=$(head -n 1 "$file")
    if [ "$first_line" != "#!/usr/bin/python3" ]; then
        echo "Error: $file does not start with '#!/usr/bin/python3'."
        exit 1
    fi
    last_char=$(tail -c1 "$file" | od -An -t x1 | tr -d ' ')
    if [ "$last_char" != "0a" ]; then
        echo "Error: $file does not end with a newline."
        exit 1
    fi
    if [ ! -x "$file" ]; then
        echo "Error: $file is not executable."
        exit 1
    fi
    echo "Verified: $file"
done

# Run PEP8 compliance check if pycodestyle is available
if command -v pycodestyle >/dev/null 2>&1; then
    echo "Running PEP8 style check with pycodestyle..."
    pycodestyle 0x15-api/*.py
else
    echo "pycodestyle is not installed. To check PEP8 compliance, install it with 'pip install pycodestyle'."
fi

# Run test cases for the scripts

echo "Running test for 0-gather_data_from_an_API.py with employee ID 2..."
python3 0x15-api/0-gather_data_from_an_API.py 2

echo "Running test for 1-export_to_CSV.py with employee ID 2..."
python3 0x15-api/1-export_to_CSV.py 2
if [ -f "2.csv" ]; then
    echo "CSV file 2.csv created."
else
    echo "Error: CSV file 2.csv not found."
    exit 1
fi

echo "Running test for 2-export_to_JSON.py with employee ID 2..."
python3 0x15-api/2-export_to_JSON.py 2
if [ -f "2.json" ]; then
    echo "JSON file 2.json created."
else
    echo "Error: JSON file 2.json not found."
    exit 1
fi

echo "Running test for 3-dictionary_of_list_of_dictionaries.py..."
python3 0x15-api/3-dictionary_of_list_of_dictionaries.py
if [ -f "todo_all_employees.json" ]; then
    echo "JSON file todo_all_employees.json created."
else
    echo "Error: JSON file todo_all_employees.json not found."
    exit 1
fi

echo "All tests passed and files verified."
