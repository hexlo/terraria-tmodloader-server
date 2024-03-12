#!/bin/bash
create-config.sh
tmux new-session -s "tml" ./manage-tModLoaderServer.sh docker --folder /home/tml/.local/share/Terraria/tModLoader