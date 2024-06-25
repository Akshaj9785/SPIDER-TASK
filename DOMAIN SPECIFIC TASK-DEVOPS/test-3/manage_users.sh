#!/bin/bash

LOG_FILE="manage_users.log"
CSV_FILE="usernames.csv"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    echo "$1"
}

# Function to update CSV file
update_csv() {
    local action="$1"
    local username="$2"
    local group="$3"
    local permission="$4"

    case $action in
        "add")
            echo "$username,$group,$permission" >> "$CSV_FILE"
            ;;
        "delete")
            sed -i '' "/^$username,/d" "$CSV_FILE"
            ;;
        "modify")
            sed -i '' "s/^$username,.*/$username,$group,$permission/" "$CSV_FILE"
            ;;
    esac
}

# Function to create a user
create_user() {
    local username="$1"
    local group="$2"
    local permission="$3"

    # Create the user
    dscl . -create "/Users/$username"
    dscl . -create "/Users/$username" UserShell /bin/bash
    dscl . -create "/Users/$username" RealName "$username"
    dscl . -create "/Users/$username" UniqueID "$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1 | xargs -I{} expr {} + 1)"
    dscl . -create "/Users/$username" PrimaryGroupID 20
    
    # Create home directory
    mkdir -p "/Users/$username"
    
    # Check if the group exists, if not create it
    if ! dscl . -read "/Groups/$group" >/dev/null 2>&1; then
        dscl . -create "/Groups/$group"
        dscl . -create "/Groups/$group" PrimaryGroupID "$(dscl . -list /Groups PrimaryGroupID | awk '{print $2}' | sort -n | tail -1 | xargs -I{} expr {} + 1)"
    fi
    
    # Add user to the specified group
    dscl . -append "/Groups/$group" GroupMembership "$username"
    
    # Set permissions for the home directory
    chmod "$permission" "/Users/$username"
    
    # Create projects directory
    mkdir -p "/Users/$username/projects"
    
    # Create README.md with welcome message
    echo "Welcome, $username! This is your projects directory. Happy coding!" > "/Users/$username/projects/README.md"
    
    # Set ownership of the projects directory and README.md
    chown -R "$username:$group" "/Users/$username/projects"
    
    update_csv "add" "$username" "$group" "$permission"
    log_message "User $username created successfully with group $group and permission $permission"
    log_message "User $username added to $CSV_FILE"
}

# Function to delete a user
delete_user() {
    local username="$1"
    
    dscl . -delete "/Users/$username"
    rm -rf "/Users/$username"
    update_csv "delete" "$username"
    log_message "User $username deleted successfully"
    log_message "User $username removed from $CSV_FILE"
}

# Function to modify user permissions
modify_user_permissions() {
    local username="$1"
    local new_permission="$2"
    local group

    # Get the current group of the user
    group=$(dscl . -read "/Users/$username" PrimaryGroupID | awk '{print $2}')
    
    chmod "$new_permission" "/Users/$username"
    update_csv "modify" "$username" "$group" "$new_permission"
    log_message "Permissions for user $username changed to $new_permission"
    log_message "Permissions for user $username updated in $CSV_FILE"
}

# Function to run in batch mode
batch_mode() {
    log_message "Starting batch mode processing"
    
    # Check if the input file exists
    if [ ! -f "$CSV_FILE" ]; then
        log_message "Error: $CSV_FILE file not found"
        exit 1
    fi

    # Read the CSV file and process each line
    while IFS=',' read -r username group permission
    do
        create_user "$username" "$group" "$permission"
    done < "$CSV_FILE"

    log_message "Batch mode processing completed"
}

# Function to run in interactive mode
interactive_mode() {
    while true; do
        echo "1. Create user"
        echo "2. Delete user"
        echo "3. Modify user permissions"
        echo "4. Exit"
        read -p "Enter your choice: " choice

        case $choice in
            1)
                read -p "Enter username: " username
                read -p "Enter group: " group
                read -p "Enter permission: " permission
                create_user "$username" "$group" "$permission"
                ;;
            2)
                read -p "Enter username to delete: " username
                delete_user "$username"
                ;;
            3)
                read -p "Enter username to modify: " username
                read -p "Enter new permission: " new_permission
                modify_user_permissions "$username" "$new_permission"
                ;;
            4)
                log_message "Exiting interactive mode"
                exit 0
                ;;
            *)
                echo "Invalid choice. Please try again."
                ;;
        esac
    done
}

# Main script execution
if [ "$(id -u)" -ne 0 ]; then
    log_message "Error: This script must be run as root"
    exit 1
fi

# Check for command line arguments
if [ "$1" = "--interactive" ]; then
    log_message "Starting interactive mode"
    interactive_mode
elif [ "$1" = "--batch" ]; then
    batch_mode
else
    echo "Usage: $0 [--interactive|--batch]"
    echo "  --interactive: Run in interactive mode"
    echo "  --batch: Run in batch mode using $CSV_FILE"
    exit 1
fi

log_message "User management process completed"y
