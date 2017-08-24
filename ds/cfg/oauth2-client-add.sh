#!/bin/bash -x

usage() {
    echo -e "Usage: oauth2-client-add <@alias> <client-key> <client-secret> <https://redirect-uri>\n"
    exit 1
}

### get the arguments
alias="$1"
[[ ${alias:0:1} == '@' ]] || usage
client_key="$2"
client_secret="$3"
redirect_uri="$4"
[[ ${redirect_uri:0:8} == 'https://' ]] || usage

### add the client
drush $alias oauth2-client-add $client_key "$client_secret" "$redirect_uri"
