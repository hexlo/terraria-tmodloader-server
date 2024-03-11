#!/bin/bash

# First Argument passed to this script is the output location

url='https://github.com/tModLoader/tModLoader/releases/latest'

[[ -z ${1} ]] && dest=. || dest=${1%/}

latestVersion=$(curl -L --silent ${url} | grep "Release 1.4.4-refs/heads/stable Version Update:" | head -1 | sed -E 's#.+?Update: ##' | sed -E 's#(\s*. tModLoader\/tModLoader · GitHub<\/title>)$##' )

downloadURL="https://github.com/tModLoader/tModLoader/releases/download/${latestVersion}/tModLoader.zip"
curl -L --silent ${downloadURL} --output ${dest}/tmodloader-server.zip

echo "tModLoader: ${latestVersion}"