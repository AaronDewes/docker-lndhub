FROM node:buster-slim

RUN groupadd -r lnd -g 1000 && useradd -d /home/lnd -u 1001 -r -g lnd lnd

RUN mkdir /home/lnd/ && chown -R 1000:1000 /home/lnd/
RUN apt-get update && apt-get -y install git python3 make g++ && rm -rf /var/lib/apt/lists/* && apt-get clean
RUN git clone https://github.com/BlueWallet/LndHub.git /lndhub

WORKDIR /lndhub

RUN npm i

RUN mkdir /lndhub/logs && chown -R 1000:1000 /lndhub/

USER lndhubuser

ENV PORT=3000
EXPOSE 3000

CMD cp $LND_CERT_FILE /lndhub/ && cp $LND_ADMIN_MACAROON_FILE /lndhub/ && /lndhub/node_modules/.bin/babel-node index.js
