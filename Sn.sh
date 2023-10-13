#!/bin/bash

# Path to the file containing first names, one per line
names_file="first_names.txt"

# Check if the names file exists
if [ ! -f "$names_file" ]; then
    echo "Error: Names file ($names_file) not found."
    exit 1
fi

# Loop to create user accounts with usernames based on first names
while IFS= read -r first_name; do
    # Construct the username based on the first name
    username="$first_name"

    # Check if the user already exists
    if id "$username" &>/dev/null; then
        echo "User $username already exists."
    else
        # Create the user account with the specified username
        sudo useradd -m -s /bin/bash "$username"

        # Set the user's password to "Password"
        echo "$username:Password" | sudo chpasswd

        # Add the user to the sudo group
        sudo usermod -aG sudo "$username"

        # Add the user to the sudoers file
        echo "$username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

        echo "User $username created with sudo privileges and password Snapple24."
    fi
done < "$names_file"
