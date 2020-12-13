FROM alpine:latest AS perms

# This is a bit weird, but required to make sure the LND data can be accessed. 
RUN adduser --disabled-password \
            --home "/lndhub" \
            --gecos "" \
            "lnd"

FROM node:buster-slim AS builder

RUN apt-get update && apt-get -y install git python3
RUN git clone https://github.com/AaronDewes/LndHub.git -b master /lndhub

WORKDIR /lndhub

RUN npm i

# Delete git data as it's not needed inside the container

RUN rm -rf .git

FROM node:buster-slim

COPY  --from=perms /etc/group /etc/passwd /etc/shadow  /etc/
COPY  --from=builder /lndhub /lndhub

RUN mkdir /lndhub/logs && chown -R lnd:lnd /lndhub

USER lnd

ENV PORT=3000
EXPOSE 3000

CMD cp $LND_CERT_FILE /lndhub/ && cp $LND_ADMIN_MACAROON_FILE /lndhub/ && cd /lndhub && npm start
