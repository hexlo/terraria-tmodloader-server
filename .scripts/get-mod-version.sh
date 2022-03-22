#!/bin/bash

# First Argument passed to this script needs to be the github latest release URL
# ie: https://github.com/<username>/<repo>/releases/latest

curl -L --silent \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36" \
    $1 \
    | grep "tree\/v[0-9]*\(\.[0-9]*\)\?\(\.[0-9]*\)\?\(\.[0-9]*\)\?" \
    | sed 's#^.*tree/v##' \
    | sed 's#\".*$##' \
    | tail -n 1
