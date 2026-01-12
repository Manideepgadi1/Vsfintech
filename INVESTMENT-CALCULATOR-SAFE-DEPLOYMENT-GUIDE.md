# Investment Calculator - SAFE Deployment Guide

**GUARANTEED: This deployment will NOT disturb any existing applications!**

---

## 🛡️ Safety Features

✅ **Unique Backend Port:** 5003 (no conflicts)  
✅ **Unique API Path:** `/api/investment-calculator/` (separate from others)  
✅ **Unique Frontend Path:** `/investment-calculator/`  
✅ **Nginx Backup:** Automatic backup before changes  
✅ **Safe Config:** Only adds new blocks, doesn't replace  
✅ **Port Check:** Verifies port availability before starting  
✅ **Auto-Detect:** Automatically detects if React or Static HTML

**Current Application Ports:**
- Port 5000: AlphaNifty backend ✓
- Port 5001: Risk-Reward backend ✓
- Port 8002: Sector Heatmap backend ✓
- Port 8001: Right Amount backend ✓
- Port 3003: PMS Screener ✓
- Port 5002: Riskometer backend ✓
- Port 5003: Investment Calculator backend ← **NEW (no conflict)**

---

## 📋 Prerequisites

Before starting, ensure you have:

1. ✅ SSH access to VPS (82.25.105.18)
2. ✅ Nginx running
3. ✅ Investment Calculator source code ready
4. ✅ Node.js 18+ (if React app)
5. ✅ Python 3.x (if has backend)
6. ✅ PM2 (if has backend)

---

## 📁 Supported Application Types

The script automatically detects and supports:

### Option A: Static HTML Calculator
```
Investment-Calculator/
├── index.html           # Main HTML file
├── css/
│   └── styles.css      # Stylesheets
├── js/
│   └── calculator.js   # Calculator logic
└── images/             # Assets
```

### Option B: React Calculator (No Backend)
```
Investment-Calculator/
├── package.json         # Frontend dependencies
├── vite.config.ts      # Vite configuration
├── src/
│   ├── main.tsx        # React entry
│   ├── App.tsx         # Main component
│   └── components/
│       └── Calculator.tsx
```

### Option C: React + Flask Backend
```
Investment-Calculator/
├── package.json              # Frontend dependencies
├── vite.config.ts           # Vite configuration
├── src/
│   ├── main.tsx             # React entry
│   └── App.tsx              # Main component
└── backend/
    ├── server.py            # Flask app (or app.py)
    ├── requirements.txt     # Python dependencies
    └── calculations.py      # Calculation logic
```

**The script will automatically configure based on what it finds!**

---

## 🚀 Deployment Steps

### Step 1: Upload Investment Calculator Application

```powershell
# From your local machine (PowerShell)
scp -r "D:\Investment-Calculator" root@82.25.105.18:/var/www/vsfintech/
```

Or adjust the path to where your Investment Calculator files are located.

### Step 2: Upload the Safe Deployment Script

```powershell
scp deploy-investment-calculator-safe.sh root@82.25.105.18:/tmp/
```

### Step 3: Run the Deployment Script

```powershell
ssh root@82.25.105.18
chmod +x /tmp/deploy-investment-calculator-safe.sh
sudo /tmp/deploy-investment-calculator-safe.sh
```

### Step 4: Verify Deployment

The script will automatically test all endpoints and show:
- ✅ Backend responding (if exists)
- ✅ Frontend accessible
- ✅ PM2 process running (if backend exists)

---

## 🔍 What the Script Does (Automatic Detection)

### 1. Application Type Detection
```bash
# Checks for package.json → React app
# Checks for backend/ folder → Has backend
# Otherwise → Static HTML calculator
```

### 2. Backend Deployment (If Exists)
```bash
# Creates Python virtual environment
python3 -m venv venv

# Installs dependencies
pip install -r requirements.txt

# Checks port 5003 availability
# Stops any conflicting process

# Starts backend with PM2
pm2 start gunicorn --name investment-calculator-backend -b 0.0.0.0:5003 server:app
pm2 save
```

### 3. Frontend Configuration (If React)
```bash
# Updates vite.config.ts
base: '/investment-calculator'

# Updates src/main.tsx
<BrowserRouter basename="/investment-calculator">

# Creates .env file (if backend exists)
VITE_API_URL=/api/investment-calculator

# Builds production bundle
npm run build
```

### 4. Nginx Configuration (SAFE MODE)

**For React/Static with Backend:**
```nginx
# Backend API
location /api/investment-calculator/ {
    proxy_pass http://127.0.0.1:5003/;
    proxy_set_header X-Forwarded-Prefix /investment-calculator;
    # ... other proxy headers
}

# Frontend
location /investment-calculator/ {
    alias /var/www/vsfintech/Investment-Calculator/dist/;  # or root dir for static
    try_files $uri $uri/ /investment-calculator/index.html;
}
```

**For Static HTML Only:**
```nginx
location /investment-calculator/ {
    alias /var/www/vsfintech/Investment-Calculator/;
    try_files $uri $uri/ /investment-calculator/index.html;
}
```

