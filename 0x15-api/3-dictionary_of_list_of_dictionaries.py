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
