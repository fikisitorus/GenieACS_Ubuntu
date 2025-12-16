#!/bin/bash

# GenieACS Auto Installation Script for Ubuntu
# This script will install GenieACS with all dependencies
# Tested on Ubuntu 20.04 and 22.04
# Created by: Fikri Sitorus

# Set TERM if not set (fix for SSH execution)
[ -z "$TERM" ] && export TERM=xterm

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Clear screen (safe for non-interactive shells)
if [ -t 0 ]; then
    clear 2>/dev/null || printf "\033c"
else
    printf "\n\n"
fi

# ASCII Art Banner
echo -e "${RED}"
cat << "EOF"
 ███████╗██╗██╗  ██╗██████╗ ██╗    ███████╗██╗████████╗ ██████╗ ██████╗ ██╗   ██╗███████╗
 ██╔════╝██║██║ ██╔╝██╔══██╗██║    ██╔════╝██║╚══██╔══╝██╔═══██╗██╔══██╗██║   ██║██╔════╝
 █████╗  ██║█████╔╝ ██████╔╝██║    ███████╗██║   ██║   ██║   ██║██████╔╝██║   ██║███████╗
 ██╔══╝  ██║██╔═██╗ ██╔══██╗██║    ╚════██║██║   ██║   ██║   ██║██╔══██╗██║   ██║╚════██║
 ██║     ██║██║  ██╗██║  ██║██║    ███████║██║   ██║   ╚██████╔╝██║  ██║╚██████╔╝███████║
 ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝    ╚══════╝╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
EOF
echo -e "${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}                    GenieACS Auto Installation Script${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Created by: Fikri Sitorus${NC}"
echo -e "${MAGENTA}Version: 1.0.0 | Date: December 2025${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root or with sudo${NC}"
    exit 1
fi

# Spinner function
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Update system
echo -ne "${YELLOW}[1/9] Updating system packages...${NC}"
apt-get update -y > /dev/null 2>&1 &
spinner $!
wait $!
echo -ne "\r${YELLOW}[1/9] Upgrading system packages...${NC}"
apt-get upgrade -y > /dev/null 2>&1 &
spinner $!
wait $!
echo -e "\r${GREEN}✓ [1/9] System updated successfully${NC}                    "
sleep 0.5

# Install essential libraries including libssl
echo -ne "${YELLOW}[2/9] Installing essential libraries (libssl, build tools)...${NC}"
apt-get install -y \
    build-essential \
    libssl-dev \
    libssl3 \
    openssl \
    curl \
    wget \
    git \
    ca-certificates \
    gnupg > /dev/null 2>&1 &
spinner $!
wait $!
echo -e "\r${GREEN}✓ [2/9] Libraries installed successfully${NC}                              "
sleep 0.5

echo -e "${CYAN}  → OpenSSL version: $(openssl version)${NC}"

# Install Node.js
echo -ne "${YELLOW}[3/9] Installing Node.js...${NC}"
curl -fsSL https://deb.nodesource.com/setup_18.x | bash - > /dev/null 2>&1 &
spinner $!
wait $!
apt-get install -y nodejs > /dev/null 2>&1 &
spinner $!
wait $!
echo -e "\r${GREEN}✓ [3/9] Node.js installed successfully${NC}                      "
sleep 0.5

# Verify Node.js installation
echo -e "${CYAN}  → Node.js version: $(node --version)${NC}"
echo -e "${CYAN}  → NPM version: $(npm --version)${NC}"

# Install MongoDB
echo -ne "${YELLOW}[4/9] Installing MongoDB 4.4...${NC}"
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc 2>/dev/null | gpg --dearmor -o /usr/share/keyrings/mongodb-archive-keyring.gpg 2>/dev/null

# Detect Ubuntu version
UBUNTU_VERSION=$(lsb_release -rs)
if [[ "$UBUNTU_VERSION" == "22.04" ]]; then
    echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list > /dev/null
elif [[ "$UBUNTU_VERSION" == "20.04" ]]; then
    echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list > /dev/null
else
    echo -e "\n${YELLOW}Ubuntu version $UBUNTU_VERSION detected. Using focal repository.${NC}"
    echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list > /dev/null
fi

apt-get update -y > /dev/null 2>&1 &
spinner $!
wait $!
apt-get install -y mongodb-org > /dev/null 2>&1 &
spinner $!
wait $!

# Start and enable MongoDB
systemctl start mongod > /dev/null 2>&1
systemctl enable mongod > /dev/null 2>&1

echo -e "\r${GREEN}✓ [4/9] MongoDB installed and started successfully${NC}                   "
sleep 0.5

# Install GenieACS
echo -ne "${YELLOW}[5/9] Installing GenieACS...${NC}"
npm install -g genieacs > /dev/null 2>&1 &
spinner $!
wait $!
echo -e "\r${GREEN}✓ [5/9] GenieACS installed successfully${NC}                      "
sleep 0.5

