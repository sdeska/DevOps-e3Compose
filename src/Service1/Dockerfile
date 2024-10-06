FROM erlang:alpine

# procps is needed for the required ps arguments, as the included alpine ps is very barebones.
RUN apk update && apk add procps

WORKDIR /app
COPY server.erl .
RUN erlc server.erl

ENTRYPOINT ["erl", "-noshell", "-run", "server"]
