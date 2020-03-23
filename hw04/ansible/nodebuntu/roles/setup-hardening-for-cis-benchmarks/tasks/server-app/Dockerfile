
FROM python:3.7-slim-buster

RUN useradd -d /home/webapp -m -s /bin/bash webapp

WORKDIR /app
RUN chown webapp:webapp $(pwd)

USER webapp
COPY requirements.txt .
COPY ./server/* .
COPY ./entrypoint .

USER root
RUN chmod +x entrypoint
RUN pip3.7 install -r requirements.txt

EXPOSE 8188

USER webapp

ENTRYPOINT ./entrypoint