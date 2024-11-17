#!/bin/bash

# Define the cache file for GitHub username lookups
github_cache_file="github_lookup_cache.txt"
touch "$github_cache_file"

# Function to read from the GitHub cache
check_github_cache() {
    local name=$1
    grep -i "^$name:" "$github_cache_file"
}

# Function to update the GitHub cache
update_github_cache() {
    local name=$1
    local status=$2
    echo "$name:$status" >> "$github_cache_file"
}

# Function to check if a GitHub username is available (case-insensitive)
check_github_availability() {
    local name=$1
    name_lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')
    cached_result=$(check_github_cache "$name_lower")

    if [ -n "$cached_result" ]; then
        status=$(echo "$cached_result" | cut -d':' -f2)
        echo "GitHub availability for '$name': $status (cached)"
         # Add to available names if it's available
        if [ "$status" == "available" ]; then
            available_usernames+=("$name")
        fi
        return
    fi

    # Check GitHub username availability using the GitHub API
    response=$(curl -s -o /dev/null -w "%{http_code}" "https://api.github.com/users/$name_lower")

    # Determine the availability based on the response code
    if [ "$response" -eq 404 ]; then
        status="✅ Available"
    else
        status="❌ Taken"
    fi

    echo "GitHub availability for '$name': $status"
    update_github_cache "$name_lower" "$status"

    # Add to available names if it's available
    if [ "$status" == "✅ Available" ]; then
        available_usernames+=("$name")
    fi
}

# Prompt user for input
echo "Enter the names to check for GitHub username availability (space or newline-separated). Press Ctrl + D to finish:"
names=()

while IFS= read -r line; do
    names+=("$line")
done

# Normalize to lowercase and remove duplicates
unique_names=($(echo "${names[@]}" | tr '[:upper:]' '[:lower:]' | tr ' ' '
' | sort -u | tr '
' ' '))

# Array to hold the names that are available
available_usernames=()

# Check each name's GitHub availability
for name in "${unique_names[@]}"; do
    check_github_availability "$name"
done

# Print out the available usernames
echo "✅ Available GitHub usernames:"
for username in "${available_usernames[@]}"; do
    echo "$username"
done
