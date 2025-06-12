document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('order-form');
  const shippingCostSpan = document.getElementById('shipping-cost');
  const surchargeSpan = document.getElementById('surcharge');
  const totalCostSpan = document.getElementById('total-cost');

  function lookupShipping(zip) {
    if (!zip) return 0;
    if (zip.startsWith('3')) return 35;
    if (zip.startsWith('9')) return 60;
    return 45;
  }

  function updateTotals() {
    const amount = parseFloat(document.getElementById('amount').value) || 0;
    const zip = document.getElementById('shipping-zip').value;
    const method = document.getElementById('payment-method').value;
    const shipping = lookupShipping(zip);
    const subtotal = amount + shipping;
    let surcharge = 0;
    if (method === 'credit') {
      surcharge = subtotal * 0.04;
    }
    const total = subtotal + surcharge;
    shippingCostSpan.textContent = shipping.toFixed(2);
    surchargeSpan.textContent = surcharge.toFixed(2);
    totalCostSpan.textContent = total.toFixed(2);
    return { shipping, surcharge, total };
  }

  document.getElementById('shipping-zip').addEventListener('input', updateTotals);
  document.getElementById('payment-method').addEventListener('change', updateTotals);
  document.getElementById('amount').addEventListener('input', updateTotals);

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const { shipping, surcharge, total } = updateTotals();
    const data = {
      merchant_id: 'ORDER_MERCHANT',
      payment_token_id: document.getElementById('payment-token').value,
      amount: total,
      currency: 'USD',
      payment_method: document.getElementById('payment-method').value,
      shipping_zip: document.getElementById('shipping-zip').value,
      metadata: { shipping_cost: shipping, surcharge }
    };
    try {
      const resp = await fetch('/charge', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      });
      const result = await resp.json();
      alert('Payment result: ' + JSON.stringify(result));
    } catch (err) {
      alert('Payment failed: ' + err.message);
    }
  });
});
