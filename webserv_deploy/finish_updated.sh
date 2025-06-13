#!/bin/bash

# webserv Project - finish.sh
# Purpose: Final setup of site-specific symlinks and polish after deploy.sh.
# Run this after deploy.sh.

set -e

echo "Starting finish.sh — final symlink setup..."

# Discover domains dynamically under /var/www/html
elevenlabs_domains=()
for dir in /var/www/html/*; do
    [ -d "$dir" ] || continue
    domain="$(basename "$dir")"
    case "$domain" in
        .*|"" ) continue ;;
    esac
    elevenlabs_domains+=("$domain")
done

echo "Creating symlinks for: ${elevenlabs_domains[*]}"

for domain in "${elevenlabs_domains[@]}"; do
    subdomain="${domain%%.*}"

    # elevenlabs.js
    js_source="/var/www/assets/elevenlabs/${subdomain}-elevenlabs.js"
    [ -f "$js_source" ] || js_source="/var/www/assets/elevenlabs/placeholder-elevenlabs.js"
    ln -sf "$js_source" "/var/www/html/$domain/public_html/elevenlabs.js"

    # favicon.ico
    fav_source="/var/www/assets/favicons/favicon-${domain}.ico"
    [ -f "$fav_source" ] || fav_source="/var/www/assets/favicons/default.ico"
    ln -sf "$fav_source" "/var/www/html/$domain/public_html/favicon.ico"

    # SMRT_logo.png
    ln -sf /var/www/assets/SMRT_logo.png "/var/www/html/$domain/public_html/SMRT_logo.png"
done


# Final echo
echo "Finish.sh complete — ElevenLabs.js, favicon.ico, and SMRT_logo.png symlinks created."
