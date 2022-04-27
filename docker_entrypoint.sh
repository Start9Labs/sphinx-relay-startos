#!/bin/bash

set -ea

export PUBLIC_URL=$(yq e '.["tor-address"]' /relay/.lnd/start9/config.yaml):3300
# daemonized tcp proxy to acquire ip address for internal lnd
simpleproxy -d -L 43 -R lnd.embassy:10009

_term() {
  echo "Caught SIGTERM signal!"
  kill -TERM "$properties_process" 2>/dev/null
  kill -TERM "$sphinx_process" 2>/dev/null
}

jq '.production.macaroon_location = "/mnt/lnd/admin.macaroon"' /relay/dist/config/app.json > /relay/dist/config/app.json.tmp && mv /relay/dist/config/app.json.tmp /relay/dist/config/app.json
jq '.production.tls_location = "/mnt/lnd/tls.cert"' /relay/dist/config/app.json > /relay/dist/config/app.json.tmp && mv /relay/dist/config/app.json.tmp /relay/dist/config/app.json
jq '.production.connection_string_path = "/relay/.lnd/connection_string.txt"' /relay/dist/config/app.json > /relay/dist/config/app.json.tmp && mv /relay/dist/config/app.json.tmp /relay/dist/config/app.json
jq '.production.lnd_ip = "localhost"' /relay/dist/config/app.json > /relay/dist/config/app.json.tmp && mv /relay/dist/config/app.json.tmp /relay/dist/config/app.json
jq '.production.lnd_port = "43"' /relay/dist/config/app.json > /relay/dist/config/app.json.tmp && mv /relay/dist/config/app.json.tmp /relay/dist/config/app.json

mkdir -p /relay/.lnd/start9/

if ! test -d /mnt/lnd
then
    echo "LND mountpoint does not exist"
    exit 0
fi

while ! test -f /mnt/lnd/tls.cert
do
    echo "Waiting for LND cert to be generated..."
    sleep 1
done

while ! test -f /mnt/lnd/admin.macaroon
do
    echo "Waiting for LND admin macaroon to be generated..."
    sleep 1
done

render_properties() {
    while true; do
        export CONNECTION_STRING=$(cat /relay/.lnd/connection_string.txt || true)
        if [ -z "$CONNECTION_STRING" ];
        then
            sleep 1
        else
            yq e -n '.type = "string"' > /relay/.lnd/start9/stats.yaml
            yq e -i ".value = \"$CONNECTION_STRING\"" /relay/.lnd/start9/stats.yaml
            yq e -i ".description = \"Connection String to enter into Sphinx Chat mobile app\"" /relay/.lnd/start9/stats.yaml
            yq e -i ".copyable = true" /relay/.lnd/start9/stats.yaml
            yq e -i ".qr = true" /relay/.lnd/start9/stats.yaml
            yq e -i ".masked = true" /relay/.lnd/start9/stats.yaml
            yq e -i '{"Connection String": .}' /relay/.lnd/start9/stats.yaml
            yq e -i '{"data": .}' /relay/.lnd/start9/stats.yaml
            yq e -i '.version = 2' /relay/.lnd/start9/stats.yaml
            sleep 10
        fi
    done
}

render_properties &
properties_process=$!

node /relay/dist/app.js &
sphinx_process=$!

trap _term SIGTERM

wait -n $sphinx_process $properties_process
