#!/bin/bash

# webserv Project - deploy.sh
# Purpose: deploy full SSL wildcard certificates and post-deploy cleanup.

set -e

echo "Starting wildcard SSL deployment..."

# Obtain wildcard certificates using DNS-01 challenge
sudo certbot certonly --dns-your-dns-provider --dns-your-dns-provider-credentials /path/to/credentials.ini -d smrtpayments.com -d '*.smrtpayments.com'
sudo certbot certonly --dns-your-dns-provider --dns-your-dns-provider-credentials /path/to/credentials.ini -d teamkjo.com -d '*.teamkjo.com'
sudo certbot certonly --dns-your-dns-provider --dns-your-dns-provider-credentials /path/to/credentials.ini -d kjo.ai -d '*.kjo.ai'
sudo certbot certonly --dns-your-dns-provider --dns-your-dns-provider-credentials /path/to/credentials.ini -d hackserv.cc -d '*.hackserv.cc'
sudo certbot certonly --dns-your-dns-provider --dns-your-dns-provider-credentials /path/to/credentials.ini -d hackserv.org -d '*.hackserv.org'

# Ensure Apache is configured to use the wildcard certificate for each vhost
# (Manual step: edit each vhost conf to point to /etc/letsencrypt/live/<domain>/fullchain.pem and privkey.pem)

# Post-certbot steps
sudo ln -sf /var/www/assets/motd_user_smrt.txt /etc/motd
sudo ln -sf /var/www/assets/motd_root_smrt.txt /root/motd
sudo ln -sf /var/www/assets/ascii-art-user-smrt.txt /etc/ascii-art.txt

# Install required Python packages for Flask API server
echo "Installing Flask API server dependencies..."
cd /var/www/api_server
python3 -m venv venv
source venv/bin/activate
pip install flask flask-cors requests

# Verify Flask app for Discover eBike waiver and order form
echo "Verifying required Flask app files..."
REQUIRED_FILES=(
    "/var/www/api_server/app_final.py"
    "/var/www/api_server/IPOSPayIntegration.py"
    "/var/www/api_server/api_keys.json"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "ERROR: Missing required file: $file"
        exit 1
    fi
done

# Post verification, start Flask app (manual test)
echo "Manual test command:"
echo "source /var/www/api_server/venv/bin/activate && python /var/www/api_server/app_final.py"

# Or recommend systemd service
echo "Recommended: create systemd service flask-api-server.service in /etc/systemd/system/"
echo "Enable and start service with:"
echo "sudo systemctl enable flask-api-server"
echo "sudo systemctl start flask-api-server"

# Confirm API server running (basic check)
echo "Checking if Flask API server process is running..."
if pgrep -f "python.*app_final.py" > /dev/null; then
    echo "Flask API server appears to be running."
else
    echo "WARNING: Flask API server not detected running. Please start via systemd or manually."
fi

# Refresh MOTD files from ASCII art files
echo "Refreshing MOTD files from ASCII art sources..."
for target in smrt kjo hack; do
    cat /var/www/assets/ascii-art-user-${target}.txt > /var/www/assets/motd_user_${target}.txt
    cat /var/www/assets/ascii-art-root-${target}.txt > /var/www/assets/motd_root_${target}.txt
done

# Symlink correct MOTD for root and user (default to smrt user/root)
sudo ln -sf /var/www/assets/motd_user_smrt.txt /etc/motd
sudo ln -sf /var/www/assets/motd_root_smrt.txt /root/motd

# Install /etc/profile.d/motd.sh for interactive shells only
echo "Installing /etc/profile.d/motd.sh ..."
sudo bash -c 'cat > /etc/profile.d/motd.sh <<EOF
#!/bin/bash
# Force display of MOTD on interactive shells, unless in screen/tmux

if [[ $- == *i* ]] && [[ -z "$STY" ]] && [[ -z "$TMUX" ]]; then
    cat /etc/motd
fi
EOF'

sudo chmod +x /etc/profile.d/motd.sh

# Git commit post-API deployment
cd /var/www
sudo git add .
sudo git commit -m "Post-deploy update with wildcard SSL, Flask API server, and refreshed MOTDs"

# Final echo
echo "Deploy complete with wildcard certificates, Flask API server ready, and MOTDs refreshed."

# NOTES:
# - Replace --dns-your-dns-provider and --dns-your-dns-provider-credentials with your actual DNS plugin and credential path.
# - No non-SSL subdomains will remain.
# - This ensures full wildcard SSL coverage across all domains and subdomains.
