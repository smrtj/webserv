import os
import json

class IPOSPayIntegration:
    """Minimal wrapper for iPosPays payment processing."""

    def __init__(self, config_path='api_keys.json'):
        self.api_key = os.getenv('IPOSPAY_API_KEY')
        self.api_secret = os.getenv('IPOSPAY_API_SECRET')

        if not (self.api_key and self.api_secret):
            try:
                with open(config_path) as fh:
                    data = json.load(fh)
                    self.api_key = self.api_key or data.get('pos_api_key')
                    self.api_secret = self.api_secret or data.get('pos_api_secret')
            except (IOError, ValueError):
                # Credentials remain unset if file missing or invalid
                pass

        if not (self.api_key and self.api_secret):
            raise ValueError('IPOSPay credentials not found')

    def process_payment(self, amount, currency='USD', method='card', details=None):
        """Stub payment processing function.

        In production this would call the iPosPays API. Here we simply
        return a success payload for demonstration.
        """
        if details is None:
            details = {}
        return {
            'status': 'success',
            'amount': amount,
            'currency': currency,
            'method': method,
            'details': details,
            'message': 'Payment processed (stub)'
        }
