#!/bin/bash

# Test state transitions.

# State is initially INIT.
curl http://localhost:8197/state | grep "INIT"

# Login.
curl http://localhost:8197/state --netrc-file ./tests/login-curl.txt -X PUT -d "RUNNING" -H "Content-Type: text/plain" -H "Accept: text/plain" | grep "OK"
curl http://localhost:8197/state | grep "RUNNING"

# Change state to PAUSED.
curl http://localhost:8197/state -X PUT -d "PAUSED" -H "Content-Type: text/plain" -H "Accept: text/plain" | grep "OK"
curl http://localhost:8197/state | grep "PAUSED"

# Nothing should happen when putting the current status.
curl http://localhost:8197/state -X PUT -d "PAUSED" -H "Content-Type: text/plain" -H "Accept: text/plain" | grep "OK"
curl http://localhost:8197/state | grep "PAUSED"

# Back to INIT.
curl http://localhost:8197/state -X PUT -d "INIT" -H "Content-Type: text/plain" -H "Accept: text/plain" | grep "OK"
curl http://localhost:8197/state | grep "INIT"

# Disallowed operation before login.
curl http://localhost:8197/state -X PUT -d "PAUSED" -H "Content-Type: text/plain" -H "Accept: text/plain" | grep "ERROR"

# Unauth attempt to change to RUNNING.
curl http://localhost:8197/state -X PUT -d "RUNNING" -H "Content-Type: text/plain" -H "Accept: text/plain" | grep "ERROR"

# Login again.
curl http://localhost:8197/state --netrc-file ./tests/login-curl.txt -X PUT -d "RUNNING" -H "Content-Type: text/plain" -H "Accept: text/plain" | grep "OK"
curl http://localhost:8197/state | grep "RUNNING"

# Shutdown.
curl http://localhost:8197/state -X PUT -d "SHUTDOWN" -H "Content-Type: text/plain" -H "Accept: text/plain" | grep "Empty reply from server"
