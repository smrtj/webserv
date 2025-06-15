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
├── api_server.service
├── venv/ (Python virtual environment for Flask app)

### Environment Variables

The API server reads payment credentials from environment variables when
available:

- `TPN` – terminal provider number
- `MID` – merchant ID
- `JWT_KEY` – JSON Web Token secret
- `FLASK_HOST` – listening address (default `0.0.0.0`)
- `FLASK_PORT` – listening port (default `5000`)

If these are not present the server attempts to load `api_keys.json` in the
same directory. Keep this file outside of version control or restrict its
permissions to protect secret values.

## Deployment

Run `./install.sh` as root to install required packages and initialise the
`/var/www` directory tree. After reviewing and adjusting the generated files,
execute `./deploy.sh` to create Apache VirtualHosts and start the API server via
systemd. Both scripts are idempotent and can be re-run safely.

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

## Notes

- This manifest documents the complete intended structure of the webserv deployment bundle.
- All future rebuilds must match this structure unless versioned changes are documented.
- The bundle is designed to support automated deploys and consistent environment across all domains.

---

End of BUILD_MANIFEST.md.
