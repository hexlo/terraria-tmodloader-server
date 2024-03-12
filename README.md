```
 __  __     ______     __  __     __         ______
/\ \_\ \   /\  ___\   /\_\_\_\   /\ \       /\  __ \
\ \  __ \  \ \  __\   \/_/\_\/_  \ \ \____  \ \ \/\ \
 \ \_\ \_\  \ \_____\   /\_\/\_\  \ \_____\  \ \_____\
  \/_/\/_/   \/_____/   \/_/\/_/   \/_____/   \/_____/
```

<br>

# tModLoader 1.4.4 Server as a Docker image

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

**Also available: [Vanilla Terraria Multi-Arch Server (amd64 and arm64)](https://github.com/hexlo/terraria-server-docker) ===> Dockerhub image:** `hexlo/terraria-server-docker:latest`

<br>

---

<br>









## <ins> **Requirements** </ins>

**_Server-side:_**

- Docker
- docker compose

**_Client-side:_**

- Terraria 1.4.4 or Greater
- tModLoader 1.4.4 or Greater

<br>

---

<br>

## <ins> **General Config** </ins>

- Clone this repository
- Create a `docker-compose.yml` file (see example below).  
You can otherwise rename `docker-compose-example.yml` to `docker-compose.yml` and modify it.
- Edit the environment variables as you see fit. They are explained in a table further down.
- In the tModLoader/Mods directory, edit the install.txt and enabled.json to include the mods you want. Check below for examples.
- This image uses Environment Variables to setup the server configuration file. You can instead use a serverconfig.txt file to overwrite this behavior if you wish. You need to set (uncomment) the `USE_CONFIG_FILE=1`
variable in the Dockerfile file.
<br>

## <ins> **Generating your World** </ins>

The easiest way to generate a world is to use certain Environment Variables to autocreate a world on container startup. Here are the variables required to do so:

- AUTOCREATE=1
- WORLDNAME=YourWorld.wld
- DIFFICULTY=1

All the variables are explained in the [Environment Variables](#environment-variables) section below.

### **_docker-compose.yml example:_**

```
services:
  tml:
    container_name: tml
    #restart: unless-stopped
    build:
      context: .
      args:
        UID: 1000
        GID: 1000
        #TML_VERSION: v2023.8.3.3
    #entrypoint: [ "/bin/bash" ] # Uncomment this line if you need to poke around in the container
    tty: true
    stdin_open: true
    ports:
      - 7785:7777
    volumes:
      - ./tModLoader:/home/tml/.local/share/Terraria/tModLoader
    environment:
      - AUTOCREATE=1
      - WORLDNAME=tmlCalamity1.wld
      - DIFFICULTY=1
      # - WORLD=/home/tml/.local/share/Terraria/tModLoader/Worlds/tmlCalamity1.wld
      - PASSWORD=passworld
      - MOTD="Welcome to my tModLoader Server :)"
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

### **_Creating a new world_**

There is two ways to create a new world.

1. Using variables in the `docker-compose.yml` file (recommended)
2. By spinning a container, manually attaching to it and going through the command prompts of the terraria server.

### <ins> 1. Using variables in the docker-compose.yml file: </ins>

You need to set certain variables in the `environment:` part of the docker-compose.yml file, as follows:

```
...
    environment:
      - AUTOCREATE=1
      - WORLDNAME=tmlCalamity1.wld
      - DIFFICULTY=1
...
```

_Note: the description and possible values of these variables are described in the [Environment Variables](#environment-variables) section below_

### <ins> 2. Manually create a world: </ins>

You can create a new world or select different world served by a container by attaching to it. Make sure no Environment variables are used. Delete or comment the `environment:` section of the docker-compose.yml file.

`docker exec -it <container-name> tmux a`

if you used the docker-compose.yml provided, the container name is 'tml'. You can then use

`docker exec -it tml tmux a`

- press enter
- Go through the options

To dettach without stopping the container:
`ctrl+b` + `d`

<br>

### **Important!**

If you want the server to start automatically on subsequent runs, you need to provide a world path to an existing world, by defining the environment variable `world`. You can also safely remove the variables used to autocreate your world. Here is an example of the `environment:` section:

```
    environment:
      - WORLD=/home/tml/.local/share/Terraria/tModLoader/Worlds/tmlCalamity1.wld
      - PASSWORD=passworld
      - MOTD="Welcome to my tModLoader Server :)"
```

<br>

---

<br>

## <ins> **Mods** </ins>

You can install Mods by providing Steam Workshop IDs in the `install.txt` file located in `tModLoader/Mods/install.txt`. You can find the Mod ID in the URL of the Mod. For example, the [Calamity Mod](https://steamcommunity.com/sharedfiles/filedetails/?id=2824688072)'s ID is **2824688072**. 

*install.txt* example:
```
2824688072
2824688266
2909886416
2619954303
2669644269
2570931073
2815540735
3044249615
2599842771
2802867430
```

To enable or disable mods on the server, modify the `enabled.json` file located in `tModLoader/Mods/enabled.json` with the names of the mods. Some mods may clash with each others, especially big content mods. Refer to the mod's wiki for more info.

<ins>*enabled.json* example: </ins>

```
[
  "CalamityMod",
  "CalamityModMusic",
  "BossChecklist",
  "RecipeBrowser"
]
```

_Notes; The array of mod's names need the following properties:_

- The mod's names are exactly as they appear in the list above
- The mod's names are in double quote
- They are separated with a comma
- There needs to be no trailing comma after the last item in the array
  <br>

The *install.txt* and *enabled.json* files need to be modidied before building the image.




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

- If the `WORLD` variable is left empty or not included, the server will need to be initialized manually after the container is spun up. You will need to attach to the container and select/create a world and set the players number, port and password manually. If you create a new world, it will be saved in the path defined by the environment variable `worldpath`.

1.  `docker exec -it <container-name> tmux a`
2.  press _*enter*_
3.  Go through the options
4.  Detach from the container by pressing `ctrl+b` + `d`

- If, after creating your world with a specific seed, the server still doesn't initializes automatically, be sure to comment or remove the `seed=<yourseed>` variable in the docker-compose.yml file.

<br>

---

<br>

## <ins> *Server console commands* </ins>

Once a server is running, the following commands can be run. More info on the [Terraria Server Wiki](https://terraria.fandom.com/wiki/Server#Server_files)\
You can either attach to the container or inject a command.
1. To attach to the container, use `docker exec -it <container-name> tmux a`.

2. To inject a command, from the command line, use `docker exec <container-name> inject "command"`.
For example, to send a message to everyone on the server:
`docker exec tml inject "say Hello everyone!"`

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
