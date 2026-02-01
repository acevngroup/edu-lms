#!/usr/bin/env bash
set -e

# Get the directory of this script, then go to the moodle-docker directory.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/../moodle-docker"

echo "Stopping Moodle Docker Compose..."

# Execute the moodle-docker-compose script to stop and remove containers
./bin/moodle-docker-compose down