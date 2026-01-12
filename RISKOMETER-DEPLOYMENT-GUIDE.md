# Riskometer Deployment Guide

## 📋 Overview
This guide will help you deploy the Riskometer application safely without breaking any existing projects.

**Target Configuration:**
- Frontend URL: `http://82.25.105.18/riskometer/`
- Backend API: `http://82.25.105.18/api/riskometer/`
- Backend Port: `5002` (confirmed available)
- Installation Path: `/var/www/vsfintech/Riskometer`

---

## 🎯 Pre-Deployment Checklist

### 1. Project Structure
Your Riskometer project should have this structure:
```
Riskometer/
├── frontend/ (or root with package.json)
│   ├── package.json
│   ├── vite.config.js/ts
│   ├── src/
│   │   ├── main.tsx
│   │   └── ...
│   └── ...
├── backend/ (optional)
│   ├── server.py or app.py
│   ├── requirements.txt
│   └── ...
```

### 2. Required Information
- [ ] Do you have a backend? (Yes/No)
- [ ] Is frontend React or static HTML?
- [ ] Backend port preference (default: 5002)
- [ ] Does backend need database?

---

## 🚀 Deployment Steps

### Step 1: Upload Your Code

**Option A: From Local Machine**
```powershell
# If you have the code locally
scp -r D:\Your-Riskometer-Path root@82.25.105.18:/var/www/vsfintech/Riskometer
```

**Option B: From Git**
```bash
ssh root@82.25.105.18
cd /var/www/vsfintech
git clone YOUR_REPOSITORY_URL Riskometer
```

**Option C: Manual Upload**
- ZIP your project
- Use WinSCP or FileZilla to upload to `/var/www/vsfintech/Riskometer`

---

### Step 2: Run Deployment Script

**Upload the deployment script:**
```powershell
scp D:\VSFintech-Platform\deploy-riskometer-safe.sh root@82.25.105.18:/root/
```

**Make it executable and run:**
```bash
ssh root@82.25.105.18
chmod +x /root/deploy-riskometer-safe.sh
sudo /root/deploy-riskometer-safe.sh
```

The script will:
- ✅ Check prerequisites (Node.js, Python, PM2)
- ✅ Install dependencies
- ✅ Build frontend (if React)
- ✅ Start backend on port 5002 (if exists)
- ✅ Configure nginx (without touching existing config)
- ✅ Test deployment

---

### Step 3: Verify Deployment

**Test URLs:**
```powershell
# Frontend
Invoke-WebRequest -Uri "http://82.25.105.18/riskometer/" -UseBasicParsing

# Backend API (if exists)
Invoke-WebRequest -Uri "http://82.25.105.18/api/riskometer/" -UseBasicParsing
```

**Check backend process:**
```bash
ssh root@82.25.105.18
pm2 status
pm2 logs riskometer-backend
```

---

## 🔧 Manual Configuration (If Needed)

### Nginx Configuration

If automatic configuration fails, manually add to `/etc/nginx/sites-enabled/default` before the main `location / {` block:

```nginx
# =====================================================
# RISKOMETER - Risk Assessment Tool
# =====================================================
# Riskometer Backend API
location /api/riskometer/ {
    proxy_pass http://127.0.0.1:5002/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    
    # CORS headers (if needed)
    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization' always;
}

# Riskometer Frontend
location /riskometer/ {
    alias /var/www/vsfintech/Riskometer/dist/;  # or just /Riskometer/ for static
    try_files $uri $uri/ /riskometer/index.html;
    index index.html;
}

location /riskometer {
    return 301 /riskometer/;
}
```

Test and reload:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## 🎨 Frontend Configuration

### For React + Vite

**1. Update `vite.config.ts` or `vite.config.js`:**
```javascript
export default defineConfig({
  base: '/riskometer',  // Important for subpath
  // ... rest of config
})
```

**2. Update `src/main.tsx` (if using React Router):**
```tsx
import { BrowserRouter } from 'react-router-dom';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter basename="/riskometer">
      <App />
    </BrowserRouter>
  </StrictMode>
);
```

**3. Update API calls:**
```javascript
// Use relative path
const API_BASE_URL = '/api/riskometer';

// Or create .env file
VITE_API_URL=/api/riskometer
```

**4. Build:**
```bash
npm install
npm run build
```

---

## 🐍 Backend Configuration

### Flask Backend Example

**server.py or app.py:**
```python
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS

@app.route('/')
def index():
    return jsonify({"status": "Riskometer API running", "version": "1.0"})

@app.route('/calculate', methods=['POST'])
def calculate_risk():
    # Your risk calculation logic
    return jsonify({"risk_score": 75})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002, debug=False)
```

