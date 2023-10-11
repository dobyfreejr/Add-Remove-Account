#!/bin/bash

# Path to the file containing random names in "First Name Last Name" format, one per line
names_file="random_names.txt"

# Check if the names file exists
if [ ! -f "$names_file" ]; then
    echo "Error: Names file ($names_file) not found."
    exit 1
fi

# Loop to create user accounts with usernames based on first names and last names
while IFS= read -r full_name; do
    # Split the full name into first name and last name
    first_name=$(echo "$full_name" | cut -d' ' -f1)
    last_name=$(echo "$full_name" | cut -d' ' -f2)

    # Construct the username based on the first and last name
    username="${first_name}_${last_name}"

    # Check if the user already exists
    if id "$username" &>/dev/null; then
        echo "User $username already exists."
    else
        # Create the user account with the specified username
        sudo useradd -m -s /bin/bash "$username"

        # Set the user's password to "Snapple24"
        echo "$username:Snapple24" | sudo chpasswd

        # Add the user to the sudo group
        sudo usermod -aG sudo "$username"

        # Add the user to the sudoers file
        echo "$username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

        echo "User $username created with sudo privileges and password Snapple24."
    fi
done < "$names_file"
