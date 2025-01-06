#!/bin/bash

EXPECTED=("Service1:" "Service2:" "Filesystem" "PID" "TTY" "STAT" "COMMAND")
# login-curl.txt contains the credentials in the proper format for curl. Using a file for credentials like this
# is best practice for security. Obviously the file would not be in version control in an actual case.
RESPONSE=$(curl --netrc-file login-curl.txt http://localhost:8198/request)
echo "$RESPONSE"
for STR in "${EXPECTED[@]}"; do
if [[ ! "$RESPONSE" =~ "$STR" ]]; then
    echo "Failed: Response missing expected string '$STR'"
    docker compose down
    exit 1
fi
done
echo "Request test successful"
