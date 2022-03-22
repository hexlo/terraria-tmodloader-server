FROM hexlo/terraria-server-docker:latest

### General variables

ENV TMODLOADER_VERSION=""

ENV VERSION_FILE=/terraria-server/versions.txt

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

RUN apt update && apt install -y curl unzip

ARG CACHE_DATE=''

COPY ./.scripts/* /scripts/

RUN chmod +x /scripts/*

RUN mv /scripts/init.sh /terraria-server

RUN mkdir -p /root/.local/share/Terraria/ModLoader/Worlds \
    /root/.local/share/Terraria/ModLoader/Players \
    /root/.local/share/Terraria/ModLoader/Mods

WORKDIR /terraria-server

# Get Terraria Server Version
RUN export TERRARIA_VERSION=$(/scripts/get-terraria-version.sh | sed 's/[0-9]/&./g' | sed 's#.$##') \
    echo "TERRARIA_VERSION=${TERRARIA_VERSION}" \
    echo "terrariaServer=${TERRARIA_VERSION}" > $VERSION_FILE

# Get latest tModLoader
RUN export TMODLOADER_VERSION=$(/scripts/get-mod-version.sh https://github.com/tModLoader/tModLoader/releases/latest) \
    && echo "TMODLOADER_VERSION=${TMODLOADER_VERSION}" \
    && echo "tModLoader=${TMODLOADER_VERSION}" >> $VERSION_FILE \
    && curl -L https://github.com/tModLoader/tModLoader/releases/download/v${TMODLOADER_VERSION}/tModLoader.Linux.v${TMODLOADER_VERSION}.zip --output tmodloader-server.zip \  
    && unzip -o tmodloader-server.zip -d /terraria-server/ \
    && rm tmodloader-server.zip \
    && chmod +x /terraria-server/tModLoaderServer*

# Get latest Calamity Mod 
RUN export CALAMITY_VERSION=$(/scripts/get-mod-version.sh https://github.com/MountainDrew8/CalamityMod/releases/latest) \
    && echo "CALAMITY_VERSION=${CALAMITY_VERSION}" \
    && echo "CalamityMod=${CALAMITY_VERSION}" >> $VERSION_FILE \
    && cd /root/.local/share/Terraria/ModLoader/Mods \
    && curl -L https://github.com/MountainDrew8/CalamityMod/releases/download/v${CALAMITY_VERSION}/CalamityMod.tmod --output CalamityMod.tmod \
    && cd /terraria-server

# Get latest Calamity Music Mod
RUN export CALAMITY_MUSIC_VERSION=$(/scripts/get-mod-version.sh https://github.com/CalamityTeam/CalamityModMusicPublic/releases/latest) \
    && echo "CALAMITY_MUSIC_VERSION=${CALAMITY_MUSIC_VERSION}" \
    && echo "CalamityModMusic=${CALAMITY_MUSIC_VERSION}" >> $VERSION_FILE \
    && cd /root/.local/share/Terraria/ModLoader/Mods \
    && curl -L https://github.com/CalamityTeam/CalamityModMusicPublic/releases/download/v${CALAMITY_MUSIC_VERSION}/CalamityModMusic.tmod --output CalamityModMusic.tmod \
    && cd /terraria-server

# Get latest BossChecklist Mod
RUN export BOSSCHECKLIST_VERSION=$(/scripts/get-mod-version.sh https://github.com/JavidPack/BossChecklist/releases/latest) \
    && echo "BOSSCHECKLIST_VERSION=${BOSSCHECKLIST_VERSION}" \
    && echo "BossChecklist=${BOSSCHECKLIST_VERSION}" >> $VERSION_FILE \
    && cd /root/.local/share/Terraria/ModLoader/Mods \
    && curl -L https://github.com/JavidPack/BossChecklist/releases/download/v${BOSSCHECKLIST_VERSION}/BossChecklist.tmod --output BossChecklist.tmod \
    && cd /terraria-server

# Get latest RecipeBrowser Mod
RUN export RECIPEBROWSER_VERSION=$(/scripts/get-mod-version.sh https://github.com/JavidPack/RecipeBrowser/releases/latest) \
    && echo "RECIPEBROWSER_VERSION=${RECIPEBROWSER_VERSION}" \
    && echo "RecipeBrowser=${RECIPEBROWSER_VERSION}" >> $VERSION_FILE \
    && cd /root/.local/share/Terraria/ModLoader/Mods \
    && curl -L https://github.com/JavidPack/RecipeBrowser/releases/download/v${RECIPEBROWSER_VERSION}/RecipeBrowser.tmod --output RecipeBrowser.tmod \
    && cd /terraria-server

# Get latest MagicStorageExtra Mod
RUN export MAGICSTORAGEEXTRA_VERSION=$(/scripts/get-mod-version.sh https://github.com/ExterminatorX99/MagicStorageExtra/releases/latest) \
    && echo "MAGICSTORAGEEXTRA_VERSION=${MAGICSTORAGEEXTRA_VERSION}" \
    && echo "MagicStorageExtra=${MAGICSTORAGEEXTRA_VERSION}" >> $VERSION_FILE \
    && cd /root/.local/share/Terraria/ModLoader/Mods \
    && curl -L https://github.com/ExterminatorX99/MagicStorageExtra/releases/download/v${MAGICSTORAGEEXTRA_VERSION}/MagicStorageExtra.tmod --output MagicStorageExtra.tmod \
    && cd /terraria-server

# Get latest ThoriumMod
RUN export THORIUM_VERSION=$(/scripts/get-mod-version.sh https://github.com/SamsonAllen13/ThoriumMod/releases/latest) \
    && echo "THORIUM_VERSION=${THORIUM_VERSION}" \
    && echo "ThoriumMod=${THORIUM_VERSION}" >> $VERSION_FILE \
    && cd /root/.local/share/Terraria/ModLoader/Mods \
    && curl -L https://github.com/SamsonAllen13/ThoriumMod/releases/download/v${THORIUM_VERSION}/ThoriumMod.tmod --output ThoriumMod.tmod \
    && cd /terraria-server

COPY ./enabled.json /root/.local/share/Terraria/ModLoader/Mods

VOLUME ["/root/.local/share/Terraria/ModLoader/Worlds"]

WORKDIR /terraria-server

ENTRYPOINT [ "./init.sh" ]