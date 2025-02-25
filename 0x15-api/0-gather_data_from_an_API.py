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
