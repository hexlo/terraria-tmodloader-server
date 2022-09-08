#!/bin/bash

# First Argument passed to this script is the output location

url='https://github.com/tModLoader/tModLoader/releases'

[[ -z ${1} ]] && dest=. || dest=${1%/}

latestVersion=$(curl -L --silent ${url} | grep "/tModLoader/tModLoader/releases/tag/v0." | head -1 | sed 's#^.*/tag/v##' | sed 's#".*$##')


### Since tmodloader 1.3 is not receiving updates anymore, changing the url and echo output to static ones (0.11.8.9).

# downloadURL=${url}/download/v${latestVersion}/tModLoader.Linux.v${latestVersion}.zip
downloadURL='https://github.com/tModLoader/tModLoader/releases/download/v0.11.8.9/tModLoader.Linux.v0.11.8.9.zip'
curl -L --silent ${downloadURL} --output ${dest}/tmodloader-server.zip

# echo "tModLoader: ${latestVersion}"
echo "tModLoader: 0.11.8.9"


# curl -L https://github.com/tModLoader/tModLoader/releases | grep "/tModLoader/tModLoader/releases/tag/v0." | head -1 | sed 's#^.*/tag/v##' | sed 's#".*$##'
# https://github.com/tModLoader/tModLoader/releases/download/v0.11.8.8/tmodLoader.tmod