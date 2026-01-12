# Right Amount (Bar-Line) - Complete Deployment Guide

**Application:** Right Amount - Investment Calculator Tool  
**Internal Name:** Bar-Line  
**Type:** React (Vite) Frontend + Flask Backend  
**Frontend Ports:** 9002 (independent) or /right-amount (via main nginx)  
**Backend Port:** 8001  
**Framework:** React 18 + TypeScript + Flask

---

## 🎯 Overview

Right Amount (Bar-Line) is an investment calculator application with:
- **Frontend:** React + Vite + TypeScript
- **Backend:** Flask API for calculations
- **Features:** Investment planning, amount calculations, financial projections

**Access URLs:**
- Main Site Integration: http://82.25.105.18/right-amount/
- Independent Access: http://82.25.105.18:9002
- Backend API: http://82.25.105.18/api/right-amount/

---

## 📋 Prerequisites

1. ✅ SSH access to VPS (82.25.105.18)
2. ✅ Node.js 18+ and npm installed
3. ✅ Python 3.x installed
4. ✅ PM2 installed (for process management)
5. ✅ Nginx installed and running
6. ✅ Bar-Line source code

---

## 📁 Required Application Structure

```
Bar-Line/
├── package.json           # Frontend dependencies
├── vite.config.ts        # Vite configuration
├── tsconfig.json         # TypeScript config
├── index.html            # Entry HTML
├── src/
│   ├── main.tsx          # React entry point
│   ├── App.tsx           # Main app component
│   ├── components/       # React components
│   └── styles/           # CSS/styling
├── backend/
│   ├── server.py         # Flask application (or app.py)
│   ├── requirements.txt  # Python dependencies
│   ├── venv/            # Virtual environment (created during deployment)
│   └── utils/           # Backend utilities
└── dist/                 # Built frontend (created during build)
```

**Minimum Required Files:**
- Frontend: `package.json`, `vite.config.ts`, `src/main.tsx`, `src/App.tsx`
- Backend: `server.py` (or `app.py`), `requirements.txt`

---

## 🚀 Deployment Methods

### Method 1: Automated Deployment Script (Recommended)

**Step 1:** Upload the deployment script to your VPS

```bash
# From your local machine
scp deploy-right-amount.sh root@82.25.105.18:/tmp/
```

**Step 2:** Upload your Bar-Line application

```bash
# Option A: Using SCP
scp -r ./Bar-Line root@82.25.105.18:/var/www/vsfintech/

# Option B: Using Git (if in repository)
ssh root@82.25.105.18
cd /var/www/vsfintech
git clone <BAR_LINE_REPO_URL> Bar-Line
```

**Step 3:** Run the deployment script

```bash
ssh root@82.25.105.18
chmod +x /tmp/deploy-right-amount.sh
sudo /tmp/deploy-right-amount.sh
```

The script will automatically:
- ✅ Install prerequisites (Node.js, Python, PM2)
- ✅ Deploy Flask backend with virtual environment
- ✅ Configure React app for /right-amount subpath
- ✅ Build React frontend
- ✅ Configure Nginx for both main site and independent port
- ✅ Start backend with PM2
- ✅ Set correct permissions
- ✅ Test all endpoints

---

### Method 2: Manual Step-by-Step Deployment

#### Part A: Deploy Backend (Flask)

**Step 1:** Upload backend files

```bash
ssh root@82.25.105.18
cd /var/www/vsfintech/Bar-Line/backend
```

**Step 2:** Create Python virtual environment

```bash
python3 -m venv venv
source venv/bin/activate
```

**Step 3:** Install dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt

# Or install manually:
pip install flask gunicorn flask-cors pandas numpy
```

**Sample requirements.txt:**
```txt
Flask==3.0.0
gunicorn==21.2.0
flask-cors==4.0.0
pandas==2.1.3
numpy==1.26.2
```

**Step 4:** Verify Flask application

Sample `server.py` structure:
```python
from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/')
def home():
    return jsonify({"message": "Right Amount API", "status": "running"})

