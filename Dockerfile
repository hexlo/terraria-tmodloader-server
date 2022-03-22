FROM hexlo/terraria-server-docker:latest

ARG VERSION=latest

ENV VER=$VERSION

ENV LATEST_VERSION=""

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

RUN apt update && apt install -y wget unzip gettext curl

ARG CACHE_DATE=''

WORKDIR /terraria-server

# Get latest tModLoader
RUN mkdir -p /root/.local/share/Terraria/ModLoader/Worlds /root/.local/share/Terraria/ModLoader/Players /root/.local/share/Terraria/ModLoader/Mods \
    && if [ "$VER" = "latest" ]; then \
    echo "using latest version." \
    && export LATEST_VERSION=$(curl -L --silent \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36" \
    https://github.com/tModLoader/tModLoader/releases/latest \
    | grep "tree\/v[0-9]*\(\.[0-9]*\)\?\(\.[0-9]*\)\?\(\.[0-9]*\)\?" \
    | sed 's#^.*tree/v##' \
    | sed 's#\".*$##' \
    | tail -n 1) \
    && export VER=${LATEST_VERSION}; fi \
    && echo "VERSION=${VER}" \
    && touch /terraria-server/info/tModLoader-version.txt \
    && echo "${VER}" > /terraria-server/info/tModLoader-version.txt \
    && curl -L https://github.com/tModLoader/tModLoader/releases/download/v${VER}/tModLoader.Linux.v${VER}.zip --output tmodloader-server.zip \  
    && unzip -o tmodloader-server.zip -d /terraria-server/ \
    && rm tmodloader-server.zip \
    && chmod +x /terraria-server/tModLoaderServer*

# Get latest Calamity Mod 
RUN export CALAMITY_VERSION=$(curl -L --silent \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36" \
    https://github.com/MountainDrew8/CalamityMod/releases/latest \
    | grep "tree\/v[0-9]*\(\.[0-9]*\)\?\(\.[0-9]*\)\?\(\.[0-9]*\)\?" \
    | sed 's#^.*tree/v##' \
    | sed 's#\".*$##' \
    | tail -n 1) \
    && echo "CALAMITY_VERSION=${CALAMITY_VERSION}" \
    && echo "${CALAMITY_VERSION}" > /terraria-server/info/CalamityMod-version.txt \
    && cd /root/.local/share/Terraria/ModLoader/Mods \
    && curl -L https://github.com/MountainDrew8/CalamityMod/releases/download/v${CALAMITY_VERSION}/CalamityMod.tmod --output CalamityMod.tmod \
    && cd /terraria-server

# Get latest Calamity Music Mod
RUN export CM_MUSIC_VERSION=$(curl -L --silent \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36" \
    https://github.com/CalamityTeam/CalamityModMusicPublic/releases/latest \
    | grep "tree\/v[0-9]*\(\.[0-9]*\)\?\(\.[0-9]*\)\?\(\.[0-9]*\)\?" \
    | sed 's#^.*tree/v##' \
    | sed 's#\".*$##' \
    | tail -n 1) \
    && echo "CM_MUSIC_VERSION=${CM_MUSIC_VERSION}" \
    && echo "${CM_MUSIC_VERSION}" > /terraria-server/info/CalamityModMusic-version.txt \
    && cd /root/.local/share/Terraria/ModLoader/Mods \
    && curl -L https://github.com/CalamityTeam/CalamityModMusicPublic/releases/download/v${CM_MUSIC_VERSION}/CalamityModMusic.tmod --output CalamityModMusic.tmod \
    && cd /terraria-server

# Get latest BossChecklist Mod
RUN export BCL_VERSION=$(curl -L --silent \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36" \
    https://github.com/JavidPack/BossChecklist/releases/latest \
    | grep "tree\/v[0-9]*\(\.[0-9]*\)\?\(\.[0-9]*\)\?\(\.[0-9]*\)\?" \
    | sed 's#^.*tree/v##' \
    | sed 's#\".*$##' \
    | tail -n 1) \
    && echo "BCL_VERSION=${BCL_VERSION}" \
    && echo "${BCL_VERSION}" > /terraria-server/info/BossChecklist-version.txt \
    && cd /root/.local/share/Terraria/ModLoader/Mods \
    && curl -L https://github.com/JavidPack/BossChecklist/releases/download/v${BCL_VERSION}/BossChecklist.tmod --output BossChecklist.tmod \
    && cd /terraria-server

# Get latest RecipeBrowser Mod
RUN export RB_VERSION=$(curl -L --silent \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36" \
    https://github.com/JavidPack/RecipeBrowser/releases/latest \
    | grep "tree\/v[0-9]*\(\.[0-9]*\)\?\(\.[0-9]*\)\?\(\.[0-9]*\)\?" \
    | sed 's#^.*tree/v##' \
    | sed 's#\".*$##' \
    | tail -n 1) \
    && echo "RB_VERSION=${RB_VERSION}" \
    && echo "${RB_VERSION}" > /terraria-server/info/RecipeBrowser-version.txt \
    && cd /root/.local/share/Terraria/ModLoader/Mods \
    && curl -L https://github.com/JavidPack/RecipeBrowser/releases/download/v${RB_VERSION}/RecipeBrowser.tmod --output RecipeBrowser.tmod \
    && cd /terraria-server

# Get latest MagicStorageExtra Mod
RUN export MSE_VERSION=$(curl -L --silent \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36" \
    https://github.com/ExterminatorX99/MagicStorageExtra/releases/latest \
    | grep "tree\/v[0-9]*\(\.[0-9]*\)\?\(\.[0-9]*\)\?\(\.[0-9]*\)\?" \
    | sed 's#^.*tree/v##' \
    | sed 's#\".*$##' \
    | tail -n 1) \
    && echo "MSE_VERSION=${MSE_VERSION}" \
    && echo "${MSE_VERSION}" > /terraria-server/info/MagicStorageExtra-version.txt \
    && cd /root/.local/share/Terraria/ModLoader/Mods \
    && curl -L https://github.com/ExterminatorX99/MagicStorageExtra/releases/download/v${MSE_VERSION}/MagicStorageExtra.tmod --output MagicStorageExtra.tmod \
    && cd /terraria-server

# Get latest ThoriumMod
RUN export THORIUM_VERSION=$(curl -L --silent \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36" \
    https://github.com/SamsonAllen13/ThoriumMod/releases/latest \
    | grep "tree\/v[0-9]*\(\.[0-9]*\)\?\(\.[0-9]*\)\?\(\.[0-9]*\)\?" \
    | sed 's#^.*tree/v##' \
    | sed 's#\".*$##' \
    | tail -n 1) \
    && echo "THORIUM_VERSION=${THORIUM_VERSION}" \
    && echo "${THORIUM_VERSION}" > /terraria-server/info/ThoriumMod-version.txt \
    && cd /root/.local/share/Terraria/ModLoader/Mods \
    && curl -L https://github.com/SamsonAllen13/ThoriumMod/releases/download/v${THORIUM_VERSION}/ThoriumMod.tmod --output ThoriumMod.tmod \
    && cd /terraria-server

# # Writing the enabled.json with Mods
# RUN cd /root/.local/share/Terraria/ModLoader/Mods \
#     && touch enabled.json \
#     && echo '[' > enabled.json \
#     && echo '  "CalamityMod",' >> enabled.json \
#     && echo '  "CalamityModMusic",' >> enabled.json \
#     && echo '  "BossChecklist",' >> enabled.json \
#     && echo '  "RecipeBrowser",' >> enabled.json \
#     && echo '  "MagicStorageExtra"' >> enabled.json \
#     && echo ']' >> enabled.json

COPY ./enabled.json /root/.local/share/Terraria/ModLoader/Mods

COPY ./init.sh /terraria-server/init.sh

RUN chmod +x /terraria-server/init.sh

VOLUME ["/root/.local/share/Terraria/ModLoader/Worlds"]

WORKDIR /terraria-server

ENTRYPOINT [ "./init.sh" ]

