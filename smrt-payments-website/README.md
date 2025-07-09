# SMRT Payments Website

This directory contains the full SMRT Payments website source. It includes a React frontend powered by Vite and Tailwind CSS and an Express backend for quiz scoring and ElevenLabs text-to-speech.

## Development

Install dependencies and start the development servers:

```bash
npm install
npm run dev
npm run server
```

## Build

To create a production build of the frontend:

```bash
npm run build
```

The compiled files will appear in `dist/`. Serve these files with Apache and proxy `/api` requests to the Node backend running on port 3000.

## Environment Variables

Copy `.env` and supply real values for your Contentful and ElevenLabs credentials.
