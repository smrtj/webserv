import json
import requests

class IPOSPayIntegration:
    def __init__(self, domain):
        with open('/var/www/assets/api_keys.json', 'r') as f:
            api_keys = json.load(f)
        # Select API key based on domain or use default
        if domain in api_keys:
            config = api_keys[domain]
        else:
            config = api_keys["default"]
        self.api_key = config["api_key"]
        self.base_url = config["base_url"]

    def charge_token(self, merchant_id, payment_token_id, amount, currency="USD", metadata={}):
        url = f"{self.base_url}/charge"
        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }
        payload = {
            "merchant_id": merchant_id,
            "payment_token_id": payment_token_id,
            "amount": amount,
            "currency": currency,
            "metadata": metadata
        }
        response = requests.post(url, headers=headers, json=payload)
        response.raise_for_status()
        return response.json()

    def charge_ach(
        self,
        merchant_id,
        account_number,
        routing_number,
        amount,
        currency="USD",
        metadata={},
    ):
        """Charge a customer's bank account using ACH."""

        url = f"{self.base_url}/charge/ach"
        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json",
        }
        payload = {
            "merchant_id": merchant_id,
            "account_number": account_number,
            "routing_number": routing_number,
            "amount": amount,
            "currency": currency,
            "metadata": metadata,
        }
        response = requests.post(url, headers=headers, json=payload)
        response.raise_for_status()
        return response.json()

# End of IPOSPayIntegration.py.
