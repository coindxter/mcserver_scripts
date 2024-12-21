#!/bin/bash

# Define variables
SERVER_DIR="/home/owencrace/mcserver"
WORLD_DIR="$SERVER_DIR/world"
LOG_FILE="$SERVER_DIR/logs/crash.log"
LOCK_FILE="$SERVER_DIR/crash.lock"

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

    sleep 10

    # Check if the tmux session is running
    if ! tmux has-session -t minecraft 2>/dev/null; then
        # Log the tmux session restart attempt with date and time
        echo "[$(date "+%Y-%m-%d %H:%M:%S")] - tmux session is down, starting new session..." >> $LOG_FILE
        # Start a new tmux session
        tmux new-session -d -s minecraft "bash -c 'cd $SERVER_DIR && java -Xmx6144M -Xms6144M -jar server.jar nogui; exec bash'"
    else
        # Check if the Java process is running
        if ! pgrep -f "java.*server.jar" > /dev/null; then
            # Log the Java process restart attempt with date and time
            echo "[$(date "+%Y-%m-%d %H:%M:%S")] - Java process is down, starting Java process..." >> $LOG_FILE
            # Start the Java process within the existing tmux session
            tmux send-keys -t minecraft "cd $SERVER_DIR && java -Xmx6144M -Xms6144M -jar server.jar nogui" C-m
        else
            # Log that the server is up with date and time
            echo "[$(date "+%Y-%m-%d %H:%M:%S")] - Server is up." >> $LOG_FILE
        fi
    fi

    # Remove the lock file
    rm -f "$LOCK_FILE"
} >> "$LOG_FILE" 2>&1

