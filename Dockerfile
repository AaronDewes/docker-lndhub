FROM alpine:latest AS perms
# This is a bit weird, but required to make sure the LND data can be accessed

RUN adduser --disabled-password \
            --home "/lndhub" \
            --gecos "" \
            "lnd"

FROM node:buster-slim AS builder

COPY  --from=perms /etc/group /etc/passwd /etc/shadow  /etc/

RUN apt-get update && apt-get -y install git python3 && rm -rf /var/lib/apt/lists/* && apt-get clean
RUN git clone https://github.com/AaronDewes/LndHub.git -b master /lndhub

WORKDIR /lndhub

RUN npm i

RUN mkdir /lndhub/logs && chown -R lnd:lnd /lndhub

# Cleanup
RUN apt-get -y purge git && apt-get -y autoremove

FROM node:buster-slim

COPY  --from=perms /etc/group /etc/passwd /etc/shadow  /etc/
COPY  --from=builder /lndhub /lndhub

USER lnd

ENV PORT=3000
EXPOSE 3000

CMD cp $LND_CERT_FILE /lndhub/ && cp $LND_ADMIN_MACAROON_FILE /lndhub/ && cd /lndhub && npm start
