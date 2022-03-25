FROM hexlo/terraria-server-docker:latest

### General variables

ENV TMODLOADER_VERSION=""

ENV VERSION_FILE=/terraria-server/versions.txt

ENV MODS_DIR=/root/.local/share/Terraria/ModLoader/Mods

ENV PATH="/scripts:${PATH}"

### Image variables

ENV autocreate=2

ENV seed=

ENV worldname=TerrariaWorld

ENV difficulty=0

ENV maxplayers=16

ENV port=7777

ENV password=''

ENV motd="Welcome!"

ENV worldpath=/root/.local/share/Terraria/ModLoader/Worlds/

ENV banlist=banlist.txt

ENV secure=1

ENV language=en/US

ENV upnp=1

ENV npcstream=1

ENV priority=1

### Logic

RUN mkdir -p /root/.local/share/Terraria/ModLoader/Worlds \
    /root/.local/share/Terraria/ModLoader/Players \
    /root/.local/share/Terraria/ModLoader/Mods \
    /scripts \
    /terraria-server \
    && touch ${VERSION_FILE}

COPY ./.scripts/* /scripts/

RUN chmod +x /scripts/*

RUN mv /scripts/init-tModLoaderServer.sh /terraria-server

WORKDIR /terraria-server

RUN apt update && apt install -y curl unzip

# Get Terraria Server Version
RUN export TERRARIA_VERSION=$(/scripts/get-terraria-version.sh | sed 's/[0-9]/&./g' | sed 's#.$##') \
    echo "terrariaServer=${TERRARIA_VERSION}" | tee -a ${VERSION_FILE}

# tModLoader
RUN export TMODLOADER_VERSION=$(/scripts/get-mod-version.sh https://github.com/tModLoader/tModLoader/releases/latest) \
    && echo "tModLoader: ${TMODLOADER_VERSION}" | tee -a ${VERSION_FILE} \
    && curl -L https://github.com/tModLoader/tModLoader/releases/download/v${TMODLOADER_VERSION}/tModLoader.Linux.v${TMODLOADER_VERSION}.zip --output tmodloader-server.zip \  
    && unzip -o tmodloader-server.zip -d /terraria-server/ \
    && rm tmodloader-server.zip \
    && chmod +x /terraria-server/tModLoaderServer*

# AlchemistNPC
RUN output=$(/scripts/get-mod.sh https://github.com/VVV101/AlchemistNPC ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# AlchemistNPClite
RUN output=$(/scripts/get-mod.sh https://github.com/VVV101/AlchemistNPCLite ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# BossChecklist Mod
RUN output=$(/scripts/get-mod.sh https://github.com/JavidPack/BossChecklist ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# CalamityMod 
RUN output=$(/scripts/get-mod.sh https://github.com/MountainDrew8/CalamityMod ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# CalamityMusicMod
RUN output=$(/scripts/get-mod.sh https://github.com/CalamityTeam/CalamityModMusicPublic ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# ExtensibleInventory
RUN output=$(/scripts/get-mod.sh https://github.com/hamstar0/tml-extensibleinventory-mod ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# Fargowiltas
RUN output=$(/scripts/get-mod.sh https://github.com/Fargowilta/Fargowiltas ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# FargowiltasSouls
RUN output=$(/scripts/get-mod.sh https://github.com/Fargowilta/FargowiltasSouls ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# FargowiltasSoulsDLC
RUN output=$(/scripts/get-mod.sh https://github.com/Fargowilta/FargowiltasSoulsDLC ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# MagicStorageExtra
RUN output=$(/scripts/get-mod.sh https://github.com/ExterminatorX99/MagicStorageExtra ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# RecipeBrowser Mod
RUN output=$(/scripts/get-mod.sh https://github.com/JavidPack/RecipeBrowser ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# TerrariaOverhaul
RUN output=$(/scripts/get-mod.sh https://github.com/Mirsario/TerrariaOverhaul ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# ThoriumMod
RUN output=$(/scripts/get-mod.sh https://github.com/SamsonAllen13/ThoriumMod ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# Tremor
RUN output=$(/scripts/get-mod.sh https://github.com/IAmBatby/Tremor ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# WingSlot
RUN output=$(/scripts/get-mod.sh https://github.com/abluescarab/tModLoader-WingSlot ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

# WMITF
RUN output=$(/scripts/get-mod.sh https://github.com/gardenappl/WMITF ${MODS_DIR}) \
    && echo ${output} | tee -a ${VERSION_FILE}

RUN cd /root/.local/share/Terraria/ModLoader/Mods \
    && touch enabled.json \
    && echo '[' >> enabled.json \
    && echo '   "BossChecklist",' >> enabled.json \
    && echo '   "MagicStorageExtra",' >> enabled.json \
    && echo '   "RecipeBrowser",' >> enabled.json \
    && echo '   "ThoriumMod"' >> enabled.json \
    && echo ']' >> enabled.json

VOLUME ["/root/.local/share/Terraria/ModLoader/Worlds"]

WORKDIR /terraria-server

ENTRYPOINT [ "./init-tModLoaderServer.sh" ]