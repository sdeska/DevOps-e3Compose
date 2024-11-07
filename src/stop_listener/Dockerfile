FROM python:3.13
RUN apt-get update && apt-get install -y \
	docker \
	docker-compose \
	&& rm -rf /var/lib/apt/lists/*
WORKDIR /stop_listener
COPY ./src/stop_listener/app.py .
COPY docker-compose.yml .
RUN pip install flask
EXPOSE 22222
CMD ["flask", "run", "--host=0.0.0.0", "--port=22222"]
