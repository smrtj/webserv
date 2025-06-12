#!/bin/bash

# WebServe Project - install.sh
# Target OS: Ubuntu 22.04 or 24.04 LTS

set -e

echo "Starting WebServe installation..."

# Ensure Bash is the default shell for all users
sudo chsh -s /bin/bash root
sudo chsh -s /bin/bash jordan
sudo chsh -s /bin/bash kote

# Update package list
sudo apt-get update

# Install required packages
sudo apt-get install -y \
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

# Enable required Apache modules
sudo a2enmod rewrite
sudo a2enmod userdir
sudo a2enmod ssl
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_fcgi
sudo a2enmod headers

# Restart Apache
sudo systemctl restart apache2

# Configure UserDir
sudo bash -c 'cat > /etc/apache2/mods-available/userdir.conf <<EOF
<IfModule mod_userdir.c>
    UserDir enabled jordan smrt_html team_html kjo_html hack_html
    UserDir public_html
</IfModule>
EOF'

# Create required home directories
sudo mkdir -p /home/jordan/smrt_html
sudo mkdir -p /home/jordan/team_html
sudo mkdir -p /home/jordan/kjo_html
sudo mkdir -p /home/jordan/hack_html

sudo mkdir -p /home/kote/smrt_html
sudo mkdir -p /home/kote/team_html
sudo mkdir -p /home/kote/kjo_html
sudo mkdir -p /home/kote/hack_html

# Create /var/www/assets
sudo mkdir -p /var/www/assets/favicons
sudo mkdir -p /var/www/assets/elevenlabs
sudo chown -R www-data:www-data /var/www/assets
sudo chmod -R 755 /var/www/assets

# Symlinks for MOTD and ascii-art
sudo ln -sf /var/www/assets/motd_user.txt /etc/motd
sudo ln -sf /var/www/assets/motd_root.txt /root/motd
sudo ln -sf /var/www/assets/ascii-art.txt /etc/ascii-art.txt

# For each domain public_html — create dir and symlinks
for domain in smrtpayments.com www.smrtpayments.com showcase.smrtpayments.com crm.smrtpayments.com anchor.smrtpayments.com links.smrtpayments.com status.smrtpayments.com sandbox.smrtpayments.com api.smrtpayments.com order.smrtpayments.com shop.smrtpayments.com pay.smrtpayments.com portal.smrtpayments.com partner.smrtpayments.com bifrost.smrtpayments.com webui.smrtpayments.com assets.smrtpayments.com cto.smrtpayments.com kote.smrtpayments.com support.smrtpayments.com marketing.smrtpayments.com docs.smrtpayments.com billing.smrtpayments.com legal.smrtpayments.com kristen.smrtpayments.com jordan.smrtpayments.com olivia.smrtpayments.com teamkjo.com links.teamkjo.com status.teamkjo.com sandbox.teamkjo.com api.teamkjo.com news.teamkjo.com blog.teamkjo.com shop.teamkjo.com pay.teamkjo.com portal.teamkjo.com partner.teamkjo.com bifrost.teamkjo.com webui.teamkjo.com assets.teamkjo.com cto.teamkjo.com kote.teamkjo.com support.teamkjo.com marketing.teamkjo.com docs.teamkjo.com kristen.teamkjo.com jordan.teamkjo.com olivia.teamkjo.com kjo.ai links.kjo.ai status.kjo.ai sandbox.kjo.ai api.kjo.ai news.kjo.ai blog.kjo.ai bifrost.kjo.ai webui.kjo.ai assets.kjo.ai cto.kjo.ai kote.kjo.ai support.kjo.ai marketing.kjo.ai docs.kjo.ai kristen.kjo.ai jordan.kjo.ai olivia.kjo.ai hackserv.cc links.hackserv.cc status.hackserv.cc sandbox.hackserv.cc api.hackserv.cc kvothe.hackserv.cc bifrost.hackserv.cc webui.hackserv.cc assets.hackserv.cc kristen.hackserv.cc jordan.hackserv.cc olivia.hackserv.cc hackserv.org links.hackserv.org status.hackserv.org sandbox.hackserv.org api.hackserv.org kvothe.hackserv.org bifrost.hackserv.org webui.hackserv.org assets.hackserv.org kristen.hackserv.org jordan.hackserv.org olivia.hackserv.org; do
    sudo mkdir -p /var/www/html/$domain
    sudo ln -sf /var/www/assets/favicons/favicon-$domain.ico /var/www/html/$domain/favicon.ico || true
    sudo ln -sf /var/www/assets/elevenlabs/$(echo $domain | cut -d'.' -f1)-elevenlabs.js /var/www/html/$domain/elevenlabs.js || true
    sudo cp /var/www/assets/index.html /var/www/html/$domain/index.html || true
done

