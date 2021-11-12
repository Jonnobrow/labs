from flask import Flask
import socket

app = Flask(__name__)

@app.route("/")
def root():
    hostname = socket.gethostname() 
    ip_addr = socket.gethostbyname(hostname)
    return f"""<h1>Congratulations!</h1>
    <p>Hostname: {hostname} and IP: {ip_addr}</p>
    """


if __name__ == "__main__":
    app.run()

