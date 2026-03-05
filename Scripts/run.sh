#!/usr/bin/env bash
set -e

# Get the directory of this script, then go to the Devrepo root.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/.."

# Define the path to the main .env file in Devrepo root
ENV_FILE="./.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "ERROR: .env file not found at $ENV_FILE"
    echo "Please create Devrepo/.env with your Moodle Docker configuration."
    exit 1
fi

echo "Loading environment variables from $ENV_FILE"
# Source the .env file to load variables into the current shell environment
set -a # automatically export all variables
source "$ENV_FILE"
set +a

echo "Environment variables loaded."

# Copy all AI related plugins into the Moodle directory, overwriting existing.
echo "Copying AI plugins (overwriting existing)..."

# Copy Gemini provider plugin
rm -rf "./moodle/public/ai/provider/gemini"
mkdir -p "./moodle/public/ai/provider/gemini"
cp -r "./Plugin/moodle-aiprovider_gemini/." "./moodle/public/ai/provider/gemini"

# Copy AI Manager local plugin
rm -rf "./moodle/local/ai_manager"
mkdir -p "./moodle/local/ai_manager"
cp -r "./Plugin/moodle-local_ai_manager/." "./moodle/public/local/ai_manager"

# Copy TinyMCE AI plugin
rm -rf "./moodle/lib/editor/tiny/plugins/ai"
mkdir -p "./moodle/lib/editor/tiny/plugins/ai"
cp -r "./Plugin/moodle-tiny_ai/." "./moodle/public/lib/editor/tiny/plugins/ai"

# Copy AI Chat block
rm -rf "./moodle/blocks/ai_chat"
mkdir -p "./moodle/blocks/ai_chat"
cp -r "./Plugin/moodle-block_ai_chat/." "./moodle/public/blocks/ai_chat"

echo "All AI plugins copied."

echo "Starting Moodle Docker Compose..."

# Change directory to moodle-docker to run its compose command
cd "./moodle-docker"

# Execute the moodle-docker-compose script
./bin/moodle-docker-compose up -d