#!/bin/bash

set -eu
# First Argument passed to this script needs to be the github repo URL
# ie: https://github.com/<username>/<repo>
#
# Second Argument is the output location. Defaults to current directory

latestReleaseURL=$(echo ${1%/} | xargs)
latestReleaseURL="${latestReleaseURL}/releases/latest"
[[ -z ${2} ]] && dest=. || dest=${2%/}

latestVersion=$(get-mod-version.sh ${latestReleaseURL})
# latestVersion=$(curl -L --silent \
#     -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36" \
#     ${latestReleaseURL} \
#     | grep "tree\/v[0-9]*\(\.[0-9]*\)\?\(\.[0-9]*\)\?\(\.[0-9]*\)\?" \
#     | sed 's#^.*tree/v##' \
#     | sed 's#\".*$##' \
#     | tail -n 1)

# modName=$(curl -L ${latestReleaseURL} | grep '/.*\.tmod' | sed "s#^.*/##" | sed "s#\.tmod.*\$##")
modName=${3}
downloadURL=${1%/}/releases/download/v${latestVersion}/${modName}.tmod
# curl -LN ${downloadURL} --output ${dest}/${modName}.tmod
curl -LN ${downloadURL} > ${dest}/${modName}.tmod;

if [[ ! -z "$latestVersion" ]] ; then
    modName=$(curl -L ${latestReleaseURL} | grep '/.*\.tmod' | sed "s#^.*/##" | sed "s#\.tmod.*\$##")
    downloadURL=${1%/}/releases/download/v${latestVersion}/${modName}.tmod
    curl -L ${downloadURL} --output ${dest}/${modName}.tmod
    echo ${modName}: ${latestVersion}
else
    exit 1
fi