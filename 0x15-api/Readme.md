# API Data Export Project

This project is part of the ALX system engineering DevOps curriculum.
It provides several Python scripts that interact with a sample REST API (JSONPlaceholder) to fetch and export an employee's TODO list progress in various formats. 
The project demonstrates the use of API calls, error handling, data formatting, and file export in CSV and JSON formats.

---

## Overview

The project includes four main scripts:

1. **0-gather_data_from_an_API.py**  
   - **Purpose**: Fetch and display a given employee’s TODO list progress.
   - **Output**: Prints the employee’s name, the number of completed tasks versus the total number of tasks, and the titles of the completed tasks (each preceded by a tab).
   - **Usage Example**:
     ```bash
     ./0-gather_data_from_an_API.py 2
     ```
     **Sample Output:**
     ```
     Employee Ervin Howell is done with tasks(8/20):
         distinctio vitae autem nihil ut molestias quo
         voluptas quo tenetur perspiciatis explicabo natus
         ...
     ```

2. **1-export_to_CSV.py**  
   - **Purpose**: Export the TODO list of a specific employee to a CSV file.
   - **Output**: Creates a CSV file named `<EMPLOYEE_ID>.csv` with records in the format:  
     `"USER_ID","USERNAME","TASK_COMPLETED_STATUS","TASK_TITLE"`
   - **Usage Example**:
     ```bash
     ./1-export_to_CSV.py 2
     ```
     This will create a file named `2.csv`.

3. **2-export_to_JSON.py**  
   - **Purpose**: Export the TODO list of a specific employee to a JSON file.
   - **Output**: Creates a JSON file named `<EMPLOYEE_ID>.json` with the following structure:
     ```json
     {
       "USER_ID": [
         {
           "task": "TASK_TITLE",
           "completed": TASK_COMPLETED_STATUS,
           "username": "USERNAME"
         },
         ...
       ]
     }
     ```
   - **Usage Example**:
     ```bash
     ./2-export_to_JSON.py 2
     ```
     This will create a file named `2.json`.

4. **3-dictionary_of_list_of_dictionaries.py**  
   - **Purpose**: Export all employees’ TODO list progress into a single JSON file.
   - **Output**: Creates a JSON file named `todo_all_employees.json` with the structure:
     ```json
     {
       "USER_ID": [
         {
           "username": "USERNAME",
           "task": "TASK_TITLE",
           "completed": TASK_COMPLETED_STATUS
         },
         ...
       ],
       "USER_ID": [
         ...
       ]
     }
     ```
   - **Usage Example**:
     ```bash
     ./3-dictionary_of_list_of_dictionaries.py
     ```
     This will create the file `todo_all_employees.json`.

---

## Implementation Notes

- **API Calls**:  
  The scripts use the `requests` module with a custom User-Agent (`ALX-API-Advanced`) to interact with the JSONPlaceholder API.

- **Error Handling**:  
  The scripts check for HTTP status codes to verify successful API responses. If an error occurs (i.e., non-200 status code), the scripts exit gracefully.

- **Data Formatting**:  
  - CSV export uses Python's built-in `csv` module with all fields quoted.
  - JSON exports use the `json` module to properly format and write the output data.

- **PEP8 Compliance**:  
  All code adheres to PEP8 style guidelines. You can validate this using `pycodestyle`.

- **Executable Files**:  
  All scripts are made executable. Ensure you run:
  ```bash
  chmod +x *.py
