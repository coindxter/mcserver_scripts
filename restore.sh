#!/bin/bash

# Define variables
BACKUP_DIR="/home/owencrace/mcserver/backups"
SERVER_DIR="/home/owencrace/mcserver"
WORLD_DIR="$SERVER_DIR/world"
LOG_FILE="$SERVER_DIR/logs/restore.log"
LOCK_FILE="$SERVER_DIR/restore.lock"

# Ensure the log file exists
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"
fi

{
    # Wait for the lock file to be removed if it exists
    while [ -f "$LOCK_FILE" ]; do
        sleep 1
    done

    # Create a lock file
    touch "$LOCK_FILE"

    # Find the latest backup file
    LATEST_BACKUP=$(ls -t $BACKUP_DIR/*.tar.gz | head -n 1)

    # Log the restore attempt
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] - Restoring from backup: $LATEST_BACKUP" >> $LOG_FILE

    # Stop the Minecraft server gracefully
    tmux send-keys -t minecraft "say Server is restoring from last session" C-m
    sleep 10
    tmux send-keys -t minecraft "stop" C-m
    sleep 15

    # Kill tmux session
    tmux kill-session

    # Extract the latest backup
    tar -xzf $LATEST_BACKUP -C $SERVER_DIR

    # Ensure the extracted directory is named "world"
    EXTRACTED_DIR=$(tar -tzf $LATEST_BACKUP | head -1 | cut -f1 -d"/")
    if [ "$EXTRACTED_DIR" != "world" ]; then
        mv "$SERVER_DIR/$EXTRACTED_DIR" "$WORLD_DIR"
    fi

    # Log the completion of the restore process
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] - Restore completed" >> $LOG_FILE

    # Restart the Minecraft server
    tmux new-session -d -s minecraft "bash -c 'cd $SERVER_DIR && java -Xmx6144M -Xms6144M -jar server.jar nogui; exec bash'"

    # Wait until the server is up
    while ! tmux has-session -t minecraft 2>/dev/null; do
        sleep 1
    done

    # Log the restart
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] - Server restarted" >> $LOG_FILE

    # Clean up old world directory
    rm -rf "$SERVER_DIR/world_old"

    # Remove the lock file
    rm -f "$LOCK_FILE"
} >> "$LOG_FILE" 2>&1

