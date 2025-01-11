#!/bin/bash

# The curl command is suffixed with a tautology (|| true), because otherwise the pipeline fails as curl returns with exit code 52
# due to the server suddenly stopping, which is what we want in this case.
curl -X POST --netrc-file ./tests/login-curl.txt http://localhost:8198/stop || true
sleep 2
UNEXPECTED=("devops-project-esa-nginx" "devops-project-esa-service1" "devops-project-esa-service2" "devops-project-esa-controller")
ACTUAL=$(docker container ls)
for STR in "${UNEXPECTED[@]}"; do
    if [[ "$ACTUAL" =~ "$STR" ]]; then
        echo "Failed: Image '$STR' has an active container"
        docker compose down
        exit 1
    fi
done
echo "Stop test successful"
docker compose down
