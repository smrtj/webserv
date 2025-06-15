#!/bin/bash
# deploy.sh - Configure Apache2 virtual hosts and API service
set -e

BASE=/var/www
APACHE_SITES=/etc/apache2/sites-available

# Enable necessary modules
a2enmod rewrite

# Create VirtualHost configs
for domain in smrtpayments.com teamkjo.com kjo.ai hackserv.cc hackserv.org; do
    cat > "$APACHE_SITES/$domain.conf" <<CONF
<VirtualHost *:80>
    ServerName $domain
    DocumentRoot $BASE/html/$domain
    <Directory $BASE/html/$domain>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
CONF
    a2ensite "$domain.conf"
done

systemctl reload apache2

# Setup Python virtual environment and install Flask
if [ ! -d "$BASE/api_server/venv" ]; then
    python3 -m venv "$BASE/api_server/venv"
    "$BASE/api_server/venv/bin/pip" install Flask
fi

# Install systemd service
cat > /etc/systemd/system/api_server.service <<SERVICE
[Unit]
Description=SMRT API Server
After=network.target

[Service]
Type=simple
WorkingDirectory=$BASE/api_server
Environment=PYTHONUNBUFFERED=1
ExecStart=$BASE/api_server/venv/bin/python $BASE/api_server/app.py
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable api_server.service
systemctl restart api_server.service

cat <<'MSG'
Deployment complete. API server running under systemd.
MSG
