#!/bin/bash
gitTag=$(git tag --sort version:refname | tail -1 | sed 's#v##')
tagExists=$(! docker manifest inspect ghcr.io/hexlo/terraria-tmodloader-server:${gitTag} > /dev/null 2>&1 ; echo $?;)
if [[ "${tagExists}" = 1 ]]; then
    echo "false"
else
    echo "true"
fi
