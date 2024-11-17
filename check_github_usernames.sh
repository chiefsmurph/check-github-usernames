
#!/bin/bash

# Define the cache file for GitHub lookups
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

# Function to check GitHub availability (case-insensitive)
check_github_username() {
    local name=$1
    name_lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')
    cached_result=$(check_github_cache "$name_lower")

    if [ -n "$cached_result" ]; then
        status=$(echo "$cached_result" | cut -d':' -f2)
        if [ "$status" == "available" ]; then
            echo "✅ Available (cached): $name"
        else
            echo "❌ Taken (cached): $name"
        fi
        return
    fi

    response=$(curl -s -o /dev/null -w "%{http_code}" "https://github.com/$name_lower")

    if [ "$response" == "404" ]; then
        echo "✅ Available: $name"
        update_github_cache "$name_lower" "available"
    else
        echo "❌ Taken: $name"
        update_github_cache "$name_lower" "taken"
    fi
}

# Prompt user for input
echo "Enter the names to check for GitHub availability (space or newline-separated). Press Ctrl + D to finish:"
names=()

while IFS= read -r line; do
    names+=("$line")
done

# Normalize to lowercase and remove duplicates
unique_names=($(echo "${names[@]}" | tr '[:upper:]' '[:lower:]' | tr ' ' '
' | sort -u | tr '
' ' '))

for name in "${unique_names[@]}"; do
    check_github_username "$name"
done
