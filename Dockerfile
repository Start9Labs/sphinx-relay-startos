FROM arm64v8/node:12-buster-slim AS builder

WORKDIR /relay
RUN mkdir /relay/.lnd
COPY --chown=1000:1000 . .

RUN apt-get update

RUN apt install -y make python-minimal
RUN apt install -y g++ gcc libmcrypt-dev
RUN apt-get -y install git

RUN rm ./sphinx-relay/package-lock.json

WORKDIR /relay/sphinx-relay
RUN npm install bcrypt
RUN npm install

RUN cp /relay/sphinx-relay/config/app.json /relay/sphinx-relay/dist/config/app.json
RUN cp /relay/sphinx-relay/config/config.json /relay/sphinx-relay/dist/config/config.json

RUN chown -R 1000:1000 /relay

FROM arm64v8/node:12-buster-slim

USER 1000

WORKDIR /relay

COPY --from=builder /relay/sphinx-relay .

EXPOSE 3300

ENV NODE_ENV production
ENV NODE_SCHEME http
ENV PORT 3300

CMD [ "node", "/relay/sphinx-relay/dist/app.js" ]
