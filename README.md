# mcserver_scripts
Collection of bash scripts to automate tasks for your Minecraft server! Perfect for your 2 week minecraft phase. These scripts automate tasks such as backing up your server, restoring from backups, and monitoring your server's health. Each script ensures that your server is properly managed, logs relevant actions, and handles errors gracefully.


## Table of Contents

- [backup.sh](#backup.sh)
- [restore.sh](#restore.sh)
- [crash.sh](#crash.sh)
- [log.sh](#log.sh)
- [start.sh](#start.sh)
- [Usage](#Usage)

## backup.sh

The script will create a backup of the world directory and restart the Minecraft server. It will ensure no other backup script is running at the same time using a lock file. The backup is stored in ```/home/USER/mcserver/backups``` and is named with the current date and time (```world_backup_YYYY-MM-DD_HH-MM-SS.tar.gz```).



## restore.sh

This script restores the Minecraft server from the most recent backup. It gracefully stops the server, extracts the latest backup, and restarts the server with the restored world data.



## crash.sh
This script checks if the Minecraft server is running. If it's not, it will attempt to restart it. If the tmux session or Java process is missing, the script will recreate the session or start the Java process as needed.

### Usage

## log.sh

## start.sh

## Usage
