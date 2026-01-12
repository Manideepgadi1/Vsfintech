# Risk-Reward - Complete Deployment Guide

**Application:** Risk-Reward Analysis Tool  
**Type:** Flask Backend Application  
**Port:** 5000  
**Framework:** Flask + Gunicorn  
**Purpose:** Risk-reward ratio analysis for investment decisions

---

## 🎯 Overview

Risk-Reward is a Flask-based analysis tool that helps users:
- Calculate risk-reward ratios
- Analyze investment opportunities
- Make data-driven decisions
- Evaluate portfolio risk profiles

**Access URLs:**
- Direct: http://82.25.105.18:5000
- Via Main Site: http://82.25.105.18/risk-reward/

---

## 📋 Prerequisites

1. ✅ SSH access to VPS (82.25.105.18)
2. ✅ Python 3.x installed
3. ✅ PM2 installed (for process management)
4. ✅ Nginx installed and running
5. ✅ Risk-Reward source code

---

## 📁 Required Application Structure

```
Risk-Reward/
├── app.py                # Main Flask application (required)
├── requirements.txt      # Python dependencies
├── venv/                # Virtual environment (created during deployment)
├── static/              # Static files (CSS, JS, images)
│   ├── css/
│   ├── js/
│   └── images/
├── templates/           # HTML templates
│   └── index.html
├── utils/              # Utility functions
│   ├── calculations.py
│   └── data_processing.py
└── README.md           # Documentation
```

**Minimum Required Files:**
- `app.py` - Flask application entry point
- `requirements.txt` - Dependencies list
- `templates/index.html` - Main page

---

## 🚀 Deployment Methods

### Method 1: Automated Deployment Script (Recommended)

**Step 1:** Upload the deployment script to your VPS

```bash
# From your local machine
scp deploy-risk-reward.sh root@82.25.105.18:/tmp/
```

**Step 2:** Upload your Risk-Reward application

```bash
# Option A: Using SCP
scp -r ./Risk-Reward root@82.25.105.18:/var/www/vsfintech/

# Option B: Using Git (if in repository)
ssh root@82.25.105.18
cd /var/www/vsfintech
git clone <RISK_REWARD_REPO_URL> Risk-Reward
```

**Step 3:** Run the deployment script

```bash
ssh root@82.25.105.18
chmod +x /tmp/deploy-risk-reward.sh
sudo /tmp/deploy-risk-reward.sh
```

The script will automatically:
- ✅ Check prerequisites (Python, PM2)
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
mkdir -p /var/www/vsfintech/Risk-Reward

