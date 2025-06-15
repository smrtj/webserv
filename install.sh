#!/bin/bash
# install.sh - Setup Apache2 and base directory structure

set -e

# Install packages
if ! command -v apache2 >/dev/null 2>&1; then
    apt-get update && apt-get install -y apache2 python3 python3-venv
fi

# Create directory structure
BASE=/var/www
mkdir -p "$BASE"/html/{smrtpayments.com,teamkjo.com,kjo.ai,hackserv.cc,hackserv.org}
mkdir -p "$BASE"/assets/favicons
mkdir -p "$BASE"/api_server

# Copy default index pages if missing
for d in smrtpayments.com teamkjo.com kjo.ai hackserv.cc hackserv.org; do
    if [ ! -f "$BASE/html/$d/index.html" ]; then
        echo "<html><body><h1>Welcome to $d</h1></body></html>" > "$BASE/html/$d/index.html"
    fi
done

# Initialize git repo if not exists
if [ ! -d "$BASE/.git" ]; then
    git init "$BASE"
    (cd "$BASE" && git add . && git commit -m 'Initial webserv structure')
fi

cat <<'MSG'
Installation complete. Run deploy.sh to configure virtual hosts and services.
MSG
