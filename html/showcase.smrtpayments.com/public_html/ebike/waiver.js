document.getElementById('waiver-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const name = document.getElementById('name').value;
    const agree = document.getElementById('agree').checked;
    if (!agree) {
        alert('You must agree to the waiver.');
        return;
    }
    try {
        const res = await fetch('/api/waiver', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name })
        });
        if (res.ok) {
            document.getElementById('result').innerText = 'Waiver submitted successfully.';
        } else {
            document.getElementById('result').innerText = 'Error submitting waiver.';
        }
    } catch (err) {
        document.getElementById('result').innerText = 'Network error.';
    }
});
