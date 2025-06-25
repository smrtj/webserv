# SMRT / KJO / HackServe Page Assets

## Purpose:

This folder contains HTML snippets used by the `loader.js` script to inject persistent UI elements into *every page* across all domains and subdomains.

## Standard Positions:

| Position          | Naming Pattern |
|-------------------|----------------|
| Top Left          | [prefix]-top-left.html |
| Top Right         | [prefix]-top-right.html |
| Bottom Left       | [prefix]-bottom-left.html |
| Bottom Center     | [prefix]-bottom-center.html |
| Bottom Right (Cote Signature) | [prefix]-cote-signature.html |
| Top Center (ElevenLabs) | [prefix]-elevenlabs-widget.html |

## Domain Prefixes:

| Domain(s)               | Prefix |
|-------------------------|--------|
| smrtpayments.com        | smrt   |
| teamkjo.com, kjo.ai     | kjo    |
| hackserv.cc, hackserv.org | hack  |

## Notes:

- Each file is a **HTML snippet** (not full page), inserted by `/assets/loader.js`
- If empty → nothing shown in that position
- If symlink → follows target content (default: smrt-*)
- If real file → used for domain-specific content

## To initialize:

```bash
cd /var/www/assets
./init-assets.sh
```

## To patch pages:

```bash
cd /var/www/assets
./insert-loader.sh
```
