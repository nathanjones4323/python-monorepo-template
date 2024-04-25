# Use an official Python runtime as a parent image
FROM python:3.11

# Install Poetry and pin the version
RUN pip install poetry==1.7.1

# Copy the application and local packages into the container
# COPY ./apps/conversational-ai . #### CHANGE THIS TO THE NAME OF THE PROJECT FOLDER
# COPY ./libs/api ./libs/api #### CHANGE THIS TO THE NAME OF THE PACKAGE YOU WANT TO COPY
# COPY ./libs/intercom ./libs/intercom #### CHANGE THIS TO THE NAME OF THE PACKAGE YOU WANT TO COPY

### Configure Poetry and install dependencies
# Set the environment variable to disable virtualenv creation
ENV POETRY_VIRTUALENVS_CREATE=false
ENV POETRY_CACHE_DIR=/tmp/poetry_cache

 # Configure Poetry
RUN poetry config virtualenvs.in-project false

# Install dependencies and remove the cache (don't need in docker image and this makes the image smaller)
RUN poetry install --no-interaction --no-ansi && rm -rf $POETRY_CACHE_DIR
