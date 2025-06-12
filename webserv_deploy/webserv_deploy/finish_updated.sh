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
for domain in "${!elevenlabs_map[@]}"; do
    echo "Processing $domain → ${elevenlabs_map[$domain]}"
    ln -sf /var/www/assets/elevenlabs/${elevenlabs_map[$domain]} /var/www/html/$domain/public_html/elevenlabs.js
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
    ln -sf /var/www/assets/favicons/${favicons_map[$domain]} /var/www/html/$domain/public_html/favicon.ico
done


# SMRT_logo.png symlinks

# SMRT_logo.png domain → include mapping (only domains that want /SMRT_logo.png exposed)
declare -A smrt_logo_map

# Example domains that expose SMRT_logo.png
smrt_logo_map["smrtpayments.com"]="yes"
smrt_logo_map["showcase.smrtpayments.com"]="yes"
smrt_logo_map["teamkjo.com"]="yes"
smrt_logo_map["kjo.ai"]="yes"


# Create SMRT_logo.png symlinks
echo "Creating SMRT_logo.png symlinks..."
for domain in "${!smrt_logo_map[@]}"; do
    if [[ "${smrt_logo_map[$domain]}" == "yes" ]]; then
        echo "Processing $domain → SMRT_logo.png"
        ln -sf /var/www/assets/SMRT_logo.png /var/www/html/$domain/public_html/SMRT_logo.png
    fi
done


# Final echo
echo "Finish.sh complete — ElevenLabs.js, favicon.ico, and SMRT_logo.png symlinks created."
