
#!/bin/bash

# Arrays to store available names
available=()

# Function to check GitHub availability and store available names
run_github_check() {
    available=()  # Clear the array before checking
    ./check_github_usernames.sh
}

# Function to check popularity score for available names
run_popularity_check() {
    echo
    echo "Checking popularity scores for available names..."

    # Pass the available names directly to the Node.js script
    if [ ${#available[@]} -eq 0 ]; then
        echo "No available names found. Skipping popularity check."
        return
    fi

    # Use Node.js to calculate popularity scores for available names
    node check_popularity_score.js "${available[@]}"
}

# Run GitHub availability check first
echo "Running GitHub availability check for the provided names..."
run_github_check

# Ask the user if they want to proceed with popularity score lookup for the available names
read -p "Do you want to check popularity scores for the available names? (y/n): " user_choice

if [[ "$user_choice" =~ ^[Yy]$ ]]; then
    run_popularity_check
else
    echo "Skipping popularity score check."
fi
