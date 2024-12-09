FROM python:3.13-alpine
RUN apk add --no-cache \
	docker-cli
WORKDIR /stop_listener
COPY ./src/stop_listener/app.py .
RUN pip install --no-cache-dir flask
EXPOSE 22222
CMD ["flask", "run", "--host=0.0.0.0", "--port=22222"]
