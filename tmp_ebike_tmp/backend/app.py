from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/api/bincheck', methods=['POST'])
def bincheck():
    data = request.json
    bin_number = data.get('bin', '')[:6]
    if bin_number.startswith("4"):
        return jsonify({"type": "VISA", "action": "skip_auth"})
    elif bin_number.startswith("5"):
        return jsonify({"type": "MASTERCARD", "action": "auth_required"})
    else:
        return jsonify({"type": "UNKNOWN", "action": "manual_review"})

@app.route('/api/send-confirmation', methods=['POST'])
def send_confirmation():
    # Placeholder for Gmail API integration
    return jsonify({"status": "confirmation sent"})

@app.route('/api/payment', methods=['POST'])
def payment():
    # Placeholder for IPOS Pay processing
    return jsonify({"status": "payment processed"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)


# --- iPOS Pay Integration ---

import requests
from flask import Flask, request, jsonify
import os

app = Flask(__name__)

# Load from environment or use defaults for local testing
IPOS_TOKEN = os.getenv("IPOS_TOKEN", "YOUR_IPOS_TOKEN")
TPN = os.getenv("IPOS_TPN", "YOUR_TPN")
IPOS_API_URL = "https://app.ipos-pay.com/api"  # Adjust if using sandbox or production-specific endpoint

def is_debit_card(bin_number):
    # Mock logic: treat BINs starting with 4 or 5 as credit, others as debit (placeholder)
    return not str(bin_number).startswith(("4", "5"))

@app.route('/preauth', methods=['POST'])
def handle_preauth():
    data = request.json
    card_bin = str(data.get("bin", ""))[:6]
    amount = data.get("amount", "1.00")  # Default $1.00 for pre-auth

    if not card_bin:
        return jsonify({"error": "Missing BIN"}), 400

    # Decide if we need to run pre-auth
    if is_debit_card(card_bin):
        payload = {
            "amount": amount,
            "tpn": TPN,
            "token": IPOS_TOKEN,
            "paymentMethod": {
                "cardNumber": f"{card_bin}******",  # Placeholder for masked card
                "expiryDate": "12/29"
            },
            "type": "authorize"
        }

        try:
            response = requests.post(f"{IPOS_API_URL}/transactions", json=payload)
            response.raise_for_status()
            return jsonify(response.json())
        except Exception as e:
            return jsonify({"error": str(e)}), 502
    else:
        return jsonify({"message": "Credit card detected—no pre-auth required"}), 200
