from flask import Flask, jsonify, request, redirect
from IPOSPayIntegration import IPOSPayIntegration
import os

app = Flask(__name__)
processor = IPOSPayIntegration()

@app.route('/health')
def health():
    return jsonify({'status': 'ok'})

@app.route('/payment', methods=['POST'])
def payment():
    data = request.json or {}
    result = processor.process_payment(data)
    return jsonify(result)

@app.route('/ebike')
def ebike():
    return redirect('https://showcase.smrtpayments.com/ebike', code=302)

@app.route('/order')
def order():
    return redirect('https://order.smrtpayments.com', code=302)

if __name__ == '__main__':
    host = os.getenv('FLASK_HOST', '0.0.0.0')
    port = int(os.getenv('FLASK_PORT', '5000'))
    app.run(host=host, port=port)