# Upload files (from local machine in another terminal)
scp -r ./Risk-Reward/* root@82.25.105.18:/var/www/vsfintech/Risk-Reward/
```

#### Step 2: Set Up Python Virtual Environment

```bash
cd /var/www/vsfintech/Risk-Reward

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
pip install flask gunicorn flask-cors pandas numpy
```

**Sample requirements.txt:**
```txt
Flask==3.0.0
gunicorn==21.2.0
flask-cors==4.0.0
pandas==2.1.3
numpy==1.26.2
scipy==1.11.4
matplotlib==3.8.2
```

#### Step 4: Verify Flask Application

Sample `app.py` structure:

```python
from flask import Flask, render_template, request, jsonify
from flask_cors import CORS
import pandas as pd
import numpy as np

app = Flask(__name__)
CORS(app)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/calculate', methods=['POST'])
def calculate_risk_reward():
    try:
        data = request.json
        entry_price = float(data.get('entry_price', 0))
        stop_loss = float(data.get('stop_loss', 0))
        target_price = float(data.get('target_price', 0))
        
        # Calculate risk and reward
        risk = abs(entry_price - stop_loss)
        reward = abs(target_price - entry_price)
        
        # Calculate risk-reward ratio
        if risk > 0:
            ratio = reward / risk
        else:
            ratio = 0
        
        return jsonify({
            'success': True,
            'risk': risk,
            'reward': reward,
            'ratio': round(ratio, 2),
            'recommendation': 'Good' if ratio >= 2 else 'Moderate' if ratio >= 1 else 'Poor'
        })
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 400

@app.route('/health')
def health():
    return jsonify({'status': 'healthy', 'service': 'Risk-Reward'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
```

Test the application:

```bash
# Still in virtual environment
python app.py

# In another terminal, test:
curl http://localhost:5000/
curl http://localhost:5000/health
```

Press `Ctrl+C` to stop the test server.

#### Step 5: Configure PM2 Process Manager

```bash
# Deactivate virtual environment first
deactivate

# Remove old PM2 process if exists
pm2 stop risk-reward 2>/dev/null || true
pm2 delete risk-reward 2>/dev/null || true

# Start with PM2 using gunicorn
pm2 start /var/www/vsfintech/Risk-Reward/venv/bin/gunicorn \
    --name risk-reward \
    --cwd /var/www/vsfintech/Risk-Reward \
    --interpreter none \
    -- -w 2 -b 0.0.0.0:5000 app:app

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
# Risk-Reward Flask App
location /risk-reward {
    proxy_pass http://localhost:5000/;
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
sudo chown -R www-data:www-data /var/www/vsfintech/Risk-Reward
sudo chmod -R 755 /var/www/vsfintech/Risk-Reward
```

#### Step 8: Test Deployment

```bash
# Test backend directly
curl http://localhost:5000/
curl http://localhost:5000/health

# Test through Nginx proxy
curl http://localhost/risk-reward/
curl http://82.25.105.18/risk-reward/

# Check PM2 status
pm2 status

# View logs
pm2 logs risk-reward --lines 50
```

---

## 🔍 Verification & Testing

### Check Service Status

```bash
# PM2 process status
pm2 status

# Expected output:
# │ risk-reward │ online │ 0 │ none │ ...
```

### Check Application Logs

```bash
# View live logs
pm2 logs risk-reward

# View last 100 lines
pm2 logs risk-reward --lines 100

# View error logs only
pm2 logs risk-reward --err
```

### Test HTTP Endpoints

```bash
# Test home page
curl -I http://localhost:5000/

# Test health endpoint
curl http://localhost:5000/health

# Test through Nginx
curl -I http://82.25.105.18/risk-reward/

# Test API endpoint (if you have one)
curl -X POST http://localhost:5000/api/calculate \
  -H "Content-Type: application/json" \
  -d '{"entry_price":100,"stop_loss":95,"target_price":110}'
```

### Check Port Availability

```bash
# Verify port 5000 is listening
sudo netstat -tulpn | grep 5000

# Expected output:
# tcp  0  0  0.0.0.0:5000  0.0.0.0:*  LISTEN  <PID>/gunicorn
```

---

## 🔧 Troubleshooting

### Issue: Port 5000 Already in Use

```bash
# Find process using port 5000
sudo lsof -i :5000

# Kill the process
sudo kill -9 <PID>

# Restart PM2 service
pm2 restart risk-reward
```

### Issue: Module Not Found Error

```bash
# Reinstall dependencies
cd /var/www/vsfintech/Risk-Reward
source venv/bin/activate
pip install -r requirements.txt --force-reinstall
deactivate

# Restart service
pm2 restart risk-reward
```

### Issue: 502 Bad Gateway

This means Nginx can't connect to the backend:

```bash
# Check if backend is running
pm2 status

# Check backend logs
pm2 logs risk-reward

# Restart backend
pm2 restart risk-reward

# Wait a few seconds and test
sleep 5
curl http://localhost:5000/
```

### Issue: 404 Not Found

```bash
# Check Flask routes
cd /var/www/vsfintech/Risk-Reward
source venv/bin/activate
python -c "from app import app; print(app.url_map)"

# Check Nginx configuration
sudo nginx -t
cat /etc/nginx/sites-available/vsfintech.conf | grep risk-reward
```

### Issue: Static Files Not Loading

```bash
# Check file permissions
ls -la /var/www/vsfintech/Risk-Reward/static/

# Fix permissions
sudo chown -R www-data:www-data /var/www/vsfintech/Risk-Reward
sudo chmod -R 755 /var/www/vsfintech/Risk-Reward

# Verify Flask is serving static files correctly
# Check app.py for static_folder configuration
```

### Issue: CORS Errors

```bash
# Install flask-cors
cd /var/www/vsfintech/Risk-Reward
source venv/bin/activate
pip install flask-cors
deactivate

# Update app.py to include:
# from flask_cors import CORS
# CORS(app)

# Restart
pm2 restart risk-reward
```

---

## 📊 Monitoring & Maintenance

### View Real-time Logs

```bash
# PM2 logs
pm2 logs risk-reward --lines 100

# Nginx access logs
sudo tail -f /var/log/nginx/access.log | grep risk-reward

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
pm2 restart risk-reward

# Restart with zero downtime
pm2 reload risk-reward

# Stop service
pm2 stop risk-reward

# Start service
pm2 start risk-reward
```

### Update Application

```bash
# Method 1: Git pull (if using Git)
cd /var/www/vsfintech/Risk-Reward
git pull origin main
source venv/bin/activate
pip install -r requirements.txt --upgrade
deactivate
pm2 restart risk-reward

# Method 2: Upload new files
# Upload via SCP, then:
pm2 restart risk-reward

# Method 3: Update dependencies only
cd /var/www/vsfintech/Risk-Reward
source venv/bin/activate
pip install -r requirements.txt --upgrade
deactivate
pm2 restart risk-reward
```

---

## 🔗 Integration with Main Platform

Risk-Reward is integrated into the main VS Fintech Platform:

### Frontend Integration

**Homepage** (`frontend/src/pages/HomePage.tsx`):
```typescript
// Tool card linking to Risk-Reward
href="http://82.25.105.18/risk-reward"
```

**Fundoscope Page** (`frontend/src/pages/tools/FundoscopePage.tsx`):
```typescript
// Listed as tool #4
href="http://82.25.105.18/risk-reward"
```

### API Integration

If your main platform needs to call Risk-Reward API:

```javascript
// Example API call from frontend
const response = await fetch('http://82.25.105.18/risk-reward/api/calculate', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    entry_price: 100,
    stop_loss: 95,
    target_price: 110
  })
});
const result = await response.json();
```

---

## 📝 Configuration Files

### PM2 Ecosystem File

Add to `/var/www/vsfintech/pm2-ecosystem-all-apps.json`:

```json
{
  "name": "risk-reward",
  "cwd": "/var/www/vsfintech/Risk-Reward",
  "script": "venv/bin/gunicorn",
  "args": "-w 2 -b 0.0.0.0:5000 app:app",
  "interpreter": "none",
  "autorestart": true,
  "watch": false
}
```

Start from ecosystem file:
```bash
pm2 start pm2-ecosystem-all-apps.json --only risk-reward
```

### Systemd Service (Alternative to PM2)

If you prefer systemd over PM2:

```bash
sudo nano /etc/systemd/system/risk-reward.service
```

```ini
[Unit]
Description=Risk-Reward Flask Application
After=network.target

[Service]
Type=notify
User=www-data
Group=www-data
WorkingDirectory=/var/www/vsfintech/Risk-Reward
Environment="PATH=/var/www/vsfintech/Risk-Reward/venv/bin"
ExecStart=/var/www/vsfintech/Risk-Reward/venv/bin/gunicorn -w 2 -b 0.0.0.0:5000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable risk-reward
sudo systemctl start risk-reward
sudo systemctl status risk-reward
```

---

## ✅ Deployment Checklist

- [ ] Risk-Reward code uploaded to `/var/www/vsfintech/Risk-Reward/`
- [ ] `app.py` and `requirements.txt` present
- [ ] Python virtual environment created (`venv/`)
- [ ] Dependencies installed successfully
- [ ] Flask application tested locally
- [ ] PM2 process `risk-reward` running on port 5000
- [ ] Nginx configuration added for `/risk-reward` location
- [ ] Nginx config tested (`nginx -t`)
- [ ] Nginx reloaded successfully
- [ ] File permissions set correctly (www-data:www-data, 755)
- [ ] Port 5000 responding to requests
- [ ] Nginx proxy working at `/risk-reward/`
- [ ] Health endpoint responding
- [ ] API endpoints functional
- [ ] PM2 saved and set to auto-start
- [ ] Logs checked for errors
- [ ] Integration with main platform verified

---

## 🎯 Quick Reference Commands

```bash
# Status
pm2 status
pm2 info risk-reward

# Logs
pm2 logs risk-reward
pm2 logs risk-reward --lines 100

# Control
pm2 restart risk-reward
pm2 stop risk-reward
pm2 start risk-reward
pm2 reload risk-reward  # Zero-downtime restart

# Monitoring
pm2 monit

# Nginx
sudo nginx -t
sudo systemctl reload nginx
sudo systemctl status nginx

# Test
curl http://localhost:5000/
curl http://localhost:5000/health
curl http://82.25.105.18/risk-reward/

# Check port
sudo netstat -tulpn | grep 5000
sudo lsof -i :5000
```

---

## 📞 Support & Next Steps

**Deployment Status:** Ready for deployment  
**Expected Result:** Risk-Reward accessible at http://82.25.105.18/risk-reward/

**Next Steps:**
1. Prepare your Risk-Reward Flask application code
2. Upload to VPS at `/var/www/vsfintech/Risk-Reward/`
3. Run the deployment script or follow manual steps
4. Verify API endpoints are working
5. Test integration with main platform
6. Update DEPLOYMENT-SUMMARY.md with new deployment date

---

**Ready to deploy?** Run the automated script or follow the manual deployment steps!
