#!/bin/bash

# First Argument passed to this script is the output location

url='https://github.com/tModLoader/tModLoader/releases'

[[ -z ${1} ]] && dest=. || dest=${1%/}

latestVersion=$(curl -L --silent ${url} | grep "/tModLoader/tModLoader/releases/tag/v0." | head -1 | sed 's#^.*/tag/v##' | sed 's#".*$##')


downloadURL=${url}/download/v${latestVersion}/tModLoader.Linux.v${latestVersion}.zip
curl -L --silent ${downloadURL} --output ${dest}/tmodloader-server.zip

echo "tModLoader: ${latestVersion}"

# curl -L https://github.com/tModLoader/tModLoader/releases | grep "/tModLoader/tModLoader/releases/tag/v0." | head -1 | sed 's#^.*/tag/v##' | sed 's#".*$##'

# https://github.com/tModLoader/tModLoader/releases/download/v0.11.8.8/tmodLoader.tmod