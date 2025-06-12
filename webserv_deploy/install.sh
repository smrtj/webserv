#!/bin/bash
# WEBSERV install.sh - sets up full stack

# Update and install packages
apt update && apt install -y \
    apache2 \
    php \
    libapache2-mod-php \
    unzip \
    curl \
    certbot \
    python3-certbot-apache \
    vim \
    git \
    screen \
    fortune-mod \
    fonts-powerline \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    gcc \
    libapache2-mod-wsgi-py3

# Enable Apache modules
a2enmod rewrite userdir ssl proxy proxy_http proxy_fcgi headers
systemctl restart apache2

# Configure UserDir
sed -i 's|^#UserDir public_html|UserDir public_html|' /etc/apache2/mods-available/userdir.conf

# Create UserDir folders for jordan
mkdir -p /home/jordan/smrt_html /home/jordan/team_html /home/jordan/kjo_html /home/jordan/hack_html

# Create /var/www/assets
mkdir -p /var/www/assets/favicons /var/www/assets/elevenlabs

# Symlink MOTDs and ascii-art.txt
ln -sf /var/www/assets/motd_user.txt /etc/motd
ln -sf /var/www/assets/motd_root.txt /root/motd
ln -sf /var/www/assets/ascii-art.txt /etc/ascii-art.txt

# Initialize git repo if not exists
if [ ! -d "/var/www/.git" ]; then
    cd /var/www
    git init
    git add .
    git commit -m "Initial webserv deployment commit"
fi

echo "Install complete. Run deploy.sh next or manually deploy SSL."

