FROM python:3.9-alpine3.13
LABEL maintainer="darren lin"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# run command to run inside docker image
# adduser command adds a user so we don't have to just use the root user.
# Don't run your application using the root user! Security reasons
# the shell script command in there installs requirements.dev.txt if DEV is true
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user && \
    # create directories for static and media files and also assign those directories to the django-user
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol

# update the PATH environment variable: it defines all the directories where executables are run
ENV PATH="/py/bin:$PATH"

# user should be the last line
# the containers made using this dockerfile will use this user
USER django-user