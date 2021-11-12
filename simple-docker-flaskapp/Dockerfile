# Based on the Python 3.9 Alpine image
FROM python:3.9-alpine

# Set the directory in the container to /app
WORKDIR /app

# Copy the requirements file
COPY ./src/requirements.txt .

# Install pipenv and requirements
RUN pip3 install -r requirements.txt

# Copy the app file
COPY ./src/app.py .

# Environment Variables
ENV HOST=0.0.0.0
ENV PORT=5000

# Expose the correct port
EXPOSE $PORT

# Entrypoint (Runs the flask app with host and port from ENV
ENTRYPOINT ["pipenv", "run", "python", "-m", "flask", "run", "--host", "$HOST", "--port", "$PORT"]
