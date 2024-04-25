#!/usr/bin/python3
"""
Finds a peak in a list of unsorted integers
"""


def find_peak(int_list):
  """
  Finds a peak in a list of unsorted integers
  """
  
  if not int_list:
    return (None)

  n = len(int_list)

  left = 0
  right = n - 1
  
  while left < right:
    mid = left + (right - left) // 2
    
    if int_list[mid] < int_list[mid + 1]:
      left = mid + 1
    else:
      right = mid
  
  return int_list[left]

