#!/bin/bash

# This script will walk all subdomains and insert the loader into every footer.html and index.html

BASE_DIR="/var/www"

LOADER_JS='<script src="/assets/loader.js"></script>'

# Find all index.html and footer.html under /var/www (recursive)
find "$BASE_DIR" -type f \( -name "index.html" -o -name "footer.html" \) | while read -r file; do
  if grep -q "$LOADER_JS" "$file"; then
    echo "[OK] Loader already present in $file"
  else
    echo "[PATCH] Inserting loader into $file"
    # Insert before closing </body> tag, or at end if not found
    if grep -q "</body>" "$file"; then
      sed -i "s|</body>|$LOADER_JS\n</body>|" "$file"
    else
      echo "$LOADER_JS" >> "$file"
    fi
  fi
done

echo "✅ Loader inserted in all index.html and footer.html"
