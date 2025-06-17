#!/bin/bash

set -e

# Paths
SITES_AVAILABLE="/etc/apache2/sites-available"
SITES_ENABLED="/etc/apache2/sites-enabled"
CERT_PATH="/etc/letsencrypt/live/smrtpayments.com"
DOC_ROOT_BASE="/var/www/html"

# List all domain confs
cd $SITES_AVAILABLE

for conf in *.conf; do
    domain=$(basename "$conf" .conf)

    echo "[*] Fixing configuration for $domain"

    DOC_ROOT="$DOC_ROOT_BASE/$domain/public_html"
    mkdir -p "$DOC_ROOT"

    cat > "$SITES_AVAILABLE/$conf" <<EOF
<VirtualHost *:80>
    ServerName $domain
    ServerAlias www.$domain
    Redirect permanent / https://$domain/
</VirtualHost>

<VirtualHost *:443>
    ServerName $domain
    ServerAlias www.$domain

    DocumentRoot $DOC_ROOT

    <Directory $DOC_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    Include /var/www/assets/global_includes.conf

    SSLEngine on
    SSLCertificateFile $CERT_PATH/fullchain.pem
    SSLCertificateKeyFile $CERT_PATH/privkey.pem

    ErrorLog \${APACHE_LOG_DIR}/${domain}_ssl_error.log
    CustomLog \${APACHE_LOG_DIR}/${domain}_ssl_access.log combined
</VirtualHost>
EOF

    echo "[+] Ensuring $domain is enabled"
    a2ensite "$conf" || true
done

echo "[*] Reloading Apache..."
systemctl reload apache2
echo "[✓] All virtual hosts updated and Apache reloaded."
