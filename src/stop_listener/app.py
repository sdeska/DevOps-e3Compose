from flask import Flask
import os
import sys

# A very simple Python script which waits for a REST request.
# Once received, stops all running containers on the host machine.

app = Flask(__name__)

@app.route('/stop', methods = ['POST'])
def stop():
	os.system("docker stop $(docker ps -a -q)")
	sys.exit()

if __name__ == '__main__':
	app.run("host='0.0.0.0', port=22222")
