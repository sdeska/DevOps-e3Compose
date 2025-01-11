FROM python:3.13-alpine
RUN apk add --no-cache \
	docker-cli
WORKDIR /stop_listener
COPY ./src/stop_listener/app.py .
COPY ./src/stop_listener/.env .
RUN pip install --no-cache-dir flask python-dotenv
EXPOSE 8197
CMD ["flask", "run", "--host=0.0.0.0", "--port=8197"]
