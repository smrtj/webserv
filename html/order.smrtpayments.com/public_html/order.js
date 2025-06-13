// Basic order form submission to /charge endpoint with pricing lookup

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('orderForm');
    const message = document.getElementById('message');
    const productSelect = document.getElementById('product');
    const quantityInput = document.getElementById('quantity');
    const amountInput = document.getElementById('amount');

    if (!form) return;

    const pricing = {
        'Aloha PX15 Quick Service Pro': 2500.00,
        'Aloha PX10 Table Service Core': 2200.00,
        'Silver PX15 Essentials Complete': 2000.00,
        'Silver PX10 Essentials Starter': 1800.00,
        'Silver PX15 Essentials Starter': 2000.00,
        'Aloha PX15 Full-Service Deluxe': 3200.00,
        'Handheld Axium EX8000 Kit 2': 900.00,
        'Handheld Axium EX8000': 825.00,
        'Bixolon SRP-S300LOEK Sticky Printer Kit': 500.00,
        'Countertop Receipt Printer for NCR Silver': 400.00,
        'Kitchen Impact Printer': 400.00,
        'NCR Silver 2D Scanner': 325.00,
        'Aloha Cloud 2D Scanner': 325.00,
        'Mettler Toledo Avira S-17': 200.00,
        'Cash Drawer MS': 150.00,
        'Cash Drawer w/Till': 150.00,
        'Cash Drawer Till MS': 50.00,
        'Cash Drawer Under Counter Mounting Bracket (M-S)': 50.00,
        'Cash Drawer Under Counter Mounting Bracket (APG)': 50.00,
        'Kitchen Display System (KDS)': 525.00
    };

    function updateAmount() {
        const price = pricing[productSelect.value] || 0;
        const qty = parseInt(quantityInput.value, 10) || 0;
        amountInput.value = (price * qty).toFixed(2);
    }

    productSelect.addEventListener('change', updateAmount);
    quantityInput.addEventListener('input', updateAmount);
    updateAmount();

    form.addEventListener('submit', async function(event) {
        event.preventDefault();
        message.textContent = 'Processing...';

        const data = {
            merchant_id: document.getElementById('merchant_id').value,
            payment_token_id: document.getElementById('payment_token_id').value,
            amount: parseFloat(amountInput.value),
            currency: 'USD',
            metadata: {
                name: document.getElementById('name').value,
                email: document.getElementById('email').value,
                product: productSelect.value,
                quantity: parseInt(quantityInput.value, 10)
            }
        };

        try {
            const response = await fetch('/charge', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            });
            if (response.ok) {
                const result = await response.json();
                message.textContent = 'Success! Charge ID: ' + (result.id || '');
                form.reset();
                updateAmount();
            } else {
                const err = await response.json();
                message.textContent = 'Error: ' + (err.error || 'Unknown');
            }
        } catch (e) {
            message.textContent = 'Network error';
        }
    });
});
