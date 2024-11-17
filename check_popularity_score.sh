
#!/bin/bash

# Define the cache file for popularity lookups
popularity_cache_file="popularity_lookup_cache.txt"
touch "$popularity_cache_file"

# Function to read from the popularity cache
check_popularity_cache() {
    local name=$1
    grep -i "^$name:" "$popularity_cache_file"
}

# Function to update the popularity cache
update_popularity_cache() {
    local name=$1
    local score=$2
    echo "$name:$score" >> "$popularity_cache_file"
}

# Function to determine the popularity score of a name (case-insensitive)
check_name_popularity() {
    local name=$1
    name_lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')
    cached_result=$(check_popularity_cache "$name_lower")

    if [ -n "$cached_result" ]; then
        score=$(echo "$cached_result" | cut -d':' -f2)
        echo "📈 Popularity Score (cached) for '$name': $score/100"
        return
    fi

    # Fetch search results using DuckDuckGo (avoiding CAPTCHA issues)
    search_results=$(curl -s "https://duckduckgo.com/html/?q=$name_lower")

    # Print the raw response for debugging
    echo "Raw search response for '$name':"
    echo "$search_results"
    
    # Count occurrences of the name in the search results
    result_count=$(echo "$search_results" | grep -o "$name_lower" | wc -l)

    # Adjust scoring logic based on the result count
    if [ "$result_count" -lt 10 ]; then
        score=1
    elif [ "$result_count" -lt 50 ]; then
        score=25
    elif [ "$result_count" -lt 100 ]; then
        score=50
    elif [ "$result_count" -lt 500 ]; then
        score=75
    else
        score=100
    fi

    echo "📈 Popularity Score for '$name': $score/100"
    update_popularity_cache "$name_lower" "$score"
}

# Prompt user for input
echo "Enter the names to check for popularity score (space or newline-separated). Press Ctrl + D to finish:"
names=()

while IFS= read -r line; do
    names+=("$line")
done

# Normalize to lowercase and remove duplicates
unique_names=($(echo "${names[@]}" | tr '[:upper:]' '[:lower:]' | tr ' ' '
' | sort -u | tr '
' ' '))

for name in "${unique_names[@]}"; do
    check_name_popularity "$name"
done
