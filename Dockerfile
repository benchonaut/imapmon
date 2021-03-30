FROM python:3.7-alpine

LABEL org.opencontainers.image.source=https://github.com/soar/imapmon

RUN mkdir -p /app \
 && addgroup -g 1000 app \
 && adduser -u 1000 -G app -s /bin/sh -D app
WORKDIR /app

COPY Pipfile* ./
RUN set -euxo pipefail \
 && apk add --no-cache \
        libffi \
 && apk add --no-cache --virtual .build-deps \
        build-base \
        libffi-dev \
        openssl-dev \
 && pip install --upgrade pipenv \
 && python -m pipenv install --system --deploy \
 && apk del --no-cache .build-deps \
 && rm -rf /var/cache/apk/*

COPY . .
RUN pip install -e .

ENTRYPOINT ["imapmon"]
