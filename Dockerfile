FROM alpine:3.12

RUN apk update
RUN apk add tini

ADD ./sphinx-relay-configurator/target/armv7-unknown-linux-musleabihf/release/sphinx-relay-configurator /usr/local/bin/sphinx-relay-configurator
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

WORKDIR /root

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
