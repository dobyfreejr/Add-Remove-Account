# Add-Remove-Account
#!/bin/bash

# Define the base username
base_username="sysd"

# Define an array of passwords for the service accounts
passwords=("password1" "password2" "password3" "password4" "password5" "password6" "password7" "password8" "password9" "password10")

# Loop to create 10 service accounts with UUIDs under 1000 and specific passwords
for i in {0..9}; do
    # Generate a random UUID
    uuid=$(uuidgen | tr -d '-')
    
    # Calculate a UID based on the UUID
    uid=$((16#${uuid:0:4}))
    
    # Ensure the UID is under 1000
    if [ "$uid" -ge 1000 ]; then
        uid=$((uid % 1000))
    fi
    
    # Combine the base username and UID
    username="${base_username}${uid}"

    # Check if the user already exists
    if id "$username" &>/dev/null; then
        echo "User $username already exists."
    else
        # Create the user account with the specified UID
        sudo useradd -m -s /bin/bash -u "$uid" "$username"

        # Set the user's password from the array
        password="${passwords[$i]}"
        echo "$username:$password" | sudo chpasswd

        # Add the user to the sudo group
        sudo usermod -aG sudo "$username"

        # Add the user to the sudoers file
        echo "$username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

        echo "User $username created with UID $uid, sudo privileges, and password $password."
    fi
done


#!/bin/bash

# Define the base username
base_username="sysd"

# Loop to remove 10 service accounts
for i in {0..9}; do
    # Calculate the UID based on the index
    uid=$((i % 1000))

    # Combine the base username and UID
    username="${base_username}${uid}"

    # Check if the user exists
    if id "$username" &>/dev/null; then
        # Remove the user account and home directory
        sudo userdel -r "$username"

        # Remove the user from the sudoers file
        sudo sed -i "/$username/d" /etc/sudoers

        echo "User $username has been removed."
    else
        echo "User $username does not exist."
    fi
done