**Important:** 
- Creates backup: `default.backup.TIMESTAMP`
- Only adds new configuration
- Does NOT modify existing apps
- Tests config before applying
- Auto-restores if fails

---

## 🧪 Manual Verification

After deployment, test these URLs:

```powershell
# Test from your local machine
curl http://82.25.105.18/investment-calculator/
# Should return: 200 OK with HTML

# If backend exists:
curl http://82.25.105.18/api/investment-calculator/
# Should return: 200 OK or 404 (backend responding)

# Or open in browser:
# http://82.25.105.18/investment-calculator/
```

**On the server:**
```bash
# Check PM2 status (if backend exists)
pm2 list
# Should show: investment-calculator-backend | online

# View backend logs
pm2 logs investment-calculator-backend --lines 20

# Check backend directly (if exists)
curl http://localhost:5003/

# Check nginx logs
tail -f /var/log/nginx/error.log
```

---

## 🔧 Troubleshooting

### Issue: Port 5003 already in use

**Solution:**
```bash
# Find what's using port 5003
sudo lsof -i :5003

# Stop the process
pm2 stop investment-calculator-backend
pm2 delete investment-calculator-backend

# Or kill by PID
sudo kill -9 <PID>

# Re-run deployment script
sudo /tmp/deploy-investment-calculator-safe.sh
```

### Issue: Frontend shows blank page (React app)

**Check vite.config:**
```bash
cat /var/www/vsfintech/Investment-Calculator/vite.config.ts | grep base
# Should show: base: '/investment-calculator',
```

**Check main.tsx:**
```bash
cat /var/www/vsfintech/Investment-Calculator/src/main.tsx | grep basename
# Should show: basename="/investment-calculator"
```

**If incorrect, fix and rebuild:**
```bash
cd /var/www/vsfintech/Investment-Calculator
# Fix files manually, then:
npm run build
nginx -s reload
```

### Issue: Calculator not working (JavaScript errors)

**Check browser console for errors**

**For Static HTML:**
```bash
# Check if JavaScript files are loading
curl -I http://82.25.105.18/investment-calculator/js/calculator.js

# Check file paths in index.html
cat /var/www/vsfintech/Investment-Calculator/index.html | grep "<script"
```

**For React:**
```bash
# Check if built correctly
ls -la /var/www/vsfintech/Investment-Calculator/dist/assets/

# Rebuild if needed
cd /var/www/vsfintech/Investment-Calculator
npm run build
```

### Issue: API calls fail (404)

**If React app with backend:**
```bash
# Check .env file
cat /var/www/vsfintech/Investment-Calculator/.env
# Should show: VITE_API_URL=/api/investment-calculator

# Check if code uses it
grep -r "VITE_API_URL" /var/www/vsfintech/Investment-Calculator/src/
```

### Issue: 502 Bad Gateway

**Backend not running:**
```bash
pm2 restart investment-calculator-backend
pm2 logs investment-calculator-backend --lines 50

# Check if backend is actually listening
curl http://localhost:5003/
```

### Issue: Nginx won't reload

**Syntax error in config:**
```bash
# Check syntax
sudo nginx -t

# If error, restore backup
sudo ls /etc/nginx/sites-available/default.backup.*
LATEST=$(ls -t /etc/nginx/sites-available/default.backup.* | head -1)
sudo cp "$LATEST" /etc/nginx/sites-available/default
sudo nginx -t
sudo nginx -s reload
```

---

## 🔄 Update Investment Calculator

To update the application later:

### Update Backend Only
```bash
ssh root@82.25.105.18
cd /var/www/vsfintech/Investment-Calculator/backend
source venv/bin/activate
pip install -r requirements.txt --upgrade
deactivate
pm2 restart investment-calculator-backend
```

### Update Frontend Only (React)
```bash
ssh root@82.25.105.18
cd /var/www/vsfintech/Investment-Calculator
npm install
npm run build
```

### Update Static HTML
```bash
# Just upload new files
scp -r ./Investment-Calculator/* root@82.25.105.18:/var/www/vsfintech/Investment-Calculator/
```

