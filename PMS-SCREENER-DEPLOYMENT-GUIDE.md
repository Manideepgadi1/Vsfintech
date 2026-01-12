# PMS Screener (Fundscreener) - Complete Deployment Guide

**Application:** PMS Screener - Portfolio Management Services Fund Screening Tool  
**Type:** Flask Backend + HTML/JS Frontend  
**Port:** 3003  
**Backend Framework:** Flask + Gunicorn  
**Data:** 556 Mutual Funds

---

## 🎯 Overview

PMS Screener is a fund screening application that allows users to analyze and compare 556 mutual funds based on various parameters.

**Access URLs:**
- Direct Backend: http://82.25.105.18:3003
- Via Main Site: http://82.25.105.18/pms-screener/

---

## 📋 Prerequisites

Before deployment, ensure you have:

1. ✅ SSH access to VPS (82.25.105.18)
2. ✅ Python 3.x installed
3. ✅ PM2 installed (for process management)
4. ✅ Nginx installed and running
5. ✅ PMS Screener source code

---

## 📁 Required Application Structure

The fundscreener application should have this structure:

```
fundscreener/
├── app.py                 # Main Flask application (required)
├── requirements.txt       # Python dependencies (recommended)
├── static/               # Static files (CSS, JS, images)
│   ├── css/
│   ├── js/
│   └── data/
│       └── funds.json    # 556 funds data
├── templates/            # HTML templates
│   └── index.html
├── venv/                 # Virtual environment (created during deployment)
└── README.md             # Optional documentation
```

**Minimum Required Files:**
- `app.py` - Flask application entry point
- `requirements.txt` - Dependencies list
- Static/template files for the frontend

---

## 🚀 Deployment Methods

### Method 1: Automated Deployment Script (Recommended)

**Step 1:** Upload the deployment script to your VPS

```bash
# From your local machine, upload the script
scp deploy-pms-screener.sh root@82.25.105.18:/tmp/
```

**Step 2:** Upload your fundscreener application

```bash
# Option A: Using SCP
scp -r ./fundscreener root@82.25.105.18:/var/www/vsfintech/

# Option B: Using Git (if in repository)
ssh root@82.25.105.18
cd /var/www/vsfintech
git clone <FUNDSCREENER_REPO_URL> fundscreener
```

**Step 3:** Run the deployment script

```bash
ssh root@82.25.105.18
chmod +x /tmp/deploy-pms-screener.sh
sudo /tmp/deploy-pms-screener.sh
```

The script will automatically:
- ✅ Check prerequisites
- ✅ Create Python virtual environment
- ✅ Install dependencies
- ✅ Configure PM2 process manager
- ✅ Set up Nginx reverse proxy
- ✅ Set correct permissions
- ✅ Test the deployment

---

### Method 2: Manual Step-by-Step Deployment

#### Step 1: Upload Application Files

```bash
# SSH to VPS
ssh root@82.25.105.18

# Create directory
mkdir -p /var/www/vsfintech/fundscreener

# Upload files (from local machine in another terminal)
scp -r ./fundscreener/* root@82.25.105.18:/var/www/vsfintech/fundscreener/
```

#### Step 2: Set Up Python Virtual Environment

```bash
cd /var/www/vsfintech/fundscreener

# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip
```

#### Step 3: Install Dependencies

```bash
# If you have requirements.txt
pip install -r requirements.txt

# Or install manually
pip install flask gunicorn pandas numpy flask-cors
```

Create a `requirements.txt` if you don't have one:

```txt
Flask==3.0.0
gunicorn==21.2.0
pandas==2.1.3
numpy==1.26.2
flask-cors==4.0.0
```

#### Step 4: Verify Flask Application

Your `app.py` should look something like this:

```python
from flask import Flask, render_template, jsonify
import json
import os

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/funds')
def get_funds():
    # Load and return funds data
    with open('static/data/funds.json', 'r') as f:
        funds = json.load(f)
    return jsonify(funds)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3003, debug=False)
```

Test the application:

```bash
# Still in virtual environment
python app.py

# In another terminal, test:
curl http://localhost:3003/
```

Press `Ctrl+C` to stop the test server.

#### Step 5: Configure PM2 Process Manager

```bash
# Deactivate virtual environment first
deactivate

# Remove old PM2 process if exists
pm2 stop pms-screener 2>/dev/null || true
pm2 delete pms-screener 2>/dev/null || true

# Start with PM2 using gunicorn
pm2 start /var/www/vsfintech/fundscreener/venv/bin/gunicorn \
    --name pms-screener \
    --cwd /var/www/vsfintech/fundscreener \
    --interpreter none \
    -- -w 2 -b 0.0.0.0:3003 app:app

# Save PM2 configuration
pm2 save

# Enable PM2 to start on boot
pm2 startup systemd
```