# Create GenieACS user
echo -e "${YELLOW}[6/9] Creating GenieACS user...${NC}"
if ! id -u genieacs > /dev/null 2>&1; then
    useradd --system --no-create-home --user-group genieacs
    echo -e "${GREEN}User 'genieacs' created${NC}"
else
    echo -e "${YELLOW}User 'genieacs' already exists${NC}"
fi

# Create directories
echo -e "${YELLOW}[7/9] Creating directories...${NC}"
mkdir -p /opt/genieacs/ext
mkdir -p /var/log/genieacs
chown genieacs:genieacs /opt/genieacs/ext
chown genieacs:genieacs /var/log/genieacs

# Create genieacs.env file with JWT secret
echo -e "${YELLOW}[8/9] Creating environment configuration...${NC}"
cat > /opt/genieacs/genieacs.env << 'EOF'
GENIEACS_CWMP_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-cwmp-access.log
GENIEACS_NBI_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-nbi-access.log
GENIEACS_FS_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-fs-access.log
GENIEACS_UI_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-ui-access.log
GENIEACS_DEBUG_FILE=/var/log/genieacs/genieacs-debug.yaml
NODE_OPTIONS=--enable-source-maps
GENIEACS_EXT_DIR=/opt/genieacs/ext
EOF

# Generate and append JWT secret
node -e "console.log('GENIEACS_UI_JWT_SECRET=' + require('crypto').randomBytes(128).toString('hex'))" >> /opt/genieacs/genieacs.env

chown genieacs:genieacs /opt/genieacs/genieacs.env
chmod 600 /opt/genieacs/genieacs.env
echo -e "${GREEN}Environment file created with JWT secret${NC}"

# Create systemd service files
echo -e "${YELLOW}[9/9] Creating systemd service files...${NC}"

# GenieACS CWMP service
cat > /etc/systemd/system/genieacs-cwmp.service << 'EOF'
[Unit]
Description=GenieACS CWMP
After=network.target mongod.service

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/lib/node_modules/genieacs/bin/genieacs-cwmp
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# GenieACS NBI service
cat > /etc/systemd/system/genieacs-nbi.service << 'EOF'
[Unit]
Description=GenieACS NBI
After=network.target mongod.service

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/lib/node_modules/genieacs/bin/genieacs-nbi
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# GenieACS FS service
cat > /etc/systemd/system/genieacs-fs.service << 'EOF'
[Unit]
Description=GenieACS FS
After=network.target mongod.service

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/lib/node_modules/genieacs/bin/genieacs-fs
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# GenieACS UI service
cat > /etc/systemd/system/genieacs-ui.service << 'EOF'
[Unit]
Description=GenieACS UI
After=network.target mongod.service

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/lib/node_modules/genieacs/bin/genieacs-ui
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload

# Start and enable GenieACS services
echo -e "${YELLOW}[9/9] Starting GenieACS services...${NC}"
systemctl start genieacs-cwmp
systemctl enable genieacs-cwmp
systemctl start genieacs-nbi
systemctl enable genieacs-nbi
systemctl start genieacs-fs
systemctl enable genieacs-fs
systemctl start genieacs-ui
systemctl enable genieacs-ui

# Wait for services to start
sleep 5

# Check service status
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Service Status:${NC}"
systemctl is-active --quiet genieacs-cwmp && echo -e "CWMP: ${GREEN}Running${NC}" || echo -e "CWMP: ${RED}Stopped${NC}"
systemctl is-active --quiet genieacs-nbi && echo -e "NBI: ${GREEN}Running${NC}" || echo -e "NBI: ${RED}Stopped${NC}"
systemctl is-active --quiet genieacs-fs && echo -e "FS: ${GREEN}Running${NC}" || echo -e "FS: ${RED}Stopped${NC}"
systemctl is-active --quiet genieacs-ui && echo -e "UI: ${GREEN}Running${NC}" || echo -e "UI: ${RED}Stopped${NC}"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${YELLOW}Access Information:${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "Web UI: http://$(hostname -I | awk '{print $1}'):3000"
echo -e "CWMP: http://$(hostname -I | awk '{print $1}'):7547"
echo -e "NBI (API): http://$(hostname -I | awk '{print $1}'):7557"
echo -e "FS: http://$(hostname -I | awk '{print $1}'):7567"
echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${MAGENTA}IMPORTANT: First Time Setup${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "${YELLOW}1. Open Web UI in your browser${NC}"
echo -e "${YELLOW}2. GenieACS will automatically create the first admin user${NC}"
echo -e "${YELLOW}3. Create your admin username and password${NC}"
echo ""
echo -e "${YELLOW}Useful Commands:${NC}"
echo -e "Check status: sudo systemctl status genieacs-*"
echo -e "Stop services: sudo systemctl stop genieacs-*"
echo -e "Start services: sudo systemctl start genieacs-*"
echo -e "Restart services: sudo systemctl restart genieacs-*"
echo -e "View logs: sudo journalctl -u genieacs-cwmp -f"
echo ""
echo -e "${GREEN}Installation completed successfully!${NC}"
