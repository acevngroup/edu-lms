# Moodle Devrepo Docker Environment

This repository provides a streamlined way to run a Moodle development environment using Docker Compose. It includes scripts to manage the Docker containers and load necessary environment variables.

## Prerequisites

Before you begin, ensure you have the following installed:

1.  **Docker Desktop (Windows/macOS) or Docker Engine (Linux)**: This project relies on Docker and Docker Compose.

    *   **Installation Command (General)**: For most Linux distributions, you can install Docker by running:
        ```bash
        sudo apt-get update
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        ```
        For detailed installation instructions specific to your operating system, please refer to the [official Docker documentation](https://docs.docker.com/get-docker/).

2.  **Bash Environment (for Windows users)**: The `moodle-docker-compose` script used internally is a bash script (`.sh`).
    *   On **Windows**, you will need `bash.exe` in your system's PATH. This is typically provided by:
        *   [Git for Windows](https://git-scm.com/download/win) (Git Bash)
        *   [Cygwin](https://www.cygwin.com/)
        *   [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install)

## Setup

### 1. Configure the `.env` file

The project uses environment variables to configure the Moodle Docker setup. You need to create a `.env` file in the root directory of this project (i.e., `/.env`).

This file will contain your Moodle Docker configuration. Here's an example of what your `/.env` file might look like. **With MOODLE_DOCKER_WWWROOT, you should use absolute path if using Windows.**

```
MOODLE_DOCKER_WWWROOT=./moodle
MOODLE_DOCKER_DB=pgsql
MOODLE_DOCKER_WEB_PORT=8080
```

**Note**: The provided `run.bat` and `run.sh` scripts will automatically load these variables into your environment before starting Docker Compose.

## Usage

Navigate to the root of your directory in your terminal.

### 1. Start Moodle Docker Environment

To start the Moodle Docker containers in detached mode (background):

*   **On Windows:**
    ```cmd
    Scripts\run.bat
    ```
*   **On Linux/macOS:**
    ```bash
    ./Scripts/run.sh
    ```
The script will load environment variables from `.env`, then navigate to the `moodle-docker` directory and execute `bin/moodle-docker-compose up -d`.

### 2. Set up the database server

Please use this configuration as belows:

```
Database host: db
Database name: moodle
Database user: moodle
Database password: m@0dl3ing
Fixed table: mdl_
Database port: 5432
Unix socket: <empty>
```

### 2. Stop Moodle Docker Environment

To stop and remove the Moodle Docker containers:

*   **On Windows:**
    ```cmd
    Scripts\stop.bat
    ```
*   **On Linux/macOS:**
    ```bash
    ./Scripts/stop.sh
    ```
This script will navigate to the `moodle-docker` directory and execute `bin/moodle-docker-compose down`.

---