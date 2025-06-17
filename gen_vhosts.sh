
#!/bin/bash

HTML_BASE="/var/www/html"
CONF_BASE="/etc/apache2/sites-available"
ENABLED_BASE="/etc/apache2/sites-enabled"
CERT_DOMAIN="smrtpayments.com"
CERT_PATH="/etc/letsencrypt/live/${CERT_DOMAIN}"
GLOBAL_INCLUDE="/var/www/assets/global_includes.conf"
SIG_FOOTER="<!-- Deployed with ❤️ by KOTE | Voice powered by ElevenLabs -->"

echo "[+] Scanning subdomains in $HTML_BASE..."

for SUBDIR in "$HTML_BASE"/*; do
    [ -d "$SUBDIR" ] || continue
    DOMAIN=$(basename "$SUBDIR")
    PUBROOT="$SUBDIR/public_html"
    mkdir -p "$PUBROOT"
    INDEX_FILE="$PUBROOT/index.html"
    CONF_FILE="$CONF_BASE/$DOMAIN.conf"

    echo "[*] Generating config for $DOMAIN → $CONF_FILE"

    # Generate default index.html with branding if not present
    if [[ ! -f "$INDEX_FILE" ]] || ! grep -q "KOTE" "$INDEX_FILE"; then
        echo "    [+] Creating default index.html with signature"
        cat > "$INDEX_FILE" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>$DOMAIN</title>
</head>
<body>
  <h1>Welcome to $DOMAIN</h1>
  <p>This site is served by SMRT WebServ.</p>
  <footer><em>$SIG_FOOTER</em></footer>
</body>
</html>
EOF
        chmod 644 "$INDEX_FILE"
    fi

    # Build base config
    cat > "$CONF_FILE" <<EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN

    DocumentRoot $PUBROOT

    <Directory $PUBROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    Include $GLOBAL_INCLUDE

    ErrorLog \${APACHE_LOG_DIR}/${DOMAIN}_error.log
    CustomLog \${APACHE_LOG_DIR}/${DOMAIN}_access.log combined

    <IfModule mod_rewrite.c>
        RewriteEngine On
        RewriteCond %{HTTPS} !=on
        RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
    </IfModule>
</VirtualHost>
EOF

    # Append SSL config block
    if [[ -f "$CERT_PATH/fullchain.pem" && -f "$CERT_PATH/privkey.pem" ]]; then
        cat >> "$CONF_FILE" <<EOF

<VirtualHost *:443>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN

    DocumentRoot $PUBROOT

    <Directory $PUBROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    Include $GLOBAL_INCLUDE

    SSLEngine on
    SSLCertificateFile $CERT_PATH/fullchain.pem
    SSLCertificateKeyFile $CERT_PATH/privkey.pem

    ErrorLog \${APACHE_LOG_DIR}/${DOMAIN}_ssl_error.log
    CustomLog \${APACHE_LOG_DIR}/${DOMAIN}_ssl_access.log combined

    <IfModule mod_rewrite.c>
        RewriteEngine On
        RewriteCond %{HTTPS} !=on
        RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
    </IfModule>
</VirtualHost>
EOF
        echo "    [+] SSL block added"
    else
        echo "    [!] SSL certs missing for $DOMAIN"
    fi

    # Enable the site
    ln -sf "$CONF_FILE" "$ENABLED_BASE/$DOMAIN.conf"
    echo "    [✓] Site enabled"
done

echo "[✓] Reloading Apache..."
systemctl reload apache2 && echo "[✓] Apache reloaded"