**requirements.txt:**
```
Flask==3.0.0
flask-cors==4.0.0
gunicorn==21.2.0
pandas==2.1.0
numpy==1.24.0
```

**Install dependencies:**
```bash
cd /var/www/vsfintech/Riskometer/backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

**Start with PM2:**
```bash
pm2 start venv/bin/gunicorn \
    --name riskometer-backend \
    --cwd /var/www/vsfintech/Riskometer/backend \
    --interpreter none \
    -- -w 2 -b 0.0.0.0:5002 server:app

pm2 save
```

---

## 🧪 Testing

### Frontend Test
```bash
curl http://82.25.105.18/riskometer/
```
**Expected:** HTML content with status 200

### Backend Test
```bash
curl http://82.25.105.18/api/riskometer/
```
**Expected:** JSON response with status 200

### From Windows
```powershell
$urls = @('/riskometer/', '/api/riskometer/')
foreach($url in $urls) {
    $response = Invoke-WebRequest -Uri "http://82.25.105.18$url" -UseBasicParsing
    Write-Host "$url - HTTP $($response.StatusCode)" -ForegroundColor $(if($response.StatusCode -eq 200){'Green'}else{'Red'})
}
```

---

## 🛠️ Troubleshooting

### Issue: Backend Not Starting
```bash
# Check logs
pm2 logs riskometer-backend

# Check if port is in use
lsof -i :5002

# Try starting manually
cd /var/www/vsfintech/Riskometer/backend
source venv/bin/activate
python server.py
```

### Issue: Frontend Shows 404
```bash
# Check nginx config
sudo nginx -t

# Check file permissions
ls -la /var/www/vsfintech/Riskometer/dist/

# Fix permissions
sudo chown -R www-data:www-data /var/www/vsfintech/Riskometer/dist/
sudo chmod -R 755 /var/www/vsfintech/Riskometer/dist/
```

### Issue: API Returns CORS Error
Add CORS headers to nginx (see manual configuration above) or enable in Flask backend:
```python
from flask_cors import CORS
CORS(app)
```

### Issue: Frontend Can't Connect to Backend
Check API base URL in frontend code. Should be `/api/riskometer` (relative path), not absolute URL.

---

## 📊 Port Allocation Reference

| Service | Port | Status |
|---------|------|--------|
| Risk-Reward | 5001 | ✅ Used |
| **Riskometer** | **5002** | ✅ Available |
| Investment Calc API | 5003 | ✅ Used |
| AlphaNifty | 5000 | ✅ Used |
| Right Amount | 8001 | ✅ Used |
| Sector Heatmap | 8002 | ✅ Used |
| PMS Screener | 8004 | ✅ Used |
| Investment Calc UI | 3000 | ✅ Used |

---

## 🔄 Maintenance Commands

### View Backend Logs
```bash
pm2 logs riskometer-backend
pm2 logs riskometer-backend --lines 100
```

### Restart Backend
```bash
pm2 restart riskometer-backend
```

### Stop Backend
```bash
pm2 stop riskometer-backend
```

### Delete Backend (Remove from PM2)
```bash
pm2 delete riskometer-backend
pm2 save
```

### Rebuild Frontend
```bash
cd /var/www/vsfintech/Riskometer
npm run build
```

### View Nginx Logs
```bash
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

---

## 🔐 Security Considerations

1. **Never expose backend port directly** - Always use nginx reverse proxy
2. **Enable CORS** only for required origins
3. **Use HTTPS** in production (configure SSL certificate)
4. **Validate all inputs** in backend
5. **Set proper permissions** on files and directories

---

## 📁 Directory Structure After Deployment

```
/var/www/vsfintech/Riskometer/
├── dist/                    # Built frontend (if React)
│   ├── index.html
│   ├── assets/
│   └── ...
├── backend/                 # Backend (if exists)
│   ├── venv/               # Python virtual environment
│   ├── server.py
│   ├── requirements.txt
│   └── ...
├── package.json            # Frontend dependencies (if React)
├── vite.config.js          # Vite configuration
└── ...
```

---

## ✅ Safety Features

The deployment script ensures:
- ✅ **No existing projects are modified**
- ✅ **Nginx config is backed up** before changes
- ✅ **Port conflict check** before starting backend
- ✅ **Automatic rollback** on nginx config error
- ✅ **Validation tests** after deployment
- ✅ **Isolated virtual environment** for Python

---

## 📞 Support

If you encounter issues:

1. **Check logs**: `pm2 logs riskometer-backend` and `/var/log/nginx/error.log`
2. **Verify configuration**: Review this guide's manual configuration section
3. **Test each component**: Frontend, backend, and nginx separately
4. **Check permissions**: Ensure www-data owns frontend files

---

**Deployment Date:** January 8, 2026
**Script Version:** 1.0
**Status:** Ready for deployment with port 5002 confirmed available
