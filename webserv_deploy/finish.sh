#!/bin/bash

# webserv Project - finish.sh
# Purpose: Final setup of site-specific symlinks and polish after deploy.sh.
# Run this after deploy.sh.

set -e

echo "Starting finish.sh — final symlink setup..."

# ElevenLabs.js symlinks

# ElevenLabs.js domain → js mapping
declare -A elevenlabs_map

# SMRT domains
elevenlabs_map["smrtpayments.com"]="smrt-elevenlabs.js"
elevenlabs_map["showcase.smrtpayments.com"]="smrt-elevenlabs.js"
elevenlabs_map["crm.smrtpayments.com"]="smrt-elevenlabs.js"

# KJO domains (teamkjo.com and kjo.ai)
elevenlabs_map["teamkjo.com"]="kjo-elevenlabs.js"
elevenlabs_map["kjo.ai"]="kjo-elevenlabs.js"

# Hack domains
elevenlabs_map["hackserv.cc"]="hack-elevenlabs.js"
elevenlabs_map["hackserv.org"]="hack-elevenlabs.js"


# Create ElevenLabs.js symlinks
echo "Creating ElevenLabs.js symlinks..."
for domain_path in /var/www/html/*/; do
    domain=$(basename "$domain_path")
    for pattern in "${!elevenlabs_map[@]}"; do
        if [[ "$domain" == *"$pattern" ]]; then
            target="/var/www/assets/elevenlabs/${elevenlabs_map[$pattern]}"
            ln -sf "$target" "/var/www/assets/elevenlabs/${domain}-elevenlabs.js"
            ln -sf "/var/www/assets/elevenlabs/${domain}-elevenlabs.js" "/var/www/html/$domain/elevenlabs.js"
            break
        fi
    done
done


# Favicons symlinks

# Favicons domain → favicon mapping
declare -A favicons_map

# SMRT domains
favicons_map["smrtpayments.com"]="favicon-smrt.ico"
favicons_map["showcase.smrtpayments.com"]="favicon-smrt.ico"
favicons_map["crm.smrtpayments.com"]="favicon-smrt.ico"

# KJO domains (teamkjo.com and kjo.ai)
favicons_map["teamkjo.com"]="favicon-kjo.ico"
favicons_map["kjo.ai"]="favicon-kjo.ico"

# Hack domains
favicons_map["hackserv.cc"]="favicon-hack.ico"
favicons_map["hackserv.org"]="favicon-hack.ico"


# Create favicon.ico symlinks
echo "Creating favicon.ico symlinks..."
for domain in "${!favicons_map[@]}"; do
    echo "Processing $domain → ${favicons_map[$domain]}"
    ln -sf /var/www/assets/favicons/${favicons_map[$domain]} /var/www/html/$domain/favicon.ico
done


# Final echo
echo "Finish.sh complete — ElevenLabs.js and favicon.ico symlinks created."
