#!/bin/bash

# Path to the file containing random names in "First Name Last Name" format, one per line
names_file="random_names.txt"

# Check if the names file exists
if [ ! -f "$names_file" ]; then
    echo "Error: Names file ($names_file) not found."
    exit 1
fi

# Loop to remove user accounts based on the first names and last names
while IFS= read -r full_name; do
    # Split the full name into first name and last name
    first_name=$(echo "$full_name" | cut -d' ' -f1)
    last_name=$(echo "$full_name" | cut -d' ' -f2)

    # Construct the username based on the first and last name
    username="${first_name}_${last_name}"

    # Check if the user exists
    if id "$username" &>/dev/null; then
        # Remove the user account and home directory
        sudo userdel -r "$username"

        # Optionally, you can remove the user from the sudoers file
        sudo sed -i "/$username/d" /etc/sudoers

        echo "User $username has been removed."
    else
        echo "User $username does not exist."
    fi
done < "$names_file"
