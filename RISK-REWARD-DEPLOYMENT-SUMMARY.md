# Risk-Reward Deployment - What Was Done

## Application Details
- **Type:** Flask application with templates and static files
- **Backend Port:** 5001 (changed from 5000 due to AlphaNifty conflict)
- **Directory:** `/var/www/vsfintech/Risk-Reward/`
- **Access URL:** http://82.25.105.18/risk-reward/

---

## Steps Performed

### 1. Backend Setup (Flask + Gunicorn + PM2)

```bash
cd /var/www/vsfintech/Risk-Reward

# Created Python virtual environment
python3 -m venv venv
source venv/bin/activate

# Installed dependencies
pip install -r requirements.txt
pip install flask gunicorn flask-cors pandas numpy

deactivate

# Started backend with PM2 on port 5001
pm2 start venv/bin/gunicorn \
    --name risk-reward-backend \
    --cwd /var/www/vsfintech/Risk-Reward \
    --interpreter none \
    -- -w 2 -b 0.0.0.0:5001 app:app

pm2 save
```

**Why port 5001?** Port 5000 was already taken by AlphaNifty backend.

### 2. Nginx Configuration

Added to `/etc/nginx/sites-available/default`:

```nginx
# Static files for Risk-Reward (served directly by nginx)
location /risk-reward/static/ {
    alias /var/www/vsfintech/Risk-Reward/static/;
    expires 1d;
    add_header Cache-Control "public, immutable";
}

# Risk-Reward Flask app (proxied to backend)
location /risk-reward/ {
    proxy_pass http://127.0.0.1:5001/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}

# Redirect /risk-reward to /risk-reward/
location /risk-reward {
    return 301 /risk-reward/;
}
```

**Key Points:**
1. **Static files location comes FIRST** - More specific match takes priority
2. **Static files served by nginx** - Better performance than proxying to Flask
3. **Flask app proxied** - Dynamic content handled by backend
4. **Trailing slash redirect** - Ensures consistent URLs

### 3. Tested and Verified

```bash
# Test backend directly
curl http://127.0.0.1:5001/
# Returns: 200 OK with HTML content

# Test via nginx
curl http://82.25.105.18/risk-reward/
# Returns: 200 OK with HTML content

# Test static files
curl http://82.25.105.18/risk-reward/static/styles.css
# Returns: CSS content

# Check PM2 status
pm2 list
# risk-reward-backend: online
```

---

## File Structure

```
/var/www/vsfintech/Risk-Reward/
├── app.py                 # Flask application (entry point)
├── requirements.txt       # Python dependencies
├── venv/                 # Virtual environment (created during deployment)
├── templates/            # Jinja2 HTML templates
│   ├── index.html       # Main page template
│   └── heatmap.html     # Heatmap view template
├── static/              # Static assets (CSS, JS, images)
│   ├── styles.css       # Main stylesheet
│   ├── script.js        # Main JavaScript
│   ├── heatmap.css      # Heatmap styles
│   └── heatmap.js       # Heatmap functionality
└── data.csv             # Data file for analysis
```

---

## How to Apply This to Risk-Return (Static HTML)

Since **Risk-Return is pure HTML** (no Flask backend), the setup is simpler:

### Risk-Return Nginx Configuration

```nginx
# Risk-Return - Static HTML Application
location /risk-return/ {
    alias /var/www/vsfintech/Risk-Return/;
    try_files $uri $uri/ /risk-return/index.html;
    index index.html;
    
    # Optional: Enable caching for better performance
    expires 1d;
    add_header Cache-Control "public, max-age=86400";
}

# Redirect /risk-return to /risk-return/
location /risk-return {
    return 301 /risk-return/;
}
```

### Risk-Return Deployment Steps

```bash
# 1. Upload files to server
scp -r ./Risk-Return root@82.25.105.18:/var/www/vsfintech/

# 2. Set permissions
ssh root@82.25.105.18
chmod -R 755 /var/www/vsfintech/Risk-Return
chown -R www-data:www-data /var/www/vsfintech/Risk-Return

# 3. Add nginx configuration (shown above)
# Edit: /etc/nginx/sites-available/default

# 4. Test and reload nginx
sudo nginx -t
sudo nginx -s reload

# 5. Test access
curl http://82.25.105.18/risk-return/
```

**No PM2, no Python, no backend needed!**

---

## Key Differences: Risk-Reward vs Risk-Return

| Aspect | Risk-Reward | Risk-Return |
|--------|-------------|-------------|
| **Type** | Flask App | Static HTML |
| **Backend** | Yes (port 5001) | No |
| **PM2 Process** | Yes (risk-reward-backend) | No |
| **Python/Venv** | Yes | No |
| **Dependencies** | flask, gunicorn, pandas, numpy | None |
| **Nginx Config** | Proxy to backend + static files | Direct file serving |
| **Templates** | Jinja2 templates in `templates/` | Plain HTML files |
| **Dynamic Content** | Yes (server-side) | No (client-side only) |
| **Deployment Complexity** | Medium | Low |

---

## Summary of Changes Made to Nginx

The complete nginx configuration now includes:

1. **Right Sector** - `/right-sector/` → static HTML
2. **Risk-Reward** - `/risk-reward/` → Flask backend (port 5001) + static files
3. **Sector Heatmap** - `/sector-heatmap/` → React frontend, `/api/heatmap/` → FastAPI backend (port 8002)
4. **AlphaNifty** - `/alphanifty/` → React frontend, `/alphanifty/api/` → Flask backend (port 5000)

All apps are now isolated with separate paths - no conflicts!

---

## PM2 Processes Running

```bash
pm2 list

┌─────┬────────────────────────┬─────────┬──────────┐
│ id  │ name                   │ mode    │ status   │
├─────┼────────────────────────┼─────────┼──────────┤
│ 0   │ pms-screener           │ fork    │ online   │
│ 1   │ heatmap-backend        │ fork    │ online   │
│ 3   │ risk-reward-backend    │ fork    │ online   │
└─────┴────────────────────────┴─────────┴──────────┘
```

---

## Files Created in This Session

1. `nginx-all-apps.conf` - Complete nginx configuration with all apps
2. This summary document

## Commands Used

```bash
# Create venv and install dependencies
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install flask gunicorn flask-cors pandas numpy
deactivate

# Start with PM2
pm2 start venv/bin/gunicorn --name risk-reward-backend --cwd /var/www/vsfintech/Risk-Reward --interpreter none -- -w 2 -b 0.0.0.0:5001 app:app
pm2 save

# Update nginx
sudo nginx -t
sudo nginx -s reload

# Test
curl http://127.0.0.1:5001/
curl http://82.25.105.18/risk-reward/
pm2 logs risk-reward-backend
```

---

## Next Steps for Risk-Return

1. ✅ You have the deployment script: `deploy-risk-return.sh`
2. ✅ You have the guide: `RISK-RETURN-DEPLOYMENT-GUIDE.md`
3. ⏳ Upload Risk-Return HTML files to server
4. ⏳ Run deployment script or manually configure nginx
5. ⏳ Test at http://82.25.105.18/risk-return/

**The main difference:** Risk-Return is much simpler since it's just HTML files - no backend setup needed!
