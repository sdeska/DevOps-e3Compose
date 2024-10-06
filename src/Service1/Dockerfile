FROM erlang:alpine

RUN mkdir /build
WORKDIR /build
COPY server.erl .
RUN erlc server.erl

ENTRYPOINT ["erl", "-noshell", "-run", "server"]
