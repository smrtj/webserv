# webserv
SMRT WebServer
# webserv Deployment Bundle — Build Manifest

## Purpose

This bundle deploys the complete multi-domain webserv stack:

- Full Apache2 + UserDir setup
- Initial VHOST scaffolds for smrtpayments.com, teamkjo.com, kjo.ai, hackserv.cc, hackserv.org
- Central assets folder (/var/www/assets)
- SMRT signature assets, MOTDs, favicons, ASCII art
- Initial Discover eBike waiver API integration (Flask-based)
- Full IPOSPay integration for Discover eBike waiver and order form
- Core deployment scripts (install.sh, deploy.sh)
- API server and integration files
- Standard Bash and Vim environment per domain
- Git-based versioning

---

## Structure

/var/www/
├── api_server/                 # Flask API server for waiver and order form
├── assets/                     # Global assets shared across domains
├── html/                       # VirtualHost public_html trees per domain
│   ├── smrtpayments.com/
│   ├── teamkjo.com/
│   ├── kjo.ai/
│   ├── hackserv.cc/
│   ├── hackserv.org/

---

## Assets

/var/www/assets/
├── global_includes.conf
├── ascii-art.txt
├── motd_user.txt
├── motd_root.txt
├── .vimrc
├── .bashrc
├── favicons/
│   ├── favicon-smrt.ico
│   ├── favicon-kjo.ico
│   ├── favicon-hack.ico
├── elevenlabs/
│   ├── smrt-elevenlabs.js
│   ├── kjo-elevenlabs.js
│   ├── hack-elevenlabs.js
├── SMRT_logo.png
├── SMRT_logo variants (.png sizes)

---

## API Server

/var/www/api_server/
├── app.py
├── IPOSPayIntegration.py
├── api_keys.json
├── venv/ (Python virtual environment for Flask app)

---

## Bash and Vim

- Bash enforced for all users.
- Domain-specific .bashrc for root, jordan, kote.
- .vimrc deployed to root, jordan, kote, /etc/skel/.

---

## Symlinks Created

- /etc/motd → /var/www/assets/motd_user.txt
- /root/motd → /var/www/assets/motd_root.txt
- /etc/ascii-art.txt → /var/www/assets/ascii-art.txt
- Domain public_html → symlinks to:
  - elevenlabs.js (correct variant)
  - favicon.ico (correct variant)

---

## Certificates

- Wildcard SSL certificates for all domains and subdomains.
- Obtained using DNS-01 challenge.
- No HTTP-only subdomains remain.

---

## Git

- Git initialized in /var/www.
- Initial commit made after install.sh.
- Post-deploy commit made after deploy.sh and Flask API server install.

---
## Deployment

### Requirements
- Ubuntu 20.04 or newer with root or sudo access
- Python 3.9 or later
- DNS provider access for creating TXT records (DNS-01 challenge)

### Running `install.sh`
1. Place this repository on the target server.
2. Execute `sudo bash install.sh` from the repository root.
3. The script installs Apache2 and sets up the directory structure and Python environment for the API server.

### Obtaining wildcard certificates
- Use Certbot or another ACME client that supports the DNS-01 challenge.
- Issue a wildcard certificate for each domain, e.g. `certbot certonly --dns-route53 -d "*.smrtpayments.com"`.
- Install the resulting certificates to your Apache virtual host configuration under `/etc/letsencrypt` or another preferred location.


## Notes

- This manifest documents the complete intended structure of the webserv deployment bundle.
- All future rebuilds must match this structure unless versioned changes are documented.
- The bundle is designed to support automated deploys and consistent environment across all domains.

---

End of BUILD_MANIFEST.md.
