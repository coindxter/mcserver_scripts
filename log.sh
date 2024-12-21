#!/bin/bash

# Define the log directory
LOG_DIR="/mcserver/logs"

# Echo a message about what the script is doing
echo "Viewing all .log.gz files in $LOG_DIR"

# Change to the log directory
cd $LOG_DIR

# Concatenate and view logs
zcat *.log.gz | less

