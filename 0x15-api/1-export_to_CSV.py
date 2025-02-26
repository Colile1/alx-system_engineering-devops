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
