#!/bin/bash
# WEBSERV deploy.sh - deploys SSL, API server, post-setup

# Obtain wildcard certs (replace DNS plugin/credentials path appropriately!)
# Account 1
certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare_1.ini -d teamkjo.com -d *.teamkjo.com
certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare_1.ini -d kjo.ai -d *.kjo.ai
certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare_1.ini -d smrtpayments.com -d *.smrtpayments.com
# Account 2
certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare_2.ini -d hackserv.cc -d *.hackserv.cc
certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare_2.ini -d hackserv.org -d *.hackserv.org



# Symlink MOTDs and ascii-art.txt again (safe)
ln -sf /var/www/assets/motd_user.txt /etc/motd
ln -sf /var/www/assets/motd_root.txt /root/motd
ln -sf /var/www/assets/ascii-art.txt /etc/ascii-art.txt

# Setup Flask API server
cd /var/www/api_server
python3 -m venv venv
source venv/bin/activate
pip install flask flask-cors requests

# Manual test (optional):
# source /var/www/api_server/venv/bin/activate
# python /var/www/api_server/app_final.py

# Setup systemd service
cp /var/www/systemd/flask-api-server.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable flask-api-server
systemctl start flask-api-server

# Git commit
cd /var/www
git add .
git commit -m "Post-deploy update with wildcard SSL and Flask API server installed"

echo "Deploy complete with wildcard certificates and Flask API server ready."

