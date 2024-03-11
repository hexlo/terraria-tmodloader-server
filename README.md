[![Buy me a coffee](https://github.com/hexlo/terraria-server-docker/raw/gh-pages/assets/yellow-button-256w.png)](https://www.buymeacoffee.com/hexlo)

```
 __  __     ______     __  __     __         ______
/\ \_\ \   /\  ___\   /\_\_\_\   /\ \       /\  __ \
\ \  __ \  \ \  __\   \/_/\_\/_  \ \ \____  \ \ \/\ \
 \ \_\ \_\  \ \_____\   /\_\/\_\  \ \_____\  \ \_____\
  \/_/\/_/   \/_____/   \/_/\/_/   \/_____/   \/_____/
```

<br>

# **Terraria & tModLoader server**

### This is a tModLoader server for Terraria PC, packaged as a docker image.

<br>

<p style="color:#0078d7; font-family: Consolas">
  <ins> Docker Hub image: </ins>
</p>

```
hexlo/terraria-tmodloader-server:latest
```

<br>

---

<br>

## <ins> **Requirements** </ins>

**_Server-side:_**

- Docker
- docker-compose

**_Client-side:_**

- Terraria
- tModLoader

<br>

---

<br>

## <ins> **General Config** </ins>

- Clone this repository
- Create a `docker-compose.yml` file (see example below).  
You can otherwise rename `docker-compose-example.yml` to `docker-compose.yml` and modify it.
- Edit the environment variables as you see fit. They are explained in a table further down.
- Edit the enabled.json to include the mods you want. Check below for available mods.

<br>

### **_docker-compose.yml example:_**

```
services:
  terraria-tmodloader-server1:
    image: hexlo/terraria-tmodloader-server:latest
    container_name: terraria-tmodloader-server1
    restart: unless-stopped
    stdin_open: true
    tty: true
    ports:
      - 7782:7777
    volumes:
      - type: bind
        source: ./Worlds
        target: /root/.local/share/Terraria/ModLoader/Worlds/
      - type: bind
        source: ./enabled.json
        target: /root/.local/share/Terraria/ModLoader/Mods/enabled.json
    environment:
      - world=/root/.local/share/Terraria/ModLoader/Worlds/Calamity0.wld
      - autocreate=2
      - worldname=Calamity0
      - difficulty=1
      - password=calamity
      - motd="Welcome to hexlo's server! :)"
```

- Launch the container. If you are using a command line interface (cli):  
  `docker-compose up -d`

<br>

---

<br>

## <ins> **Creating and using Worlds** </ins>

### **_Using existing worlds_**

Terraria tModloader worlds are comprised of two files: a `.wld` and a `.twld`  
If you have a Terraria tModloader compatible world already, you can simply put the two files in the `Worlds` directory.  
_Note: worlds created with terraria 1.4 or newer are not compatible with tModLoader's current version_

### **_Creating a new world_**

There is two ways to create a new world.

1. Using variables in the `docker-compose.yml` file (recommended)
2. By spinning a container, manually attaching to it and going through the command prompts of the terraria server.

<ins> 1. Using variables in the docker-compose.yml file: </ins>

You need to set certain variables in the `environment:` part of the docker-compose.yml file, as follows:

```
...
    environment:
      - world=/root/.local/share/Terraria/ModLoader/Worlds/Calamity0.wld
      - autocreate=2
      - worldname=Calamity0
      - difficulty=1
...
```

_Note: the description and possible values of these variables are described in a table below_

<ins> 2. Manually create a world: </ins>

You can create a new world or select different world served by a container by attaching to it.  
`docker attach <container-name>`

- press enter
- Go through the options

To dettach without stopping the container:
`ctrl+p ctrl+q`

<br>

### **Important!**

If you want the server to start automatically on subsequent runs, you need to provide a world path to an existing world, by defining the environment variable `world` as shown in the exemple above.

<br>

---

<br>

## <ins> **Mods** </ins>

Mods included in this image:

- [AlchemistNPC](https://github.com/VVV101/AlchemistNPC)
- [AlchemistNPClite](https://github.com/VVV101/AlchemistNPCLite)
- [BossChecklist](https://github.com/JavidPack/BossChecklist)
- [CalamityMod](https://github.com/MountainDrew8/CalamityMod)
- [CalamityMusicMod](https://github.com/CalamityTeam/CalamityModMusicPublic)
- [ExtensibleInventory](https://github.com/hamstar0/tml-extensibleinventory-mod)
- [Fargowiltas](https://github.com/Fargowilta/Fargowiltas)
- [FargowiltasSouls](https://github.com/Fargowilta/FargowiltasSouls)
- [FargowiltasSoulsDLC](https://github.com/Fargowilta/FargowiltasSoulsDLC)
- [MagicStorageExtra](https://github.com/ExterminatorX99/MagicStorageExtra)
- [RecipeBrowser](https://github.com/JavidPack/RecipeBrowser)
- [SpiritMod](https://github.com/PhoenixBladez/SpiritMod)
- [TerrariaOverhaul](https://github.com/Mirsario/TerrariaOverhaul)
- [ThoriumMod](https://github.com/SamsonAllen13/ThoriumMod)
- [Tremor](https://github.com/IAmBatby/Tremor)
- [WingSlot](https://github.com/abluescarab/tModLoader-WingSlot)
- [WMITF](https://github.com/gardenappl/WMITF)
<!-- end of the list -->

_Note: If you would like mods that are not here, please let me know and I'll try my best to add them._

To enable or disable mods on the server, modify the `enabled.json` file with the names of the mods (the exact names as above). This needs to be done before starting the container.  
Some mods may clash with each others, especially big content mods. Refer to the mod's wiki for more info.

<ins>`enabled.json` example: </ins>

```
[
  "BossChecklist",
  "MagicStorageExtra",
  "RecipeBrowser",
  "ThoriumMod"
]
```

_Notes; The array of mod's names need the following properties:_

- The mod's names are exactly as they appear in the list above
- The mod's names are in double quote
- They are separated with a comma
- There needs to be no trailing comma after the last item in the array
  <br>

### <ins> **Important!**

<ins> On the Client (your computer): </ins>

> You need tModLoader to play on this version of the server. Download it through steam and keep it up to date.

<ins> On the server: </ins>

> If the server gets out of date, make sure you recreate the container to update it.  
> Worlds and players created with 1.4 or newer will not work with this version of tModLoader.

<br>

---

<br>

## <ins> **_Environment Variables_** </ins>

_Note: These are case-sensitive!_

| Env variable |            Default value             | Description                                                                                                                                                                                                                           | Example                                                                                                                                |
| :----------- | :----------------------------------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------- |
| `world`      |              (_empty_)               | Path to your world. _You need to provide a world for the server to start automatically_                                                                                                                                               | `world=/root/.local/share/Terraria/Worlds/My_World.wld`                                                                                |
| `autocreate` |                 `2`                  | Creates a world if none is found in the path specified by -world. World size is specified by: 1(small), 2(medium), and 3(large).                                                                                                      | `autocreate=2`                                                                                                                         |
| `seed`       |              (_empty_)               | Specifies the world seed when using -autocreate                                                                                                                                                                                       | `seed=someseed123`                                                                                                                     |
| `worldname`  |              (_empty_)               | Sets the name of the world when using -autocreate.                                                                                                                                                                                    | `worldname=world1`                                                                                                                     |
| `difficulty` |                 `0`                  | Sets world difficulty when using `autocreate`. Options: 0(normal), 1(expert), 2(master), 3(journey)                                                                                                                                   | `difficulty=1`                                                                                                                         |
| `maxplayers` |                 `16`                 | The maximum number of players allowed                                                                                                                                                                                                 | `maxplayers=8`                                                                                                                         |
| `port`       |                `7777`                | Port used internally by the terraria server. _You should not change this._                                                                                                                                                            | `port=8123`                                                                                                                            |
| `password`   |              (_empty_)               | Set a password for the server                                                                                                                                                                                                         | `password=serverpassword`                                                                                                              |
| `motd`       |              (_empty_)               | Set the server motto of the day text.                                                                                                                                                                                                 | `motd="Welcome to my private server! :)"`                                                                                              |
| `worldpath`  | `/root/.local/share/Terraria/Worlds` | Sets the directory where world files will be stored                                                                                                                                                                                   | `worldpath=/some/other/dir`                                                                                                            |
| `banlist`    |            `banlist.txt`             | The location of the banlist. Defaults to "banlist.txt" in the working directory.                                                                                                                                                      | `banlist=/configs/banlist.txt` -> this would imply that you mount your banlist.txt file in the container's path `/configs/banlist.txt` |
| `secure`     |                 `1`                  | Option to prevent cheats. (1: no cheats or 0: cheats allowed)                                                                                                                                                                         | `secure=0`                                                                                                                             |
| `language`   |               `en/US`                | Sets the server language from its language code. Available codes: `en/US = English` `de/DE = German` `it/IT = Italian` `fr/FR = French` `es/ES = Spanish` `ru/RU = Russian` `zh/Hans = Chinese` `pt/BR = Portuguese` `pl/PL = Polish` | `language=fr/FR`                                                                                                                       |
| `upnp`       |                 `1`                  | Enables/disables automatic universal plug and play.                                                                                                                                                                                   | `upnp=0`                                                                                                                               |
| `npcstream`  |                 `1`                  | Reduces enemy skipping but increases bandwidth usage. The lower the number the less skipping will happen, but more data is sent. 0 is off.                                                                                            | `npcstream=60`                                                                                                                         |
| `priority`   |              (_empty_)               | Sets the process priority                                                                                                                                                                                                             | `priority=1`                                                                                                                           |

<br>

### <ins> **Important!** </ins>

- If the `world` variable is left empty or not included, the server will need to be initialized manually after the container is spun up. You will need to attach to the container and select/create a world and set the players number, port and password manually. If you create a new world, it will be saved in the path defined by the environment variable `worldpath`.

1.  `docker attach <container name>`
2.  press _*enter*_
3.  Go through the options
4.  Detach from the container by pressing `ctrl+p` + `ctrl+q`

- If, after creating your world with a specific seed, the server still doesn't initializes automatically, be sure to comment or remove the `seed=<yourseed>` variable in the docker-compose.yml file.

<br>

---

<br>

## <ins> **List of server-side console commands from the [unofficial wiki](https://terraria.fandom.com/wiki/Server#Server_files)** </ins>

Once a dedicated server is running, the following commands can be run.\
First, attach to the container with `docker attach <container name>`.

```

help - Displays a list of commands.
playing - Shows the list of players. This can be used in-game by typing /playing into the chat.
clear - Clear the console window.
exit - Shutdown the server and save.
exit-nosave - Shutdown the server without saving.
save - Save the game world.
kick <player name> - Kicks a player from the server.
ban <player name> - Bans a player from the server.
password - Show password.
password <pass> - Change password.
version - Print version number.
time - Display game time.
port - Print the listening port.
maxplayers - Print the max number of players.
say <message> - Send a message to all players. They will see the message in yellow prefixed with <server> in the chat.
motd - Print MOTD.
motd <message> - Change MOTD.
dawn - Change time to dawn (4:30 AM).
noon - Change time to noon (12:00 PM).
dusk - Change time to dusk (7:30 PM).
midnight - Change time to midnight (12:00 AM).
settle - Settle all water.

Banning and un-banning
The command ban <player> will ban the indicated player from the server. A banned player, when they try to login, will be displayed the message:You are banned for [duration]: [reason]- [modname]. A banned player may then be un-banned by editing the file "banlist.txt," which is located in the Terraria folder. This document contains a list of all currently banned players. To un-ban a player, delete the player's name and IP address from the list.

```

_Note: no forward-slash `/` is needed before the command, as some command interfaces require._
