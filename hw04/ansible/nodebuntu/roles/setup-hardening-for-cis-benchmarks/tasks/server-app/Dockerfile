
FROM python:3.7-slim-buster

WORKDIR /app

COPY requirements.txt .
COPY ./server/* .
COPY ./entrypoint .
RUN chmod +x entrypoint

RUN pip3.7 install -r requirements.txt

EXPOSE 8188

ENTRYPOINT ./entrypoint