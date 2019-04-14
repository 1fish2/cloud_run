# To containerize and upload to Google Container Registry, building the container
# in the server (see https://cloud.google.com/run/docs/quickstarts/build-and-deploy)
# (replace "try-cloud-run-237600" with your Google Cloud project ID):
#
#     > gcloud builds submit --tag gcr.io/try-cloud-run-237600/cloudtest
#
# To deploy it to Cloud Run (TARGET=$USER sets an environment variable for the sample app):
#
#     > gcloud beta run deploy cloudtest --image gcr.io/try-cloud-run-237600/cloudtest --update-env-vars TARGET=$USER
#
# -----------------------------------------------------------------------------
# To containerize this app locally:
#
#     > docker build -t cloudtest .
#
# To run the local container's web server (with logging to the console):
#
#     > docker run -e PORT=8080 -e TARGET=$USER -p 127.0.0.1:8080:8080 -it --name cloudtest cloudtest
#
# To run a shell inside the container:
#
#     > docker run -it --name cloudtest cloudtest /bin/sh


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
ENV TARGET everybody
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 app:app