@app.route('/api/calculate', methods=['POST'])
def calculate():
    data = request.json
    # Your calculation logic here
    return jsonify({"result": "calculated"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8001, debug=False)
```

Test locally:
```bash
python server.py
# In another terminal: curl http://localhost:8001/
```

Press `Ctrl+C` to stop.

**Step 5:** Configure PM2

```bash
deactivate  # Exit venv

# Remove old PM2 process
pm2 stop bar-line-backend 2>/dev/null || true
pm2 delete bar-line-backend 2>/dev/null || true

# Start with PM2
pm2 start /var/www/vsfintech/Bar-Line/backend/venv/bin/gunicorn \
    --name bar-line-backend \
    --cwd /var/www/vsfintech/Bar-Line/backend \
    --interpreter none \
    -- -w 2 -b 0.0.0.0:8001 server:app

# Save PM2 configuration
pm2 save
```

#### Part B: Deploy Frontend (React + Vite)

**Step 1:** Upload frontend files

```bash
cd /var/www/vsfintech/Bar-Line
```

**Step 2:** Install npm dependencies

```bash
npm install
```

**Step 3:** Configure for subpath deployment

The app needs to be configured to work at `/right-amount` instead of root `/`.

**Update `vite.config.ts`:**
```typescript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/right-amount',  // ← Add this line
  server: {
    port: 5173
  }
})
```

**Update `src/main.tsx` for React Router:**
```typescript
import React from 'react'
import ReactDOM from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import App from './App'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <BrowserRouter basename="/right-amount">  {/* ← Add basename */}
      <App />
    </BrowserRouter>
  </React.StrictMode>
)
```

**Create `.env` file:**
```bash
echo "VITE_API_URL=/api/right-amount" > .env
```

**Update API calls in your code:**
```typescript
// Use the environment variable for API base URL
const API_URL = import.meta.env.VITE_API_URL || '/api/right-amount';

