# DevOps-e3Compose
## NOTE: DEVIATIONS FROM INSTRUCTIONS:

- Service 1 does not sleep for 2 seconds after responding to a request. Using the Erlang HTTP server which I did, it is not possible to do this kind of a delay *after* responding.
- Starting the system for the first time takes ~100 seconds on my system, due to image size as well as slowness of the Haskell 'cabal' library manager.