#### Step 6: Configure Nginx Reverse Proxy

Edit the main Nginx configuration:

```bash
sudo nano /etc/nginx/sites-available/vsfintech.conf
```

Add this location block inside the server block:

```nginx
# PMS Screener (fundscreener)
location /pms-screener/ {
    proxy_pass http://localhost:3003/;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    
    # Timeout settings
    proxy_connect_timeout 60s;
    proxy_send_timeout 60s;
    proxy_read_timeout 60s;
}

location /pms-screener {
    return 301 /pms-screener/;
}
```

Test and reload Nginx:

```bash
# Test configuration
sudo nginx -t

# If successful, reload
sudo systemctl reload nginx
```

#### Step 7: Set Permissions

```bash
sudo chown -R www-data:www-data /var/www/vsfintech/fundscreener
sudo chmod -R 755 /var/www/vsfintech/fundscreener
```

#### Step 8: Test Deployment

```bash
# Test backend directly
curl http://localhost:3003/

# Test through Nginx proxy
curl http://localhost/pms-screener/

# Check PM2 status
pm2 status

# View logs
pm2 logs pms-screener --lines 50
```

---

## 🔍 Verification & Testing

### Check Service Status

```bash
# PM2 process status
pm2 status

# Expected output:
# │ pms-screener │ online │ 0 │ none │ ...
```

### Check Application Logs

```bash
# View live logs
pm2 logs pms-screener

# View last 100 lines
pm2 logs pms-screener --lines 100

# View error logs only
pm2 logs pms-screener --err
```

### Test HTTP Endpoints

```bash
# Test home page
curl -I http://localhost:3003/

# Test through Nginx
curl -I http://82.25.105.18/pms-screener/

# Test API endpoint (if you have one)
curl http://localhost:3003/api/funds | jq
```

### Check Port Availability

```bash
# Verify port 3003 is listening
sudo netstat -tulpn | grep 3003

# Expected output:
# tcp  0  0  0.0.0.0:3003  0.0.0.0:*  LISTEN  <PID>/gunicorn
```

---

## 🔧 Troubleshooting

### Issue: Port 3003 Already in Use

```bash
# Find process using port 3003
sudo lsof -i :3003

# Kill the process
sudo kill -9 <PID>

# Restart PM2 service
pm2 restart pms-screener
```

### Issue: Module Not Found Error

```bash
# Reinstall dependencies
cd /var/www/vsfintech/fundscreener
source venv/bin/activate
pip install -r requirements.txt --force-reinstall
deactivate

# Restart service
pm2 restart pms-screener
```

### Issue: 502 Bad Gateway

This means Nginx can't connect to the backend:

```bash
# Check if backend is running
pm2 status

# Check backend logs
pm2 logs pms-screener

# Restart backend
pm2 restart pms-screener

# Wait a few seconds and test
sleep 5
curl http://localhost:3003/
```

### Issue: 404 Not Found

```bash
# Check Flask routes
cd /var/www/vsfintech/fundscreener
source venv/bin/activate
python -c "from app import app; print(app.url_map)"

# Check Nginx configuration
sudo nginx -t
cat /etc/nginx/sites-available/vsfintech.conf | grep pms-screener
```

### Issue: Static Files Not Loading

```bash
# Check file permissions
ls -la /var/www/vsfintech/fundscreener/static/

# Fix permissions
sudo chown -R www-data:www-data /var/www/vsfintech/fundscreener
sudo chmod -R 755 /var/www/vsfintech/fundscreener

# Verify Flask is serving static files correctly
# Check app.py for static_folder configuration
```

### Issue: Data Not Loading (556 Funds)

```bash
# Check if data file exists
ls -la /var/www/vsfintech/fundscreener/static/data/funds.json

# Verify JSON is valid
python3 -m json.tool /var/www/vsfintech/fundscreener/static/data/funds.json > /dev/null

# Check Flask route for data API
curl http://localhost:3003/api/funds
```

---

## 📊 Monitoring & Maintenance

### View Real-time Logs

```bash
# PM2 logs
pm2 logs pms-screener --lines 100

# Nginx access logs
sudo tail -f /var/log/nginx/access.log | grep pms-screener

# Nginx error logs
sudo tail -f /var/log/nginx/error.log
```

### Check Resource Usage

