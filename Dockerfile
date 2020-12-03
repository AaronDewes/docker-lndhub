FROM alpine:latest AS perms

RUN adduser --disabled-password \
            --home "/lndhub" \
            --gecos "" \
            "lnd"

FROM node:buster-slim AS final

COPY  --from=perms /etc/group /etc/passwd /etc/shadow  /etc/

RUN apt-get update && apt-get -y install git python3 make g++ && rm -rf /var/lib/apt/lists/* && apt-get clean
RUN git clone https://github.com/BlueWallet/LndHub.git /lndhub

WORKDIR /lndhub

RUN npm i

RUN mkdir /lndhub/logs && chown -R lnd:lnd /lndhub
USER lnd

ENV PORT=3000
EXPOSE 3000

CMD cp $LND_CERT_FILE /lndhub/ && cp $LND_ADMIN_MACAROON_FILE /lndhub/ && cd /lndhub && npm start
