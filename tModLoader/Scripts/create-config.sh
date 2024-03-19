#!/bin/bash

if [[ -z ${USE_CONFIG_FILE} ]]; then

    tmlPath="/home/tml/.local/share/Terraria/tModLoader"
    fileName="serverconfig.txt"
    configFile="${tmlPath}/${fileName}"
    touch ${configFile}
    echo > ${configFile}

    if [[ ! -z "${WORLD}" ]]; then
        echo "world=${WORLD}" >> ${configFile}
    else
        echo "world=${tmlPath}/Worlds/${WORLDNAME}" >> ${configFile}
        echo "autocreate=${AUTOCREATE}" >> ${configFile}
        echo "seed=${SEAD}" >> ${configFile}
        echo "worldname=${WORLDNAME}" >> ${configFile}
        echo "difficulty=${DIFFICULTY}" >> ${configFile}
    fi
    echo "maxplayers=${MAXPLAYERS}" >> ${configFile}
    echo "port=${PORT}" >> ${configFile}
    echo "password=${PASSWORD}" >> ${configFile}
    echo "motd=$MOTD" >> ${configFile}
    echo "worldpath=${WORLDPATH}" >> serverconfig.txt
    if [[ -z "${BANLIST}" || "${BANLIST}" == "banlist.txt" ]]; then
        touch banlist.txt
    fi
    echo "banlist=${BANLIST}" >> ${configFile}
    echo "secure=${SECURE}" >> ${configFile}
    echo "language=${LANGUAGE}" >> ${configFile}
    echo "upnp=${UPNP}" >> ${configFile}
    echo "npcstream=${NPCSTREAM}" >> ${configFile}
    echo "priority=${PRIORITY}" >> ${configFile};

    ### tModLoader Specifics
    if [[ -n "${MODPATH}" ]]; then
        echo "modpath=${MODPATH}" >> ${configFile}
    fi

else
    echo "create-config.sh: Using provided serverconfig.txt"
fi;