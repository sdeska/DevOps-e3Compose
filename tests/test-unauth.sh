#!/bin/bash

EXPECTED="401 Authorization Required"
ACTUAL=$(curl http://localhost:8198/request)
echo "$ACTUAL" | grep "$EXPECTED"
echo "Unauth test successful"
