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
