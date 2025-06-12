# webserv Deployment — README

## Purpose

This package deploys the complete multi-domain webserv stack:

- Apache2 + UserDir
- Wildcard SSL certificates for all domains
- Central asset management
- Discover eBike waiver and order form API
- Full IPOSPay integration
- Domain-specific Bash and Vim setup
- MOTDs, ASCII art, logos, favicons
- Git versioning

## Installation Steps

1️⃣ Run install.sh

- Installs all required packages
- Configures UserDir
- Enables required Apache modules
- Deploys assets and symlinks
- Installs Bash and Vim configs
- Initializes Git repo

2️⃣ Run deploy.sh

- Obtains wildcard SSL certificates via DNS-01 challenge
- Recreates MOTD and ASCII symlinks
- Installs Flask and IPOSPay API server
- Optionally starts API server as systemd service
- Commits post-deploy state to Git

3️⃣ Verify services

- All domains and subdomains should load with valid SSL
- API server /charge endpoint should respond correctly
- MOTDs and prompts should display per domain spec

## Notes

- Symlinks used for MOTDs and ASCII art
- Domain public_html uses symlinks for elevenlabs.js and favicons
- API server handles both card and Google Pay token flows
- .vimrc and .bashrc are installed per domain prompt spec

## Maintenance

- Git is used for tracking /var/www state
- To update assets or MOTDs → update /var/www/assets and commit
- To update API server → update /var/www/api_server and commit

## Local API Testing

The Flask API can be started locally for development:

```bash
cd api_server
python3 -m venv venv  # create virtual environment if needed
source venv/bin/activate
pip install flask flask-cors requests
python app.py
```

The server will listen on `http://localhost:5000/charge`. Use this to test the
order form before deploying.

---

