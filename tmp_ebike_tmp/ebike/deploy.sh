#!/bin/bash
echo "[+] Installing dependencies..."
npm install express body-parser pdfkit googleapis nodemailer axios dotenv

echo "[+] Starting the server on port 3000..."
node server.js
