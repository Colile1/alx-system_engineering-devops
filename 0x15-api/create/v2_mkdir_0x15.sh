#!/bin/bash

# Create project directory
mkdir -p 0x15-api
cd 0x15-api || exit

# Create 0-gather_data_from_an_API.py
cat > 0-gather_data_from_an_API.py << 'EOF'
#!/usr/bin/python3
"""Gather data from REST API"""
import requests
import sys


def get_employee_todo_progress(employee_id):
    """Fetch and display employee TODO list progress"""
    base_url = "https://jsonplaceholder.typicode.com"
    user_url = f"{base_url}/users/{employee_id}"
    todos_url = f"{base_url}/users/{employee_id}/todos"

    try:
        user_res = requests.get(user_url)
        user_res.raise_for_status()
        user_data = user_res.json()
        
        todos_res = requests.get(todos_url)
        todos_res.raise_for_status()
        todos_data = todos_res.json()

        done_tasks = [task for task in todos_data if task['completed']]
        
        print(f"Employee {user_data['name']} is done with tasks({len(done_tasks)}/{len(todos_data)}):")
        for task in done_tasks:
            print(f"\t {task['title']}")

    except requests.exceptions.RequestException:
        print("Error fetching data")
        sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: ./0-gather_data_from_an_API.py <employee_id>")
        sys.exit(1)
        
    try:
        employee_id = int(sys.argv[1])
        get_employee_todo_progress(employee_id)
    except ValueError:
        print("Employee ID must be an integer")
        sys.exit(1)
EOF

# Create 1-export_to_CSV.py
cat > 1-export_to_CSV.py << 'EOF'
#!/usr/bin/python3
"""Export to CSV format"""
import csv
import requests
import sys


def export_to_csv(employee_id):
    """Export employee tasks to CSV"""
    base_url = "https://jsonplaceholder.typicode.com"
    user_url = f"{base_url}/users/{employee_id}"
    todos_url = f"{base_url}/users/{employee_id}/todos"

    user_res = requests.get(user_url)
    user_data = user_res.json()
    
    todos_res = requests.get(todos_url)
    todos_data = todos_res.json()

    with open(f"{employee_id}.csv", "w", newline="") as csvfile:
        writer = csv.writer(csvfile, quoting=csv.QUOTE_ALL)
        for task in todos_data:
            writer.writerow([
                employee_id,
                user_data['username'],
                task['completed'],
                task['title']
            ])


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: ./1-export_to_CSV.py <employee_id>")
        sys.exit(1)
        
    export_to_csv(int(sys.argv[1]))
EOF

# Create 2-export_to_JSON.py
cat > 2-export_to_JSON.py << 'EOF'
#!/usr/bin/python3
"""Export to JSON format"""
import json
import requests
import sys


def export_to_json(employee_id):
    """Export employee tasks to JSON"""
    base_url = "https://jsonplaceholder.typicode.com"
    user_url = f"{base_url}/users/{employee_id}"
    todos_url = f"{base_url}/users/{employee_id}/todos"

    user_res = requests.get(user_url)
    user_data = user_res.json()
    
    todos_res = requests.get(todos_url)
    todos_data = todos_res.json()

    json_data = {
        str(employee_id): [
            {
                "task": task['title'],
                "completed": task['completed'],
                "username": user_data['username']
            } for task in todos_data
        ]
    }

    with open(f"{employee_id}.json", "w") as jsonfile:
        json.dump(json_data, jsonfile)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: ./2-export_to_JSON.py <employee_id>")
        sys.exit(1)
        
    export_to_json(int(sys.argv[1]))
EOF

# Create 3-dictionary_of_list_of_dictionaries.py
cat > 3-dictionary_of_list_of_dictionaries.py << 'EOF'
#!/usr/bin/python3
"""Export all employees data to JSON"""
import json
import requests


def export_all_to_json():
    """Export all employees' tasks to JSON"""
    base_url = "https://jsonplaceholder.typicode.com"
    users_url = f"{base_url}/users"
    all_data = {}

    users_res = requests.get(users_url)
    users_data = users_res.json()

    for user in users_data:
        user_id = user['id']
        todos_url = f"{base_url}/users/{user_id}/todos"
        todos_res = requests.get(todos_url)
        todos_data = todos_res.json()

        all_data[str(user_id)] = [
            {
                "username": user['username'],
                "task": task['title'],
                "completed": task['completed']
            } for task in todos_data
        ]

    with open("todo_all_employees.json", "w") as jsonfile:
        json.dump(all_data, jsonfile)


if __name__ == "__main__":
    export_all_to_json()
EOF

# Create README.md
echo "# ALX System Engineering & DevOps - REST API Project" > README.md
echo "This project contains Python scripts to interact with JSONPlaceholder API." >> README.md

# Set permissions and verify files
for file in *.py; do
    chmod +x "$file"
    
    # Verify shebang
    if ! head -1 "$file" | grep -q '^#!/usr/bin/python3'; then
        echo "Error: Missing shebang in $file"
        exit 1
    fi
    
    # Check PEP8 compliance
    if ! pycodestyle "$file"; then
        echo "PEP8 style issues found in $file"
        exit 1
    fi
    
    # Check documentation
    if ! python3 -c "print(__import__('${file%.*}').__doc__)" | grep -q '.'; then
        echo "Missing module documentation in $file"
        exit 1
    fi
done

# Final verification
echo -e "\nVerification complete. All files created and checked:"
ls -l *.py README.md

echo -e "\nBasic functionality test for task 0:"
echo "Testing with employee ID 2..."
./0-gather_data_from_an_API.py 2 | head -n 3

echo -e "\nProject setup complete. Remember to test all scripts thoroughly!"
