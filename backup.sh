#!/bin/bash

# Define variables
BACKUP_DIR="/home/owencrace/mcserver/backups"
SERVER_DIR="/home/owencrace/mcserver"
WORLD_DIR="$SERVER_DIR/world"
LOG_FILE="$SERVER_DIR/logs/backup.log"
LOCK_FILE="$SERVER_DIR/backup.lock"
BACKUP_DATE=$(date "+%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="world_backup_${BACKUP_DATE}.tar.gz"

# Ensure the log file exists
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"
fi

{
    # Check if another instance of the script is running
    if [ -f "$LOCK_FILE" ]; then
        echo "[$(date "+%Y-%m-%d %H:%M:%S")] - Another instance of the script is running. Exiting." >> "$LOG_FILE"
        exit 1
    fi

    # Create a lock file
    touch "$LOCK_FILE"

    # Log the backup attempt
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] - Starting backup" >> "$LOG_FILE"

    # Stop the Minecraft server gracefully
    tmux send-keys -t minecraft "say Server is restarting for backup in 10 seconds. Please wait..." C-m
    sleep 10
    tmux send-keys -t minecraft "stop" C-m
    sleep 20

    # Kill tmux session 
    tmux kill-session

    # Create the backup
    tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$SERVER_DIR" world

    # Log the completion of the backup
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] - Backup completed: $BACKUP_NAME" >> "$LOG_FILE"

    # Remove old backups, keep only the 4 most recent
    ls -1t $BACKUP_DIR/world_backup_*.tar.gz | tail -n +5 | xargs rm -f

    # Restart the Minecraft server
    tmux new-session -d -s minecraft "bash -c 'cd $SERVER_DIR && java -Xmx6144M -Xms6144M -jar server.jar nogui; exec bash'"

    # Log the restart
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] - Server restarted" >> "$LOG_FILE"

    # Remove the lock file
    rm -f "$LOCK_FILE"
} >> "$LOG_FILE" 2>&1

