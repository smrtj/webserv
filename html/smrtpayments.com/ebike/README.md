# eBike Waiver Page

This directory is deployed to `/var/www/html/smrtpayments.com/ebike/` on the web server.
The `index.html` file provides the customer waiver form. When submitted, the form
sends a `POST` request to the Flask API endpoint at `/api/waiver`.

The Flask service running on the server processes the waiver data and stores the
results for Discover eBike rentals.
