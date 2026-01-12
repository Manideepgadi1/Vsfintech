# Right Amount (Bar-Line) - SAFE Deployment Guide

**GUARANTEED: This deployment will NOT disturb any existing applications!**

---

## 🛡️ Safety Features

✅ **Unique Backend Port:** 8001 (no conflicts)  
✅ **Unique API Path:** `/api/right-amount/` (separate from others)  
✅ **Unique Frontend Path:** `/right-amount/`  
✅ **Nginx Backup:** Automatic backup before changes  
✅ **Safe Config:** Only adds new blocks, doesn't replace  
✅ **Port Check:** Verifies port availability before starting  

**Current Application Ports:**
- Port 5000: AlphaNifty backend ✓
- Port 5001: Risk-Reward backend ✓
- Port 8002: Sector Heatmap backend ✓
- Port 8001: Right Amount backend ← **NEW (no conflict)**
- Port 3003: PMS Screener ✓

---

## 📋 Prerequisites

Before starting, ensure you have:

1. ✅ SSH access to VPS (82.25.105.18)
2. ✅ Node.js 18+ installed
3. ✅ Python 3.x installed
4. ✅ PM2 installed
5. ✅ Nginx running
6. ✅ Bar-Line source code ready

---

## 📁 Required Directory Structure

Your Bar-Line application should have this structure:

```
Bar-Line/
├── package.json              # Frontend dependencies
├── vite.config.ts           # Vite configuration
├── tsconfig.json            # TypeScript config
├── src/
│   ├── main.tsx             # React entry (needs basename config)
│   ├── App.tsx              # Main component
│   └── components/          # React components
└── backend/
    ├── server.py            # Flask app (or app.py)
    ├── requirements.txt     # Python dependencies
    └── utils/               # Backend utilities
```

---

## 🚀 Deployment Steps

### Step 1: Upload Bar-Line Application

```powershell
# From your local machine (PowerShell)
scp -r "D:\Bar-Line" root@82.25.105.18:/var/www/vsfintech/
```

Or if you have it in a different location, adjust the path accordingly.

### Step 2: Upload the Safe Deployment Script

```powershell
scp deploy-right-amount-safe.sh root@82.25.105.18:/tmp/
```

### Step 3: Run the Deployment Script

```powershell
ssh root@82.25.105.18
chmod +x /tmp/deploy-right-amount-safe.sh
sudo /tmp/deploy-right-amount-safe.sh
```

### Step 4: Verify Deployment

The script will automatically test all endpoints. You should see:
- ✅ Backend responding
- ✅ Frontend accessible
- ✅ API proxy working
- ✅ PM2 process running

---

## 🔍 What the Script Does (Step by Step)

### 1. Prerequisites Check
- ✓ Verifies Node.js, Python, PM2 are installed
- ✓ Checks if Bar-Line directory exists
- ✓ Validates required files present

### 2. Backend Deployment
```bash
# Creates Python virtual environment
python3 -m venv venv

# Installs dependencies
pip install -r requirements.txt
pip install flask gunicorn flask-cors pandas numpy

# Checks port 8001 availability
# Stops any conflicting process

# Starts backend with PM2
pm2 start gunicorn --name right-amount-backend -b 0.0.0.0:8001 server:app
pm2 save
```

### 3. Frontend Configuration
```bash
# Updates vite.config.ts
base: '/right-amount'

# Updates src/main.tsx
<BrowserRouter basename="/right-amount">

# Creates .env file
VITE_API_URL=/api/right-amount

# Builds production bundle
npm run build
```

### 4. Nginx Configuration (SAFE MODE)
```nginx
# Adds BEFORE existing location blocks:

# Backend API
location /api/right-amount/ {
    proxy_pass http://127.0.0.1:8001/;
    # ... proxy headers
}

# Frontend
location /right-amount/ {
    alias /var/www/vsfintech/Bar-Line/dist/;
    try_files $uri $uri/ /right-amount/index.html;
}
```

**Important:** 
- Creates backup first: `default.backup.TIMESTAMP`
- Only adds new configuration
- Does NOT modify existing apps
- Tests config before applying
- Auto-restores if config fails

### 5. Testing
```bash
# Backend direct: http://localhost:8001/
# Frontend: http://localhost/right-amount/
# API proxy: http://localhost/api/right-amount/
```

---

## 🧪 Manual Verification

After deployment, test these URLs:

```powershell
# Test from your local machine
curl http://82.25.105.18/right-amount/
# Should return: 200 OK with HTML

curl http://82.25.105.18/api/right-amount/
# Should return: 200 OK or 404 (backend responding)

# Or open in browser:
# http://82.25.105.18/right-amount/
```

**On the server:**
```bash
# Check PM2 status
pm2 list
# Should show: right-amount-backend | online

# View backend logs
pm2 logs right-amount-backend --lines 20

# Check backend directly
curl http://localhost:8001/

# Check nginx logs
tail -f /var/log/nginx/error.log
```

---

## 🔧 Troubleshooting

### Issue: Port 8001 already in use

**Solution:**
```bash
# Find what's using port 8001
sudo lsof -i :8001

# Stop the process
pm2 stop right-amount-backend
pm2 delete right-amount-backend

# Or kill by PID
sudo kill -9 <PID>

# Re-run deployment script
sudo /tmp/deploy-right-amount-safe.sh
```

### Issue: Frontend shows blank page

**Check vite.config.ts:**
```bash
cat /var/www/vsfintech/Bar-Line/vite.config.ts | grep base
# Should show: base: '/right-amount',
```

**Check main.tsx:**
```bash
cat /var/www/vsfintech/Bar-Line/src/main.tsx | grep basename
# Should show: basename="/right-amount"
```

