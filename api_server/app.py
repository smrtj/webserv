from flask import Flask, request, jsonify
from IPOSPayIntegration import IPOSPayIntegration

app = Flask(__name__)

# Initialize payment integration. Credentials are loaded from environment or api_keys.json
ipos = IPOSPayIntegration()

@app.route('/waiver', methods=['POST'])
def waiver():
    data = request.get_json(force=True, silent=True) or {}
    # Placeholder: store waiver data or trigger business logic
    return jsonify({"status": "received", "data": data})

@app.route('/payment', methods=['POST'])
def payment():
    payload = request.get_json(force=True, silent=True) or {}
    amount = payload.get('amount')
    currency = payload.get('currency', 'USD')
    method = payload.get('method', 'card')
    details = payload.get('details', {})
    if not amount:
        return jsonify({"error": "amount required"}), 400
    result = ipos.process_payment(amount, currency=currency, method=method, details=details)
    return jsonify(result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
