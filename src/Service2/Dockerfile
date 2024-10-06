FROM haskell AS build

WORKDIR /app
COPY info_service.hs .
COPY .ghci .

RUN cabal update
RUN cabal install --package-env . --lib network utf8-string process
# RUN ghc -o info_service info_service.hs

RUN apt-get update && apt-get install -y procps

EXPOSE 8200
ENTRYPOINT ["ghci"]
