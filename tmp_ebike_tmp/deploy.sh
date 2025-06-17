
#!/bin/bash

set -e

MODE=$1
if [[ "$MODE" != "--poc" && "$MODE" != "--live" ]]; then
    echo "Usage: $0 --poc | --live"
    exit 1
fi

echo "[+] Updating system and installing Python 3.12, venv, and pip..."
sudo apt update
sudo apt install -y python3.12 python3.12-venv python3-pip

echo "[+] Creating virtual environment..."
cd backend
python3.12 -m venv venv
source venv/bin/activate

echo "[+] Installing required Python packages..."
pip install --upgrade pip
echo -e "Flask\nFlask-CORS\nrequests" > requirements.txt
pip install -r requirements.txt

echo "[+] Launching backend in $MODE mode..."
if [[ "$MODE" == "--poc" ]]; then
    export FLASK_APP=app.py
    export FLASK_ENV=development
    flask run --host=0.0.0.0 --port=5000
else
    echo "[ERROR] Live mode not implemented yet."
    exit 2
fi
