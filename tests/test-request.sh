#!/bin/bash

EXPECTED=("Service1:" "Service2:" "Filesystem" "PID" "TTY" "STAT" "COMMAND")
# login-curl.txt contains the credentials in the proper format for curl. Using a file for credentials like this
# is best practice for security. Obviously the file would not be in version control in an actual case.
RESPONSE=$(curl --netrc-file ./tests/login-curl.txt http://localhost:8198/request)
sleep 2
echo "$RESPONSE"
for STR in "${EXPECTED[@]}"; do
    if [[ ! "$RESPONSE" =~ "$STR" ]]; then
        echo "Failed: Response missing expected string '$STR'"
        exit 1
    fi
done
echo "Request test successful"