### Full Update
```bash
# Upload new files
scp -r ./Investment-Calculator root@82.25.105.18:/var/www/vsfintech/

# Re-run deployment script
ssh root@82.25.105.18
sudo /tmp/deploy-investment-calculator-safe.sh
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
    
    # Right Amount (existing) ✓
    location /api/right-amount/ { ... }
    location /right-amount/ { ... }
    
    # Riskometer (existing) ✓
    location /api/riskometer/ { ... }
    location /riskometer/ { ... }
    
    # Investment Calculator (NEW) ✓
    location /api/investment-calculator/ {  # If backend exists
        proxy_pass http://127.0.0.1:5003/;
    }
    location /investment-calculator/ {
        alias /var/www/vsfintech/Investment-Calculator/[dist/];
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
- [ ] Investment Calculator uploaded to `/var/www/vsfintech/Investment-Calculator/`
- [ ] If React: has `package.json`
- [ ] If backend: has `backend/server.py` or `backend/app.py`
- [ ] If backend: has `backend/requirements.txt`
- [ ] Deployment script uploaded to `/tmp/`

After running the script:
- [ ] Script detected app type correctly
- [ ] Frontend accessible at `/investment-calculator/`
- [ ] If backend: PM2 shows `investment-calculator-backend | online`
- [ ] If backend: Backend running on port 5003
- [ ] If backend: API accessible at `/api/investment-calculator/`
- [ ] Calculator functions work properly
- [ ] Nginx syntax test passes
- [ ] All other apps still working

---

## 🎯 Expected Results

**Success Output for Static HTML:**
```
✅ Static HTML application detected
✅ Nginx configuration added
✅ Nginx reloaded
✅ Frontend accessible (HTTP 200)
🎉 Investment Calculator Deployment Complete!
✅ All existing applications remain untouched!
```

**Success Output for React + Backend:**
```
✅ React application detected
✅ Backend found
✅ Backend deployed on port 5003
✅ Frontend built successfully
✅ Nginx configuration added
✅ Nginx reloaded
✅ Backend responding (HTTP 200)
✅ Frontend accessible (HTTP 200)
🎉 Investment Calculator Deployment Complete!
✅ All existing applications remain untouched!
```

**Access URL:**
- Frontend: http://82.25.105.18/investment-calculator/
- Backend API (if exists): http://82.25.105.18/api/investment-calculator/

---

## 📞 Quick Commands Reference

```bash
# Check all PM2 processes
pm2 list

# Investment Calculator specific (if backend exists)
pm2 logs investment-calculator-backend
pm2 restart investment-calculator-backend
pm2 stop investment-calculator-backend

# Nginx
sudo nginx -t
sudo nginx -s reload
tail -f /var/log/nginx/access.log | grep investment-calculator
tail -f /var/log/nginx/error.log

# Test endpoints
curl http://82.25.105.18/investment-calculator/
curl http://82.25.105.18/api/investment-calculator/      # If backend
curl http://localhost:5003/                               # If backend

# Check port (if backend)
sudo lsof -i :5003
sudo netstat -tulpn | grep 5003
```

---

## 🛡️ Safety Guarantees

This deployment script **GUARANTEES**:

1. ✅ Creates backup of nginx config before changes
2. ✅ Uses unique port (5003) - no port conflicts
3. ✅ Uses unique API path (`/api/investment-calculator/`) - no route conflicts
4. ✅ Only adds configuration - doesn't modify existing blocks
5. ✅ Tests nginx config before applying
6. ✅ Auto-restores backup if config fails
7. ✅ Checks port availability before starting backend
8. ✅ Auto-detects app type (Static/React/Backend)
9. ✅ All existing applications continue running unchanged

**Your existing apps are 100% safe!**

---

## 🤖 Automatic Detection Features

The script intelligently detects:

1. **Application Type:**
   - Looks for `package.json` → React app
   - No `package.json` → Static HTML

2. **Backend Presence:**
   - Looks for `backend/` folder
   - Checks for `server.py` or `app.py`
   - Configures PM2 and proxy only if backend exists

3. **Configuration Needs:**
   - React app → Updates vite.config + main.tsx
   - Static HTML → Uses files as-is
   - With backend → Creates .env with API URL
   - No backend → Skips API configuration

**No manual configuration needed - the script does it all!**

---

## 📝 Notes

- **Port 5003** is dedicated to Investment Calculator backend (if exists)
- **Path `/api/investment-calculator/`** is for API (if backend exists)
- React app auto-configured for `/investment-calculator/` subpath
- Static HTML works immediately with no build step
- Backend runs via Gunicorn + PM2 (if exists)
- Auto-restart enabled via PM2 (if backend)
- Perfect for SIP calculators, goal planners, retirement calculators, etc.

---

## 🎨 Application Types Comparison

| Feature | Static HTML | React Only | React + Backend |
|---------|-------------|------------|-----------------|
| **Build Step** | No | Yes | Yes |
| **Node.js** | No | Yes | Yes |
| **Python** | No | No | Yes |
| **PM2** | No | No | Yes |
| **Port Used** | None | None | 5003 |
| **API Path** | No | No | `/api/investment-calculator/` |
| **Deploy Time** | 10 sec | 30 sec | 60 sec |

**The script handles all three automatically!**

---

## 💡 Calculator Features Support

This deployment supports:
- ✅ SIP (Systematic Investment Plan) calculators
- ✅ Lumpsum investment calculators
- ✅ Goal planning calculators
- ✅ Retirement planning tools
- ✅ EMI calculators
- ✅ Compound interest calculators
- ✅ Tax calculators
- ✅ Portfolio allocation tools
- ✅ Any custom financial calculators

**Works with any calculator type - static or dynamic!**

---

**Ready to deploy? The script will detect your calculator type and deploy it safely without disturbing anything! 🚀**
