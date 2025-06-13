# API Server

This directory contains the Flask application used for the Discover eBike waiver and order form.

## Running Locally

1. Create and activate a Python virtual environment (if not already present):

```bash
python3 -m venv venv
source venv/bin/activate
```

2. Install dependencies:

```bash
pip install flask flask-cors requests
```

3. Start the server:

```bash
python app.py
```

The API will be available at `http://localhost:5000/charge`.

