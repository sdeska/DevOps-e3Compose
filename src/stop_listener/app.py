from flask import Flask, request, Response
from dotenv import load_dotenv, find_dotenv
import os
import sys

load_dotenv(find_dotenv())

app = Flask(__name__)

system_state = {"state": "INIT"}

USERNAME=os.getenv("USERNAME")
PASSWORD=os.getenv("PASSWORD")

@app.route("/state", methods = ["GET", "PUT"])
def state_handler():
	global system_state

	if request.method == "GET":
		return Response(system_state["state"] + "\n", content_type="text/plain", status=200)

	elif request.method == "PUT":
		new_state = request.data.decode("utf-8").strip().upper()
		print(new_state, flush=True)
		valid_states = ["INIT", "RUNNING", "PAUSED", "SHUTDOWN"]
		
		if new_state not in valid_states:
			print("not valid", flush=True)
			return error_resp()
		
		current_state = system_state["state"]

		if current_state == "SHUTDOWN":
			print("shutdown", flush=True)
			return error_resp()
		
		if new_state == current_state:
			print("same state", flush=True)
			return ok_resp()
		
		if new_state == "INIT":
			print("init", flush=True)
			system_state["state"] = "INIT"
			return ok_resp()
		
		if current_state == "INIT" and new_state == "RUNNING":
			print("init -> running, checking auth", flush=True)
			print("username: " + USERNAME + ", password: " + PASSWORD)
			auth = request.authorization
			if not auth or auth.username != USERNAME or auth.password != PASSWORD:
				print("unauth", flush=True)
				return error_resp(401)
			print("authorized", flush=True)
			system_state["state"] = "RUNNING"
			return ok_resp()
		
		if new_state == "PAUSED":
			if current_state != "RUNNING":
				return error_resp()
			system_state["state"] = "PAUSED"
			return ok_resp()
		
		if new_state == "SHUTDOWN":
			if system_state["state"] == "INIT":
				return error_resp()
			system_state["state"] = "SHUTDOWN"
			os.system("docker stop $(docker ps -a -q)")
			sys.exit()
			return ok_resp() # TODO assuming this does not work
		
	return error_resp()

def ok_resp():
	return Response("OK\n", content_type="text/plain", status=200)

def error_resp(code=400):
	return Response("ERROR\n", content_type="text/plain", status=code)

@app.route("/stop", methods = ["POST"])
def stop():
	os.system("docker stop $(docker ps -a -q --filter label=shutdown)")
	sys.exit()

if __name__ == "__main__":
	app.run(host="0.0.0.0", port=8197)
