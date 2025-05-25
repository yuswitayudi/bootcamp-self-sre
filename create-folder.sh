#!/bin/bash

# Script to create a new bootcamp day folder with a specific naming convention.

# --- Configuration ---
base_folder="." # The main bootcamp folder
current_day=""                   # Will be set by the user
topic_name=""                    # Will be set by the user

# --- Script Logic ---

# Check if the base folder exists, create it if not
if [ ! -d "$base_folder" ]; then
  mkdir -p "$base_folder"
  echo "Created base folder: $base_folder"
fi

# Prompt the user for the current day number
# read -p "Enter the current day number (e.g., 5): " current_day
last_day=$(ls | sort -n -t '-' -k 2 | awk -F '-' '{print $2}' | tail -1)
echo "Last day found: $last_day"
current_day=$((last_day + 1))
echo "Current day will be: $current_day"

# Validate the day number (optional, but good practice)
if ! [[ "$current_day" =~ ^[0-9]+$ ]]; then
  echo "Error: Invalid day number. Please enter a positive integer."
  exit 1
fi

# Prompt the user for the topic name
read -p "Enter the topic name (e.g., lists-introduction): " topic_name

# Sanitize the topic name to be folder-friendly (replace spaces with hyphens, lowercase)
sanitized_topic=$(echo "$topic_name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')

# Construct the new folder name
new_folder_name="day-${current_day}-${sanitized_topic}"

# Construct the full path to the new folder
new_folder_path="$base_folder/$new_folder_name"

# Create the new folder
mkdir -p "$new_folder_path"

# Create a README.md file inside the new folder with basic info
readme_path="$new_folder_path/README.md"
echo "# Day $current_day: $topic_name" > "$readme_path"
echo "" >> "$readme_path"
echo "This folder contains materials for Day $current_day with the topic: $topic_name." >> "$readme_path"

# Check if the folder was created successfully
if [ -d "$new_folder_path" ]; then
  echo "Successfully created folder: $new_folder_path"
  echo "Created README.md in: $readme_path"
else
  echo "Error: Failed to create folder: $new_folder_path"
fi

exit 0