#!/bin/bash

docker run --name s2-test --rm -p 8200:8200 devops-project-esa-service2 &
sleep 5
EXPECTED=("Service2:" "Filesystem" "PID" "TTY" "STAT" "COMMAND")
RESPONSE=$(curl telnet://localhost:8200)
for STR in "${EXPECTED[@]}"; do
    if [[ ! "$RESPONSE" =~ "$STR" ]]; then
        echo "Failed: Response missing expected string '$STR'"
        docker stop s2-test
        exit 1
    fi
done
echo "Service2 test successful"
docker stop s2-test
