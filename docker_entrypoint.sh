#!/bin/sh

export PUBLIC_URL=$TOR_ADDRESS:3300
export LND_IP=$(yq e '.lightning-config.lnd' /relay/.lnd/start9/config.yaml)
export PASSWORD=$(yq e '.password' /relay/.lnd/start9/config.yaml)

echo "/relay/.lnd/start9/public" > /relay/.lnd/.backupignore
echo "/relay/.lnd/start9/shared" >> /relay/.lnd/.backupignore
jq '.production.macaroon_location = "/relay/.lnd/start9/public/lnd/admin.macaroon"' /relay/dist/config/app.json > /relay/dist/config/app.json.tmp && mv /relay/dist/config/app.json.tmp /relay/dist/config/app.json
jq '.production.tls_location = "/relay/.lnd/start9/public/lnd/tls.cert"' /relay/dist/config/app.json > /relay/dist/config/app.json.tmp && mv /relay/dist/config/app.json.tmp /relay/dist/config/app.json
jq '.production.connection_string_path = "/relay/.lnd/connection_string.txt"' /relay/dist/config/app.json > /relay/dist/config/app.json.tmp && mv /relay/dist/config/app.json.tmp /relay/dist/config/app.json
jq ".production.lnd_ip = \"$LND_IP\"" /relay/dist/config/app.json > /relay/dist/config/app.json.tmp && mv /relay/dist/config/app.json.tmp /relay/dist/config/app.json

render_properties() {
    while true; do
        export CONNECTION_STRING=$(cat /relay/.lnd/connection_string.txt || true)
        if [ -z "$CONNECTION_STRING" ];
        then
            sleep 1
        else
            # echo $CONNECTION_STRING > /relay/.lnd/connection_string.txt
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
exec node /relay/dist/app.js
