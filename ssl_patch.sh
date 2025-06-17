#!/bin/bash
# PATCH REDIRECT LOOPS ON ALL SMRTPAYMENTS VHOSTS

# Step 1: Backup all VHost confs
mkdir -p /etc/apache2/sites-backup/
cp /etc/apache2/sites-enabled/*.conf /etc/apache2/sites-backup/

# Step 2: Strip force-redirect loops
find /etc/apache2/sites-enabled/ -name "*.conf" | while read file; do
  sed -i '/RewriteCond %{HTTPS}/d' "$file"
  sed -i '/RewriteRule \^ https:/d' "$file"
  sed -i '/Redirect permanent \//d' "$file"
done

# Step 3: Normalize SSL blocks (no redirect loops)
for conf in /etc/apache2/sites-enabled/*.conf; do
  if ! grep -q "ServerName" "$conf"; then continue; fi

  sed -i '/<\/VirtualHost>/i \
  <IfModule mod_rewrite.c>\n\
  RewriteEngine On\n\
  RewriteCond %{HTTPS} !=on\n\
  RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]\n\
  </IfModule>' "$conf"
done

# Step 4: Disable default redirect fallback if it exists
a2dissite 000-default.conf
a2dissite 000-default-ssl.conf

# Step 5: Restart Apache
systemctl restart apache2

echo "✅ Patch applied. Redirect loop should now be resolved."

