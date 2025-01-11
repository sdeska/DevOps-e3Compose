FROM python:3.13-alpine
RUN apk add --no-cache \
	docker-cli
WORKDIR /controller
COPY ./src/controller/app.py .
COPY ./src/controller/.env .
RUN pip install --no-cache-dir flask python-dotenv
EXPOSE 8197
CMD ["flask", "run", "--host=0.0.0.0", "--port=8197"]