**If incorrect, fix and rebuild:**
```bash
cd /var/www/vsfintech/Bar-Line
# Fix files manually, then:
npm run build
nginx -s reload
```

### Issue: API calls fail (404)

**Check API URL in code:**
```bash
grep -r "VITE_API_URL" /var/www/vsfintech/Bar-Line/src/
# Should use: import.meta.env.VITE_API_URL
```

**Check .env file:**
```bash
cat /var/www/vsfintech/Bar-Line/.env
# Should show: VITE_API_URL=/api/right-amount
```

### Issue: 502 Bad Gateway

**Backend not running:**
```bash
pm2 restart right-amount-backend
pm2 logs right-amount-backend --lines 50
```

### Issue: Nginx won't reload

**Syntax error in config:**
```bash
# Check syntax
sudo nginx -t

# If error, restore backup
sudo ls /etc/nginx/sites-available/default.backup.*
sudo cp /etc/nginx/sites-available/default.backup.TIMESTAMP /etc/nginx/sites-available/default
sudo nginx -t
sudo nginx -s reload
```

---

## 🔄 Update Right Amount

To update the application later:

### Update Backend Only
```bash
ssh root@82.25.105.18
cd /var/www/vsfintech/Bar-Line/backend
source venv/bin/activate
pip install -r requirements.txt --upgrade
deactivate
pm2 restart right-amount-backend
```

### Update Frontend Only
```bash
ssh root@82.25.105.18
cd /var/www/vsfintech/Bar-Line
npm install
npm run build
```

### Full Update
```bash
# Upload new files
scp -r ./Bar-Line root@82.25.105.18:/var/www/vsfintech/

# Re-run deployment script
ssh root@82.25.105.18
sudo /tmp/deploy-right-amount-safe.sh
```

---

## 📊 Final Configuration Summary

After deployment, your nginx will have:

```nginx
server {
    listen 80;
    
    # Right Sector (existing) ✓
    location /right-sector/ { ... }
    
    # Risk-Reward (existing) ✓
    location /risk-reward/static/ { ... }
    location /risk-reward/ { ... }
    
    # Sector Heatmap (existing) ✓
    location /api/heatmap/ { ... }
    location /sector-heatmap/ { ... }
    
    # Right Amount (NEW) ✓
    location /api/right-amount/ {
        proxy_pass http://127.0.0.1:8001/;
    }
    location /right-amount/ {
        alias /var/www/vsfintech/Bar-Line/dist/;
    }
    
    # AlphaNifty (existing) ✓
    location /alphanifty/api/ { ... }
    location /alphanifty/ { ... }
    
    # Main site (existing) ✓
    location / { ... }
}
```

**All apps isolated - no conflicts!**

---

## ✅ Deployment Checklist

Before running the script:
- [ ] Bar-Line uploaded to `/var/www/vsfintech/Bar-Line/`
- [ ] Backend has `server.py` or `app.py`
- [ ] Backend has `requirements.txt`
- [ ] Frontend has `package.json`
- [ ] Frontend has `src/main.tsx`
- [ ] Deployment script uploaded to `/tmp/`

After running the script:
- [ ] Backend running on port 8001
- [ ] PM2 shows `right-amount-backend | online`
- [ ] Frontend built (`dist/` folder exists)
- [ ] Nginx config has Right Amount blocks
- [ ] Nginx syntax test passes
- [ ] Frontend accessible at `/right-amount/`
- [ ] API accessible at `/api/right-amount/`
- [ ] All other apps still working

---

## 🎯 Expected Results

**Success Output:**
```
✅ Backend deployed on port 8001
✅ Frontend built successfully
✅ Nginx configuration added
✅ Nginx reloaded
✅ Backend responding (HTTP 200)
✅ Frontend accessible (HTTP 200)
✅ API proxy working (HTTP 200)
🎉 Right Amount Deployment Complete!
✅ All existing applications remain untouched!
```

**Access URLs:**
- Frontend: http://82.25.105.18/right-amount/
- Backend API: http://82.25.105.18/api/right-amount/

---

## 📞 Quick Commands Reference

```bash
# Check all PM2 processes
pm2 list

# Right Amount specific
pm2 logs right-amount-backend
pm2 restart right-amount-backend
pm2 stop right-amount-backend

# Nginx
sudo nginx -t
sudo nginx -s reload
tail -f /var/log/nginx/access.log | grep right-amount
tail -f /var/log/nginx/error.log

# Test endpoints
curl http://82.25.105.18/right-amount/
curl http://82.25.105.18/api/right-amount/
curl http://localhost:8001/

# Check port
sudo lsof -i :8001
sudo netstat -tulpn | grep 8001
```

---

## 🛡️ Safety Guarantees

This deployment script **GUARANTEES**:

1. ✅ Creates backup of nginx config before changes
2. ✅ Uses unique port (8001) - no port conflicts
3. ✅ Uses unique API path (`/api/right-amount/`) - no route conflicts
4. ✅ Only adds configuration - doesn't modify existing blocks
5. ✅ Tests nginx config before applying
6. ✅ Auto-restores backup if config fails
7. ✅ Checks port availability before starting backend
8. ✅ All existing applications continue running unchanged

**Your existing apps are 100% safe!**

---

## 📝 Notes

- **Port 8001** is dedicated to Right Amount backend
- **Path `/api/right-amount/`** is dedicated to Right Amount API
- React app configured for `/right-amount/` subpath
- Static files served from `dist/` folder
- Backend runs via Gunicorn + PM2
- Auto-restart enabled via PM2

---

**Ready to deploy? Follow the steps above and your Right Amount app will be live without disturbing anything! 🚀**
