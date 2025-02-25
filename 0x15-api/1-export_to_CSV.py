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
