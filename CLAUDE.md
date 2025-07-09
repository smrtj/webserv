# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a multi-domain web server infrastructure that hosts multiple websites and applications across different domains (smrtpayments.com, teamkjo.com, kjo.ai, hackserv.cc, hackserv.org). The repository contains:

- **Apache2 + UserDir configuration** for serving multiple domains
- **Open WebUI instances** for AI chat interfaces
- **Flask API server** for payment processing
- **Static assets management** with shared components
- **Deployment automation** with shell scripts

## Key Components

### 1. Multi-Domain Structure
- `html/[domain]/public_html/` - Individual domain content
- `assets/` - Shared assets (CSS, JS, images, favicons)
- `assets/elevenlabs/` - Domain-specific ElevenLabs.js integration files
- `global_includes.conf` - Apache configuration for shared includes

### 2. Open WebUI Applications
- `openwebui-chat-kjo/` - Svelte/TypeScript chat interface for KJO domains
- `openwebui-chat-smrt/` - Svelte/TypeScript chat interface for SMRT domains
- Both use Docker containers with Python backends

### 3. Flask API Server
- `api_server/` - Payment processing API with IPOSPay integration
- `api_server/app.py` - Main Flask application
- `api_server/IPOSPayIntegration.py` - Payment gateway integration
- `api_server/bin_utils.py` - BIN lookup utilities

## Common Development Commands

### Open WebUI Development
```bash
# Navigate to specific UI directory
cd openwebui-chat-kjo/  # or openwebui-chat-smrt/

# Install dependencies
npm install

# Development server
npm run dev

# Build for production
npm run build

# Linting and formatting
npm run lint
npm run format
npm run format:backend

# Testing
npm run test:frontend
npm run cy:open  # Cypress tests
```

### Flask API Development
```bash
cd api_server/

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install flask flask-cors requests

# Run development server
python app.py  # Listens on http://localhost:5000
```

### Docker Operations
```bash
# In openwebui-chat-* directories
make install        # Start with docker-compose
make start         # Start containers
make stop          # Stop containers
make update        # Update and rebuild
make remove        # Remove containers
```

### Infrastructure Management
```bash
# Asset management
cd assets/
./init-assets.sh      # Initialize asset symlinks
./insert-loader.sh    # Patch pages with loader

# SSL and deployment
./ssl_fix.sh          # Fix SSL issues
./ensure_indexes.sh   # Create missing index files
./gen_vhosts.sh       # Generate virtual host configs
```

## Testing and Quality Assurance

### Python Code Validation
```bash
# Compile check all Python files
python3 -m py_compile $(git ls-files '*.py')
```

### Shell Script Validation
```bash
# Lint all shell scripts
shellcheck $(git ls-files '*.sh')
```

### Frontend Testing
```bash
# In openwebui-chat-* directories
npm run check         # TypeScript/Svelte checks
npm run lint         # ESLint
npm run test:frontend # Vitest tests
```

## Architecture Notes

### Domain-Specific Asset Loading
- Each domain uses symlinks to shared assets in `/assets/`
- `loader.js` dynamically injects UI elements based on domain
- ElevenLabs integration is per-domain via `elevenlabs.js` files

### Payment Processing Flow
1. Frontend collects payment data
2. API server at `/charge` endpoint processes requests
3. BIN lookup adds metadata without storing sensitive data
4. IPOSPay integration handles actual payment processing

### Multi-Tenant Configuration
- Apache UserDir enables per-domain content in `html/[domain]/public_html/`
- Global includes provide consistent styling and functionality
- Domain-specific favicons and branding through asset symlinks

## Deployment Notes

- Repository tracks `/var/www` state with Git
- Systemd service: `flask-api-server.service`
- SSL certificates managed via DNS-01 challenge
- Asset deployment requires running init scripts after changes

## File Structure Patterns

- `html/[domain]/public_html/index.html` - Domain homepages
- `html/[domain]/elevenlabs.js` - Symlink to domain-specific ElevenLabs config
- `html/[domain]/favicon.ico` - Symlink to domain-specific favicon
- `assets/favicons/favicon-[domain].ico` - Domain-specific favicons
- `assets/elevenlabs/[domain]-elevenlabs.js` - Domain-specific ElevenLabs configurations