// Example API call
const response = await fetch(`${API_URL}/calculate`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(data)
});
```

**Step 4:** Build the application

```bash
npm run build
```

This creates a `dist/` folder with the production build.

**Step 5:** Verify build

```bash
ls -la dist/
# Should see: index.html, assets/, etc.
```

#### Part C: Configure Nginx

**Step 1:** Edit main nginx config

```bash
sudo nano /etc/nginx/sites-available/vsfintech.conf
```

Add these location blocks:

```nginx
server {
    listen 80;
    server_name 82.25.105.18;
    
    # Right Amount (Bar-Line) - Frontend
    location /right-amount {
        alias /var/www/vsfintech/Bar-Line/dist;
        try_files $uri $uri/ /right-amount/index.html;
    }
    
    # Right Amount Backend API
    location /api/right-amount/ {
        proxy_pass http://localhost:8001/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

**Step 2:** Create independent port config (Port 9002)

```bash
sudo nano /etc/nginx/sites-available/right-amount-9002.conf
```

```nginx
server {
    listen 9002;
    server_name 82.25.105.18;
    
    root /var/www/vsfintech/Bar-Line/dist;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Proxy API calls to backend
    location /api/ {
        proxy_pass http://localhost:8001/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    
    # Enable gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;
}
```

Enable the site:
```bash
sudo ln -s /etc/nginx/sites-available/right-amount-9002.conf /etc/nginx/sites-enabled/
```

**Step 3:** Test and reload Nginx

```bash
sudo nginx -t
sudo systemctl reload nginx
```

#### Part D: Set Permissions

```bash
sudo chown -R www-data:www-data /var/www/vsfintech/Bar-Line
sudo chmod -R 755 /var/www/vsfintech/Bar-Line
```

#### Part E: Test Deployment

```bash
# Test backend
curl http://localhost:8001/

# Test frontend via main site
curl http://localhost/right-amount/

# Test frontend on independent port
curl http://localhost:9002/

# Check PM2 status
pm2 status

# View backend logs
pm2 logs bar-line-backend
```

---

## 🔍 Verification & Testing

### Check Service Status

```bash
# PM2 process
pm2 status
# Expected: bar-line-backend | online | 0 restarts

# Backend health
curl http://localhost:8001/
```

### Test All Access Points

```bash
# 1. Backend API directly
curl http://82.25.105.18:8001/

# 2. Backend through Nginx proxy
curl http://82.25.105.18/api/right-amount/

# 3. Frontend via main site
curl -I http://82.25.105.18/right-amount/

# 4. Frontend on independent port
curl -I http://82.25.105.18:9002/
```

### Check Logs

```bash
# Backend logs
pm2 logs bar-line-backend

# Nginx access logs
sudo tail -f /var/log/nginx/access.log | grep right-amount

# Nginx error logs
sudo tail -f /var/log/nginx/error.log
```

---

## 🔧 Troubleshooting

### Issue: Blank page or assets not loading

**Cause:** Base path not configured correctly in Vite

**Solution:**
```bash
cd /var/www/vsfintech/Bar-Line

# Check vite.config.ts has base: '/right-amount'
grep "base:" vite.config.ts

# If not, add it
nano vite.config.ts
# Add: base: '/right-amount',

# Rebuild
npm run build
```

### Issue: React Router not working (404 on refresh)

**Cause:** Missing basename in BrowserRouter or nginx try_files

**Solution:**
```bash
# 1. Check main.tsx has basename="/right-amount"
grep "basename" src/main.tsx

# 2. Verify nginx try_files
sudo cat /etc/nginx/sites-available/vsfintech.conf | grep -A2 "location /right-amount"

# Should have: try_files $uri $uri/ /right-amount/index.html;
```

### Issue: API calls failing (CORS errors)

**Cause:** Backend not configured for CORS

**Solution:**
```bash
cd /var/www/vsfintech/Bar-Line/backend
source venv/bin/activate

# Install flask-cors
pip install flask-cors

# Update server.py
nano server.py
```

Add CORS:
```python
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Add this line
```

Restart:
```bash
deactivate
pm2 restart bar-line-backend
```

### Issue: 502 Bad Gateway

**Cause:** Backend not running

**Solution:**
```bash
# Check PM2 status
pm2 status

# Restart backend
pm2 restart bar-line-backend

# View logs
pm2 logs bar-line-backend --lines 50

# Check port 8001
sudo netstat -tulpn | grep 8001
```

### Issue: Port 8001 already in use

**Solution:**
```bash
# Find process using port 8001
sudo lsof -i :8001

# Kill it
sudo kill -9 <PID>

# Restart PM2
pm2 restart bar-line-backend
```

---

## 📊 Monitoring & Maintenance

### View Real-time Logs

```bash
# Backend logs (live)
pm2 logs bar-line-backend

# PM2 monitoring dashboard
pm2 monit
```

### Check Resource Usage

```bash
pm2 status
# Look at memory and CPU usage for bar-line-backend
```

### Restart Services

```bash
# Restart backend only
pm2 restart bar-line-backend

# Reload without downtime
pm2 reload bar-line-backend

# Restart all services
pm2 restart all
```

### Update Application

```bash
# Method 1: Git pull (if using Git)
cd /var/www/vsfintech/Bar-Line
git pull origin main
npm install
npm run build
pm2 restart bar-line-backend

# Method 2: Upload new files
# Upload via SCP, then:
npm install
npm run build
pm2 restart bar-line-backend

# Method 3: Update backend only
cd backend
source venv/bin/activate
pip install -r requirements.txt --upgrade
deactivate
pm2 restart bar-line-backend
```

---

## 🔗 Integration with Main Platform

Right Amount is accessible from the main VS Fintech Platform:

### Frontend Integration

**Homepage** (`frontend/src/pages/HomePage.tsx`):
```typescript
// Tool card linking to Right Amount
href="http://82.25.105.18/right-amount"
```

**Fundoscope Page** (`frontend/src/pages/tools/FundoscopePage.tsx`):
```typescript
// Listed as tool #2
href="http://82.25.105.18/right-amount"
```

### Update Links (if needed)

If you need to update integration links:

```bash
cd /var/www/vsfintech/VSFintech-Platform/frontend

# Update HomePage.tsx
nano src/pages/HomePage.tsx
# Find and verify: href="/right-amount" or full URL

# Update Fundoscope
nano src/pages/tools/FundoscopePage.tsx

# Rebuild main platform
npm run build

# Reload nginx
sudo systemctl reload nginx
```

---

## 📝 Configuration Files

### PM2 Ecosystem File

Add to `/var/www/vsfintech/pm2-ecosystem-all-apps.json`:

```json
{
  "name": "bar-line-backend",
  "cwd": "/var/www/vsfintech/Bar-Line/backend",
  "script": "venv/bin/gunicorn",
  "args": "-w 2 -b 0.0.0.0:8001 server:app",
  "interpreter": "none",
  "autorestart": true,
  "watch": false
}
```

Start from ecosystem file:
```bash
pm2 start pm2-ecosystem-all-apps.json --only bar-line-backend
```

---

## ✅ Deployment Checklist

- [ ] Bar-Line code uploaded to `/var/www/vsfintech/Bar-Line/`
- [ ] Backend files present (`backend/server.py`, `requirements.txt`)
- [ ] Frontend files present (`package.json`, `src/main.tsx`)
- [ ] Python virtual environment created in `backend/venv/`
- [ ] Python dependencies installed
- [ ] Flask backend tested locally
- [ ] PM2 process `bar-line-backend` running on port 8001
- [ ] `vite.config.ts` configured with `base: '/right-amount'`
- [ ] `src/main.tsx` has `basename="/right-amount"` in BrowserRouter
- [ ] `.env` file created with `VITE_API_URL=/api/right-amount`
- [ ] Frontend built successfully (`dist/` folder exists)
- [ ] Nginx config added for `/right-amount` location
- [ ] Nginx config added for `/api/right-amount/` proxy
- [ ] Independent port 9002 configured (optional)
- [ ] Nginx configuration tested (`nginx -t`)
- [ ] Nginx reloaded
- [ ] File permissions set (www-data:www-data, 755)
- [ ] Backend responding on port 8001
- [ ] Frontend accessible at `/right-amount`
- [ ] API calls working through `/api/right-amount/`
- [ ] React Router navigation working
- [ ] PM2 saved and set to auto-start
- [ ] Integration with main platform verified

---

## 🎯 Quick Reference Commands

```bash
# Status
pm2 status
pm2 info bar-line-backend

# Logs
pm2 logs bar-line-backend
pm2 logs bar-line-backend --lines 100

# Control
pm2 restart bar-line-backend
pm2 stop bar-line-backend
pm2 start bar-line-backend
pm2 reload bar-line-backend

# Rebuild frontend
cd /var/www/vsfintech/Bar-Line
npm run build

# Restart backend
pm2 restart bar-line-backend

# Reload nginx
sudo nginx -t
sudo systemctl reload nginx

# Test endpoints
curl http://localhost:8001/
curl http://localhost/right-amount/
curl http://localhost:9002/
```

---

## 📞 Support & Next Steps

**Deployment Status:** Ready for deployment  
**Expected Result:**
- Frontend: http://82.25.105.18/right-amount/
- Independent: http://82.25.105.18:9002
- Backend API: http://82.25.105.18/api/right-amount/

**Next Steps:**
1. Prepare Bar-Line application code (React frontend + Flask backend)
2. Upload to VPS
3. Run deployment script or follow manual steps
4. Test all access points
5. Verify integration with main platform
6. Update DEPLOYMENT-SUMMARY.md

---

**Ready to deploy?** Run the automated script or follow the manual deployment steps!
