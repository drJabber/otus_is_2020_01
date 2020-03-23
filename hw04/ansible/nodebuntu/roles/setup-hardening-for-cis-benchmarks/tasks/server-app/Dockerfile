
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

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1

EXPOSE 8188

USER webapp

ENTRYPOINT ./entrypoint