```bash
# PM2 monitoring dashboard
pm2 monit

# Memory and CPU usage
pm2 status
```

### Restart Service

```bash
# Restart PM2 service
pm2 restart pms-screener

# Restart with zero downtime
pm2 reload pms-screener
```

### Update Application

```bash
# Method 1: Git pull (if using Git)
cd /var/www/vsfintech/fundscreener
git pull origin main
pm2 restart pms-screener

# Method 2: Upload new files
# Upload via SCP, then:
pm2 restart pms-screener

# Method 3: Update dependencies
cd /var/www/vsfintech/fundscreener
source venv/bin/activate
pip install -r requirements.txt --upgrade
deactivate
pm2 restart pms-screener
```

---

## 🔗 Integration with Main Platform

The PMS Screener is integrated into the main VS Fintech Platform:

### Frontend Integration

**Fundoscope Page** (`frontend/src/pages/tools/FundoscopePage.tsx`):
```typescript
// Link to PMS Screener
href="http://82.25.105.18/pms-screener"
```

**Navbar** (`frontend/src/components/Navbar.tsx`):
```typescript
{ name: 'PMS Screener', path: '/tools/fundscreener2' }
```

### Backend API Integration

If your main platform needs to communicate with PMS Screener:

```javascript
// Example API call from frontend
const response = await fetch('http://82.25.105.18/pms-screener/api/funds');
const funds = await response.json();
```

---

## 📝 Configuration Files

### PM2 Ecosystem File

Add to `/var/www/vsfintech/pm2-ecosystem-all-apps.json`:

```json
{
  "name": "pms-screener",
  "cwd": "/var/www/vsfintech/fundscreener",
  "script": "venv/bin/gunicorn",
  "args": "-w 2 -b 0.0.0.0:3003 app:app",
  "interpreter": "none",
  "autorestart": true,
  "watch": false
}
```

### Systemd Service (Alternative to PM2)

If you prefer systemd over PM2:

```bash
sudo nano /etc/systemd/system/pms-screener.service
```

```ini
[Unit]
Description=PMS Screener Flask Application
After=network.target

[Service]
Type=notify
User=www-data
Group=www-data
WorkingDirectory=/var/www/vsfintech/fundscreener
Environment="PATH=/var/www/vsfintech/fundscreener/venv/bin"
ExecStart=/var/www/vsfintech/fundscreener/venv/bin/gunicorn -w 2 -b 0.0.0.0:3003 app:app
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable pms-screener
sudo systemctl start pms-screener
sudo systemctl status pms-screener
```

---

## ✅ Deployment Checklist

- [ ] Application files uploaded to `/var/www/vsfintech/fundscreener/`
- [ ] `app.py` and `requirements.txt` present
- [ ] Python virtual environment created (`venv/`)
- [ ] Dependencies installed successfully
- [ ] Flask application tested locally
- [ ] PM2 process `pms-screener` running
- [ ] Nginx configuration added for `/pms-screener/`
- [ ] Nginx config tested (`nginx -t`)
- [ ] Nginx reloaded successfully
- [ ] File permissions set correctly (www-data:www-data, 755)
- [ ] Port 3003 responding to requests
- [ ] Nginx proxy working at `/pms-screener/`
- [ ] 556 funds data loading correctly
- [ ] PM2 saved and set to auto-start
- [ ] Logs checked for errors
- [ ] Integration with main platform verified

---

## 🎯 Quick Reference Commands

```bash
# Status
pm2 status
pm2 info pms-screener

# Logs
pm2 logs pms-screener
pm2 logs pms-screener --lines 100

# Control
pm2 restart pms-screener
pm2 stop pms-screener
pm2 start pms-screener
pm2 reload pms-screener  # Zero-downtime restart

# Monitoring
pm2 monit

# Nginx
sudo nginx -t
sudo systemctl reload nginx
sudo systemctl status nginx

# Test
curl http://localhost:3003/
curl http://82.25.105.18/pms-screener/
```

---

## 📞 Support & Next Steps

**Deployment Status:** Ready for deployment  
**Expected Result:** PMS Screener accessible at http://82.25.105.18/pms-screener/

**Next Steps:**
1. Prepare your fundscreener application code
2. Upload to VPS at `/var/www/vsfintech/fundscreener/`
3. Run the deployment script or follow manual steps
4. Verify 556 funds are loading correctly
5. Test integration with main platform
6. Update DEPLOYMENT-SUMMARY.md with new deployment date

---

**Ready to deploy?** Run the automated script or follow the manual steps above!
