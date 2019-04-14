# If you have docker installed, you can build this container with the following command:
#
#     > docker build -t cloudtest .
#
# Then you can run a shell inside the container:
#
#     > docker run -it --name cloudtest cloudtest /bin/sh
#
# Or start the container's web server with logging to the console:
#
#     > docker run -e PORT=8080 -p 127.0.0.1:8080:8080 -it --name cloudtest cloudtest


FROM python:2.7.15-alpine

# Install production dependencies.
COPY requirements.txt /
RUN pip install -r requirements.txt

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . .

# Run the web service on container startup using the gunicorn
# webserver with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 app:app
