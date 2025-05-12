#!/bin/bash

# Script to stage, commit, and push changes to a Git repository
# with a commit message indicating the current bootcamp day.

# --- Configuration ---
repo_path="$PWD"        # Path to your Git repository (defaults to current directory)
commit_prefix="bootcamp self" # Prefix for your commit message

# --- Script Logic ---

# Get the current day number (you'll need to manually update this for each day)
# **IMPORTANT: You will need to edit the 'current_day' variable below for each day.**
read -p "Enter the current bootcamp day: " current_day

# Construct the commit message
commit_message="${commit_prefix} - day ${current_day}"

# Navigate to the repository directory (if not already there)
cd "$repo_path" || {
  echo "Error: Could not navigate to repository path: $repo_path"
  exit 1
}

# Check if there are any changes to commit
if git status --porcelain | grep .; then
  echo "Changes detected. Staging and committing..."

  # Stage all changes
  git add .

  # Commit the changes with the dynamic commit message
  git commit -m "$commit_message"

  echo "Successfully committed with message: '$commit_message'"

  # Optional: Push the changes to your remote repository
  read -p "Do you want to push these changes now? (y/N): " push_choice
  if [[ "$push_choice" == "y" || "$push_choice" == "Y" ]]; then
    git push origin $(git rev-parse --abbrev-ref HEAD)
    echo "Pushed changes to the remote repository."
  else
    echo "Skipping push."
  fi

else
  echo "No changes to commit."
fi

exit 0