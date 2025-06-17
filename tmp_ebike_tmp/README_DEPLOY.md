# Discover E-Bike Waiver Deployment (Full Package)

## 📁 Contents
- `public_html/` → Static UI
- `backend/` → Flask app with BIN check and placeholder endpoints
- `secrets/` → Drop your credentials here
- `deploy.sh` → POC launcher

## 🚀 To Run (POC Mode)
```bash
./deploy.sh --poc
```

Then open `http://<your-server-ip>:8080`

## 📌 Notes
- Email and Payment routes are stubs — logic can be inserted in `app.py`
- BIN check is active (VISA skips auth, Mastercard requires auth)

## 🔒 SSL/Production Mode Coming Soon
