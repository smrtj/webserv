#!/bin/bash
# SMRT WebServer install script (placeholder)
# Sets up Apache2, Python virtual environment, and installs dependencies.
# Adjust paths as needed.

set -e

# Install packages
apt-get update
apt-get install -y apache2 python3 python3-venv git

# Create directory structure
mkdir -p /var/www/{api_server,assets,html}
for domain in smrtpayments.com teamkjo.com kjo.ai hackserv.cc hackserv.org; do
    mkdir -p "/var/www/html/$domain"
    ln -s /var/www/assets/elevenlabs/$domain-elevenlabs.js "/var/www/html/$domain/elevenlabs.js" || true
    ln -s /var/www/assets/favicons/favicon-$domain.ico "/var/www/html/$domain/favicon.ico" || true
done

# Setup Python virtual environment for API server
python3 -m venv /var/www/api_server/venv
source /var/www/api_server/venv/bin/activate
pip install flask

deactivate

echo "Install script completed. Configure certificates and vhosts separately."
