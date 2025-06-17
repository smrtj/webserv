#!/bin/bash

DEFAULT_INDEX="/var/www/default_index.html"
ASSETS_PATH="/assets"

echo "[*] Generating default index with embedded includes..."

cat > "$DEFAULT_INDEX" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Welcome to SMRTPayments</title>
  <script src="$ASSETS_PATH/elevenlabs.js" async type="text/javascript"></script>
  <link rel="stylesheet" type="text/css" href="$ASSETS_PATH/custom.css">
</head>
<body>
  <h1>Welcome to SMRTPayments</h1>
  <p>This domain is online and serving correctly.</p>
</body>
</html>
EOF

echo "[✓] Default index created at $DEFAULT_INDEX"

echo "[*] Scanning /var/www/html for subdomain folders..."

for DIR in /var/www/html/*/; do
  if [[ -d "$DIR" ]]; then
    INDEX_FILE="${DIR}index.html"
    if [[ -f "$INDEX_FILE" && "$1" != "--force" ]]; then
      echo "[!] Skipping existing: $INDEX_FILE"
    else
      cp "$DEFAULT_INDEX" "$INDEX_FILE"
      echo "[+] Applied default index to: $INDEX_FILE"
    fi
  fi
done

echo "[✓] All missing indexes patched."