# Enable configured sites
sudo a2ensite smrtpayments.com.conf
sudo a2ensite www.smrtpayments.com.conf
sudo a2ensite showcase.smrtpayments.com.conf
sudo a2ensite crm.smrtpayments.com.conf
sudo a2ensite anchor.smrtpayments.com.conf
sudo a2ensite links.smrtpayments.com.conf
sudo a2ensite status.smrtpayments.com.conf
sudo a2ensite sandbox.smrtpayments.com.conf
sudo a2ensite api.smrtpayments.com.conf
sudo a2ensite order.smrtpayments.com.conf
sudo a2ensite shop.smrtpayments.com.conf
sudo a2ensite pay.smrtpayments.com.conf
sudo a2ensite portal.smrtpayments.com.conf
sudo a2ensite partner.smrtpayments.com.conf
sudo a2ensite bifrost.smrtpayments.com.conf
sudo a2ensite webui.smrtpayments.com.conf
sudo a2ensite assets.smrtpayments.com.conf
sudo a2ensite cto.smrtpayments.com.conf
sudo a2ensite kote.smrtpayments.com.conf
sudo a2ensite support.smrtpayments.com.conf
sudo a2ensite marketing.smrtpayments.com.conf
sudo a2ensite docs.smrtpayments.com.conf
sudo a2ensite billing.smrtpayments.com.conf
sudo a2ensite legal.smrtpayments.com.conf
sudo a2ensite kristen.smrtpayments.com.conf
sudo a2ensite jordan.smrtpayments.com.conf
sudo a2ensite olivia.smrtpayments.com.conf
sudo a2ensite teamkjo.com.conf
sudo a2ensite links.teamkjo.com.conf
sudo a2ensite status.teamkjo.com.conf
sudo a2ensite sandbox.teamkjo.com.conf
sudo a2ensite api.teamkjo.com.conf
sudo a2ensite news.teamkjo.com.conf
sudo a2ensite blog.teamkjo.com.conf
sudo a2ensite shop.teamkjo.com.conf
sudo a2ensite pay.teamkjo.com.conf
sudo a2ensite portal.teamkjo.com.conf
sudo a2ensite partner.teamkjo.com.conf
sudo a2ensite bifrost.teamkjo.com.conf
sudo a2ensite webui.teamkjo.com.conf
sudo a2ensite assets.teamkjo.com.conf
sudo a2ensite cto.teamkjo.com.conf
sudo a2ensite kote.teamkjo.com.conf
sudo a2ensite support.teamkjo.com.conf
sudo a2ensite marketing.teamkjo.com.conf
sudo a2ensite docs.teamkjo.com.conf
sudo a2ensite kristen.teamkjo.com.conf
sudo a2ensite jordan.teamkjo.com.conf
sudo a2ensite olivia.teamkjo.com.conf
sudo a2ensite kjo.ai.conf
sudo a2ensite links.kjo.ai.conf
sudo a2ensite status.kjo.ai.conf
sudo a2ensite sandbox.kjo.ai.conf
sudo a2ensite api.kjo.ai.conf
sudo a2ensite news.kjo.ai.conf
sudo a2ensite blog.kjo.ai.conf
sudo a2ensite bifrost.kjo.ai.conf
sudo a2ensite webui.kjo.ai.conf
sudo a2ensite assets.kjo.ai.conf
sudo a2ensite cto.kjo.ai.conf
sudo a2ensite kote.kjo.ai.conf
sudo a2ensite support.kjo.ai.conf
sudo a2ensite marketing.kjo.ai.conf
sudo a2ensite docs.kjo.ai.conf
sudo a2ensite kristen.kjo.ai.conf
sudo a2ensite jordan.kjo.ai.conf
sudo a2ensite olivia.kjo.ai.conf
sudo a2ensite hackserv.cc.conf
sudo a2ensite links.hackserv.cc.conf
sudo a2ensite status.hackserv.cc.conf
sudo a2ensite sandbox.hackserv.cc.conf
sudo a2ensite api.hackserv.cc.conf
sudo a2ensite kvothe.hackserv.cc.conf
sudo a2ensite bifrost.hackserv.cc.conf
sudo a2ensite webui.hackserv.cc.conf
sudo a2ensite assets.hackserv.cc.conf
sudo a2ensite kristen.hackserv.cc.conf
sudo a2ensite jordan.hackserv.cc.conf
sudo a2ensite olivia.hackserv.cc.conf
sudo a2ensite hackserv.org.conf
sudo a2ensite links.hackserv.org.conf
sudo a2ensite status.hackserv.org.conf
sudo a2ensite sandbox.hackserv.org.conf
sudo a2ensite api.hackserv.org.conf
sudo a2ensite kvothe.hackserv.org.conf
sudo a2ensite bifrost.hackserv.org.conf
sudo a2ensite webui.hackserv.org.conf
sudo a2ensite assets.hackserv.org.conf
sudo a2ensite kristen.hackserv.org.conf
sudo a2ensite jordan.hackserv.org.conf
sudo a2ensite olivia.hackserv.org.conf

# Reload Apache
sudo systemctl reload apache2

# Copy MOTDs again for safety
sudo cp /var/www/assets/motd_user.txt /etc/motd
sudo cp /var/www/assets/motd_root.txt /root/motd

# Install .vimrc
sudo cp /var/www/assets/.vimrc /root/.vimrc
sudo cp /var/www/assets/.vimrc /home/jordan/.vimrc
sudo cp /var/www/assets/.vimrc /home/kote/.vimrc
sudo cp /var/www/assets/.vimrc /etc/skel/.vimrc

# Install .bashrc
sudo cp /var/www/assets/.bashrc /root/.bashrc
sudo cp /var/www/assets/.bashrc /home/jordan/.bashrc
sudo cp /var/www/assets/.bashrc /home/kote/.bashrc
sudo cp /var/www/assets/.bashrc /etc/skel/.bashrc

# Initialize git repo in /var/www
cd /var/www
sudo git init
sudo git add .
sudo git commit -m "Initial webserv deployment commit"

echo "Install complete. Run deploy.sh next or manually deploy SSL."
