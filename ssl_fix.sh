#!/bin/bash

CONF_DIR="/etc/apache2/sites-available"
BACKUP_DIR="/etc/apache2/sites-available/backup_https_fix_$(date +%s)"
mkdir -p "$BACKUP_DIR"

echo "🔧 Scanning all Apache site configs for HTTPS redirect correction..."

for conf in "$CONF_DIR"/*.conf; do
  echo "📄 Processing: $conf"
  cp "$conf" "$BACKUP_DIR/$(basename "$conf")"

  # Remove rewrite rule from HTTPS block only
  awk '
    BEGIN { inside443=0 }
    /<VirtualHost[^\>]*:443>/ { inside443=1 }
    /<\/VirtualHost>/ { inside443=0 }
    {
      if (inside443) {
        if ($0 ~ /RewriteCond %{HTTPS}/) next
        if ($0 ~ /RewriteRule \^ https:\/\/%{HTTP_HOST}%{REQUEST_URI}/) next
      }
      print $0
    }
  ' "$conf" > "$conf.tmp" && mv "$conf.tmp" "$conf"
done

echo "🔁 Restarting Apache to apply changes..."
if systemctl restart apache2; then
  echo "✅ Apache restarted successfully. HTTPS rewrite rules now corrected."
else
  echo "❌ Apache restart failed. Check 'journalctl -xeu apache2.service' for diagnostics."
  exit 1
fi

