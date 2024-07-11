#!/bin/bash
if [ ! -f "usernames.csv" ]; then
    echo "usernames.csv file not found" 1>&2
    exit 1
fi
while IFS=',' read username group permission
do    
    dscl . -create "/Users/$username"
    mkdir -p  "/Users/$username"
    if ! dscl . -read "/Groups/$group" >/dev/null 2>&1; then
        dscl . -create "/Groups/$group"
    fi
    dscl . -append "/Groups/$group" GroupMembership "$username"
    chmod "$permission" "/Users/$username"
    mkdir -p  "/Users/$username/projects"
    echo "Welcome, $username! This is your projects directory." > "/Users/$username/projects/README.md"
    chown -R "$username:$group" "/Users/$username/projects"
    echo "User $username created successfully with group $group and permission $permission"
done < usernames.csv

echo "User management process completed"


