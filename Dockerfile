FROM node:alpine

RUN groupadd -r lndhubuser -g 1001 && useradd -d /home/lndhubuser -u 1001 -r -g lndhubuser lndhubuser
RUN mkdir /home/lndhubuser/ && chown -R 1001:1001 /home/lndhubuser/


RUN apk update
RUN apk upgrade
RUN apk add --update --no-cache git python3 build-base
WORKDIR /git
RUN git clone https://github.com/BlueWallet/LndHub.git /git/lndhub
WORKDIR /git/lndhub

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
#COPY package*.json ./

RUN npm i

# If you are building your code for production
# RUN npm ci --only=production

RUN mkdir /git/lndhub/logs && chown -R 1001:1001 /git/lndhub/

USER lndhubuser


EXPOSE 3000

CMD [ "node", "index.js" ]

