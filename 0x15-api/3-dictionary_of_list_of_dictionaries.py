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
