FROM steamcmd/steamcmd:alpine-3

# Install prerequisites
RUN apk update \
 && apk add --no-cache bash curl tmux libstdc++ libgcc icu-libs bash tmux \
 && rm -rf /var/cache/apk/*

# Fix 32 and 64 bit library conflicts
RUN mkdir /steamlib \
 && mv /lib/libstdc++.so.6 /steamlib \
 && mv /lib/libgcc_s.so.1 /steamlib
ENV LD_LIBRARY_PATH /steamlib

# Set a specific tModLoader version, defaults to the latest Github release
ARG TML_VERSION

# Create tModLoader user and drop root permissions
ARG UID=1000
ARG GID=1000
RUN addgroup -g $GID tml \
 && adduser tml -u $UID -G tml -h /home/tml -D

USER tml
ENV USER tml
ENV HOME /home/tml
WORKDIR $HOME

# Adding Scripts to PATH
ENV SCRIPTS_PATH="/home/tml/.local/share/Terraria/tModLoader/Scripts"
ENV PATH="${SCRIPTS_PATH}:${PATH}"

# Using Environment variables for server config by default. If you would like to use a serverconfig.txt file instead, uncomment the following variable or use it in your docker-compose.yml environment section.
# ENV USE_CONFIG_FILE=1

# Environment variables for server settings
ENV WORLD=""
ENV AUTOCREATE="1"
ENV SEAD=""
ENV WORLDNAME="tmlWorld.wld"
ENV DIFFICULTY="1"
ENV MAXPLAYERS="16"
ENV PORT="7777"
ENV PASSWORD=""
ENV MOTD=""
ENV WORLDPATH="/home/tml/.local/share/Terraria/tModLoader/Worlds/"
ENV BANLIST="banlist.txt"
ENV SECURE="0"
ENV LANGUAGE="en/US"
ENV UPNP="1"
ENV NPCSTREAM="1"
ENV PRIORITY=""

# ENV MODPATH="/home/tml/.local/share/Terraria/tModLoader/Mods/"


# Update SteamCMD and verify latest version
RUN steamcmd +quit

# ADD --chown=tml:tml https://raw.githubusercontent.com/tModLoader/tModLoader/1.4.4/patches/tModLoader/Terraria/release_extras/DedicatedServerUtils/manage-tModLoaderServer.sh .

# If you need to make local edits to the management script copy it to the same
# directory as this file, comment out the above line and uncomment this line:
COPY --chown=tml:tml manage-tModLoaderServer.sh .

RUN ./manage-tModLoaderServer.sh install-tml --github --tml-version $TML_VERSION

EXPOSE 7777

ENTRYPOINT [ "entrypoint.sh" ]