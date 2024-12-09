FROM haskell:9.10.1-slim-bullseye

WORKDIR /app
COPY info_service.hs .
COPY .ghci .

# The Haskell program needs the specified packages, which makes the app start a billion times slower.
RUN cabal update
RUN cabal install --package-env . --lib network utf8-string process

# The command ps is not included in the haskell image
RUN apt-get update && apt-get install -y procps

EXPOSE 8200
ENTRYPOINT ["ghci"]
