#!/usr/bin/env bash
set -e

# Get the directory of this script, then go to the Devrepo root.
# This is necessary to find the .env file.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/.." # Go to the Devrepo root first

# Define the path to the main .env file in Devrepo root
ENV_FILE="./.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "ERROR: .env file not found at $ENV_FILE"
    echo "Please create Devrepo/.env with your Moodle Docker configuration."
    exit 1
fi

echo "Loading environment variables from $ENV_FILE for stop operation..."
# Source the .env file to load variables into the current shell environment
set -a # automatically export all variables
source "$ENV_FILE"
set +a

echo "Environment variables loaded."

# Now change directory to moodle-docker
cd "./moodle-docker"

echo "Stopping Moodle Docker Compose..."

# Execute the moodle-docker-compose script to stop and remove containers
./bin/moodle-docker-compose down