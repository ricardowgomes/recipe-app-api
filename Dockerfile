# Steps that Docker need to execute

# Base image and versions that Docker uses
# hub.docker.com for more (alpine is a light version linux)
FROM python:3.9-alpine3.13
LABEL maintainer="@ricardowgomes"

# To see logs in the screen
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Run this python command
# Creates a virtual env
# upgrades python package manager (PIP)
# install the requirement on our Docker image
# rm removes extra dependencies
# adding a extra user (other root user, which is not recomended)
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# This updates the env path
ENV PATH="/py/bin:$PATH"

USER django-user
