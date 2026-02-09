# Run Moodle with Docker: Development Environment Setup Guide for Ubuntu

---

## Overview

This comprehensive guide details how to set up and manage a Dockerized Moodle development environment on Ubuntu. It covers the installation of Docker, configuring network access for Virtual Machines, and using provided scripts to manage your Moodle Docker instance.

### Table of Contents

*   [**Docker Engine and Docker Compose V2 Installation Steps for Ubuntu**](#docker-engine-and-docker-compose-v2-installation-steps-for-ubuntu)
    *   [Step 1: Remove Any Existing Docker Installations](#step-1-remove-any-existing-docker-installations)
    *   [Step 2: Set Up Docker's Official Repository](#step-2-set-up-dockers-official-repository)
    *   [Step 3: Install Docker Engine and the Compose Plugin](#step-3-install-docker-engine-and-the-compose-plugin)
    *   [Step 4: Add Your User to the `docker` Group](#step-4-add-your-user-to-the-docker-group)
    *   [Step 5: Apply Changes (Log Out / Reboot)](#step-5-apply-changes-log-out--reboot)
    *   [Step 6: Verify the Installation](#step-6-verify-the-installation)
*   [**Accessing Dockerized Applications from Your Host PC (VM Network Configuration)**](#accessing-dockerized-applications-from-your-host-pc-vm-network-configuration)
    *   [1. Configure Port Binding in `Devrepo/.env`](#1-configure-port-binding-in-devrepoenv)
    *   [2. VM Network Adapter Configuration](#2-vm-network-adapter-configuration)
    *   [3. VM Firewall Check (if active)](#3-vm-firewall-check-if-active)
*   [**Running Dockerized Applications on Ubuntu**](#running-dockerized-applications-on-ubuntu)
    *   [1. Start Moodle Docker Environment](#1-start-moodle-docker-environment)
    *   [2. Stop Moodle Docker Environment](#2-stop-moodle-docker-environment)

---

### **Docker Engine and Docker Compose V2 Installation Steps for Ubuntu**

Follow these steps precisely to install the latest official Docker Engine (Community Edition) and the Docker Compose V2 CLI plugin on your Ubuntu system. This method ensures you get the official, up-to-date packages directly from Docker's repositories and avoids conflicts with older or repository-managed versions.

#### **Step 1: Remove Any Existing Docker Installations**
*(This prevents conflicts and ensures a clean slate.)*

```bash
# 1. Stop any running Docker services
sudo systemctl stop docker
sudo systemctl stop containerd

# 2. Remove all Docker related packages (purge removes configuration files as well)
sudo apt-get remove --purge -y docker docker-engine docker.io containerd runc docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 3. Remove old Docker data (OPTIONAL - ONLY if you want to delete ALL existing images, containers, and volumes)
#    CAUTION: This command will permanently delete all your Docker data.
# sudo rm -rf /var/lib/docker
# sudo rm -rf /var/lib/containerd

# 4. Clean up any leftover packages that are no longer needed
sudo apt-get autoremove -y
```

#### **Step 2: Set Up Docker's Official Repository**
*(This allows `apt` to find and install the latest Docker packages directly from Docker.)*

```bash
# 1. Update the apt package index to ensure you have the latest package information
sudo apt-get update

# 2. Install necessary packages to allow apt to use a repository over HTTPS
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# 3. Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg # Ensure correct permissions for apt to read the key

# 4. Add the Docker stable repository to your system's apt sources list
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Update the apt package index again (this time to pick up the new Docker repository)
sudo apt-get update
```

#### **Step 3: Install Docker Engine and the Compose Plugin**
*(This installs the core Docker Engine (CLI, containerd), the Buildx plugin, and the Docker Compose V2 plugin.)*

```bash
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

#### **Step 4: Add Your User to the `docker` Group**
*(**CRITICAL!** This allows your non-root user to run Docker commands without needing `sudo`.)*

```bash
sudo usermod -aG docker "$USER"
```

#### **Step 5: Apply Changes (Log Out / Reboot)**
*(**ABSOLUTELY MANDATORY!** The group membership change from Step 4 will not take effect until you refresh your user session.)*

*   **Option A (Recommended, quicker): Log out and log back into your user account.**
    *   Save all your open work.
    *   If you are using a graphical desktop environment, find the "Log Out" option in your system menu.
    *   If you are in a purely terminal session (e.g., via SSH), simply type `exit` and then reconnect.
*   **Option B: Reboot your entire system.**
    ```bash
    sudo reboot
    ```

#### **Step 6: Verify the Installation**
*(After logging back in or rebooting)*

1.  **Verify Docker Engine is running and your user has permissions:**
    ```bash
    docker run hello-world
    ```
    *Expected Output:* A message confirming Docker is working correctly, similar to:
    ```
    Hello from Docker!
    This message shows that your installation appears to be working correctly.
    ...
    ```
    If you still get permission denied errors, ensure you have completed Step 5 correctly.

2.  **Verify Docker Compose V2 (CLI Plugin):**
    ```bash
    docker compose version
    ```
    *Expected Output:* The version of Docker Compose, e.g.:
    ```
    Docker Compose version v2.x.x
    ```

---

## Accessing Dockerized Applications from Your Host PC (VM Network Configuration)

If you are running Docker inside a Virtual Machine (VM), you need to ensure network connectivity to access the web services from your host PC's browser.

### 1. Configure Port Binding in `Devrepo/.env`

Ensure your `Devrepo/.env` file is configured to expose the web server port on all VM interfaces, not just localhost. For example, to expose Moodle on port `8080`:

```.env
# ... existing code ...

MOODLE_DOCKER_WEB_PORT=0.0.0.0:8080

# ... rest of code ...
```
This tells Docker Compose to map the container's port 80 to port 8080 on all network interfaces of your VM.

### 2. VM Network Adapter Configuration

The method to access your Dockerized application from your host PC depends on your VM's network adapter setting:

*   **A. Bridged Adapter (Recommended for direct access):**
    If your VM's network adapter is set to "Bridged Adapter," your VM acts like another computer directly on your local network.
    *   **Action:** Ensure your VM network settings are configured for "Bridged Adapter".
    *   **Access:** Open your browser on your host PC and navigate to `http://<YOUR_VM_IP_ADDRESS>:8080` (e.g., `http://192.168.23.19:8080`).

*   **B. NAT (Network Address Translation) with Port Forwarding:**
    If your VM uses "NAT" networking, your host PC cannot directly initiate connections to the VM's internal IP. You must configure a **port forwarding rule** within your VM software (e.g., VirtualBox, VMware) to redirect traffic from your host PC to the VM.

    **Example NAT Port Forwarding Rule (for VMWare):**

    ![](/Image/1.png)
    ![](/Image/2.png)
    ![](/Image/3.png)
    ![](/Image/4.png)

    This rule forwards traffic from `http://localhost:8080` on your host PC to port `8080` on your VM, which Docker then exposes to the Moodle container.
    *   **Access:** Open your browser on your host PC and navigate to `http://localhost:8080`.

### 3. VM Firewall Check (if active)

Even if Docker exposes ports, a firewall on your VM might block incoming connections.

1.  **Check firewall status on the VM:**
    ```bash
    sudo ufw status
    ```
    If `Status: active`, proceed to step 2. If `Status: inactive`, the firewall is not the issue.

2.  **Allow incoming traffic on the exposed port (e.g., 8080) on the VM:**
    ```bash
    sudo ufw allow 8080/tcp
    ```

---

## Running Dockerized Applications on Ubuntu

Once Docker is installed and verified, you can use the provided scripts to manage your Moodle Docker environment.

### 1. Start Moodle Docker Environment

To start the Moodle Docker containers in detached mode (background):

```bash
bash ./Scripts/run.sh
```
This script will load environment variables from your `Devrepo/.env` file, then execute the `moodle-docker-compose` script to bring up the containers.

### 2. Stop Moodle Docker Environment

To stop and remove the Moodle Docker containers:

```bash
bash ./Scripts/stop.sh
```
This script will load environment variables from your `Devrepo/.env` file, then execute the `moodle-docker-compose` script with the `down` command.