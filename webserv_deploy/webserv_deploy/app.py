from flask import Flask, request, jsonify
from flask_cors import CORS
from IPOSPayIntegration import IPOSPayIntegration
import socket

app = Flask(__name__)
CORS(app)

@app.route('/charge', methods=['POST'])
def charge():
    try:
        data = request.json
        required_fields = ['merchant_id', 'payment_token_id', 'amount']
        for field in required_fields:
            if field not in data:
                return jsonify({"error": f"Missing required field: {field}"}), 400

        merchant_id = data['merchant_id']
        payment_token_id = data['payment_token_id']
        amount = data['amount']
        currency = data.get('currency', 'USD')
        metadata = data.get('metadata', {})

        # Improved domain detection
        domain = request.headers.get("Host", socket.gethostname())
        domain = domain.split(":")[0]  # Strip port if present

        ipos = IPOSPayIntegration(domain)
        response = ipos.charge_token(merchant_id, payment_token_id, amount, currency, metadata)

        return jsonify(response), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
