# mcserver_scripts
Collection of bash scripts to automate tasks for your Minecraft server! Perfect for your 2 week minecraft phase. These scripts automate tasks such as backing up your server, restoring from backups, and monitoring your server's health. Each script ensures that your server is properly managed, logs relevant actions, and handles errors gracefully.


## Table of Contents

- [backup.sh](#backup.sh)
- [restore.sh](#restore.sh)
- [crash.sh](#crash.sh)
- [log.sh](#log.sh)
- [start.sh](#start.sh)

## backup.sh
### Overview
This script creates backups of the Minecraft server world directory (```world```) in the form of compressed ```.tar.gz``` archives. It also ensures that only the 4 most recent backups are kept, automatically deleting older backups.

### Usage
The script will create a backup of the world directory and restart the Minecraft server. It will ensure no other backup script is running at the same time using a lock file.
The backup is stored in ```/home/USER/mcserver/backups``` and is named with the current date and time (```world_backup_YYYY-MM-DD_HH-MM-SS.tar.gz```).
## restore.sh

## crash.sh

## log.sh

## start.sh

