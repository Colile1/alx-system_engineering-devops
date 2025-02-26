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
