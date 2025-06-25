#!/bin/bash

cd /var/www/assets || exit 1

# Master list of positions
positions=(
  "elevenlabs-widget"
  "cote-signature"
  "top-left"
  "top-right"
  "bottom-left"
  "bottom-center"
)

# Create base SMRT files (if not exist)
for pos in "${positions[@]}"; do
  touch "smrt-${pos}.html"
done

# Create symlinks for KJO
for pos in "${positions[@]}"; do
  ln -sf "smrt-${pos}.html" "kjo-${pos}.html"
done

# Create symlinks for HackServe
for pos in "${positions[@]}"; do
  ln -sf "smrt-${pos}.html" "hack-${pos}.html"
done

echo "✅ Assets prepared. All KJO and HackServe files symlinked to SMRT for now."
