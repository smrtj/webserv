#!/bin/bash
# install-openwebui-multi.sh
# KOTE / Jordan multi-instance OpenWebUI installer
# For WEB SERV — Chat on 3 domains — PM2 managed

# --- PREPARE ENVIRONMENT ---
apt update && apt upgrade -y
apt install -y git curl wget unzip python3 python3-pip build-essential \
               libssl-dev libffi-dev python3-dev nodejs npm nginx apache2-utils

# Install NodeJS LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Install PM2 globally
npm install pm2 -g

# --- CLONE OPENWEBUI ---
mkdir -p /var/www/openwebui-chat-smrt
mkdir -p /var/www/openwebui-chat-hack
mkdir -p /var/www/openwebui-chat-kjo

# SMRT
git clone https://github.com/open-webui/open-webui.git /var/www/openwebui-chat-smrt
cd /var/www/openwebui-chat-smrt
npm install

# HACK
git clone https://github.com/open-webui/open-webui.git /var/www/openwebui-chat-hack
cd /var/www/openwebui-chat-hack
npm install

# KJO
git clone https://github.com/open-webui/open-webui.git /var/www/openwebui-chat-kjo
cd /var/www/openwebui-chat-kjo
npm install

# --- SETUP PM2 ---
# SMRT
cd /var/www/openwebui-chat-smrt
pm2 start npm --name chat-smrt -- run dev

# HACK
cd /var/www/openwebui-chat-hack
pm2 start npm --name chat-hack -- run dev

# KJO
cd /var/www/openwebui-chat-kjo
pm2 start npm --name chat-kjo -- run dev

# --- SAVE PM2 FOR AUTO-RESTART ON BOOT ---
pm2 save
pm2 startup systemd
# Run the printed command to enable pm2 boot (you will see: `sudo env PATH=... pm2 startup systemd -u youruser`)

# --- PRINT SUMMARY ---
echo "✅ OpenWebUI Multi-Instance installed."
echo "Ports used:"
echo " chat-smrt → 3000"
echo " chat-hack → 3001"
echo " chat-kjo  → 3002"
echo ""
echo "👉 You MUST configure Apache reverse proxies for:"
echo "  chat.smrtpayments.com → http://localhost:3000"
echo "  chat.hackserv.cc      → http://localhost:3001"
echo "  chat.teamkjo.com      → http://localhost:3002"
echo ""
echo "👉 PM2 Management commands:"
echo " pm2 list"
echo " pm2 restart chat-smrt"
echo " pm2 restart chat-hack"
echo " pm2 restart chat-kjo"

echo "💚 Done — proceed to Apache vhost configs."

