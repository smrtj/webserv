#!/bin/bash
# PATCH: Smart PM2 Management for OpenWebUI
# Author: KOTE x Jordan, 2025

echo "🔧 Patching PM2 OpenWebUI configuration..."

# Step 1: Install PM2 if needed
if ! command -v pm2 &> /dev/null; then
  npm install -g pm2
fi

# Step 2: Kill old PM2 apps
pm2 delete all || true
pm2 save --force

# Step 3: Set environment vars (tune for low mem)
export NODE_OPTIONS="--max-old-space-size=256"

# Step 4: Launch OpenWebUI (adjust path if cloned elsewhere)
cd /var/www/openwebui-chat-smrt/ || exit 1

# Recommended branch: latest stable
git checkout main && git pull

# Step 5: Start with PM2 (single instance, friendly name)
pm2 start 'npm run dev' --name openwebui --time

# Step 6: Enable startup hook
pm2 startup systemd -u root --hp /root
pm2 save

echo "✅ OpenWebUI is now running under PM2 with optimized config."

