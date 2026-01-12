# Risk-Return - Complete Deployment Guide

**Application:** Risk-Return Dashboard  
**Type:** Static HTML/JavaScript Application (NO BACKEND)  
**Port:** 9005 (independent) or /risk-return (via main nginx)  
**Purpose:** Comprehensive risk-return analysis for portfolio optimization

---

## 🎯 Overview

Risk-Return is a **pure frontend static application** that provides:
- Risk-return analysis dashboard
- Portfolio optimization visualization
- Interactive charts and graphs
- No backend or database required

**Access URLs:**
- Independent Port: http://82.25.105.18:9005
- Via Main Site: http://82.25.105.18/risk-return/

**Important:** This is a static HTML application - no Python, Flask, or PM2 needed!

---

## 📋 Prerequisites

1. ✅ SSH access to VPS (82.25.105.18)
2. ✅ Nginx installed and running
3. ✅ Risk-Return HTML files (index.html, CSS, JS, images)
4. ❌ NO backend, Python, or PM2 required

---

## 📁 Required Application Structure

```
Risk-Return/
├── index.html           # Main HTML file (REQUIRED)
├── css/                # Stylesheets
│   ├── style.css
│   └── theme.css
├── js/                 # JavaScript files
│   ├── app.js
│   ├── charts.js
│   └── calculations.js
├── images/             # Images and icons
│   ├── logo.png
│   └── icons/
├── data/               # Static data files (optional)
│   └── sample-data.json
└── assets/             # Other assets (fonts, etc.)
```

**Minimum Required:**
- `index.html` - Main entry point
- CSS and JavaScript files (can be inline or external)

---

## 🚀 Deployment Method: Safe Automated Script

This deployment will **NOT disturb any existing applications** - it only:
- Creates a new Nginx configuration for port 9005
- Adds a location block to main site (if needed)
- Sets file permissions
- Tests the deployment

### Step 1: Upload the Deployment Script

```bash
# From your local machine
scp deploy-risk-return.sh root@82.25.105.18:/tmp/
```

### Step 2: Upload Risk-Return Files

```bash
# Option A: Using SCP
scp -r ./Risk-Return root@82.25.105.18:/var/www/vsfintech/

# Option B: Using rsync (better for large files)
rsync -avz --progress ./Risk-Return/ root@82.25.105.18:/var/www/vsfintech/Risk-Return/

# Option C: Using Git (if in repository)
ssh root@82.25.105.18
cd /var/www/vsfintech
git clone <RISK_RETURN_REPO_URL> Risk-Return
```

### Step 3: Run the Deployment Script

```bash
ssh root@82.25.105.18
chmod +x /tmp/deploy-risk-return.sh
sudo /tmp/deploy-risk-return.sh
```

The script will:
- ✅ Check if Risk-Return files exist
- ✅ Create Nginx config for port 9005 (isolated from other apps)
- ✅ Add /risk-return location to main site
- ✅ Test configuration before applying
- ✅ Reload Nginx safely (no interruption to other services)
- ✅ Set correct permissions
- ✅ Test both access points
- ✅ Verify other services are still running

---

## 🛡️ Manual Deployment (Step-by-Step)

### Step 1: Upload Application Files

```bash
ssh root@82.25.105.18

# Create directory if it doesn't exist
mkdir -p /var/www/vsfintech/Risk-Return

# Upload files (from local machine in another terminal)
scp -r ./Risk-Return/* root@82.25.105.18:/var/www/vsfintech/Risk-Return/
```

### Step 2: Verify Files

```bash
cd /var/www/vsfintech/Risk-Return

# Check if index.html exists
ls -la index.html

# List all files
ls -la
```

### Step 3: Configure Nginx for Port 9005 (Independent Access)

Create a new configuration file:

```bash
sudo nano /etc/nginx/sites-available/risk-return-9005.conf
```

Add this configuration:

```nginx
# Risk-Return - Static HTML Application
# Independent deployment on port 9005
server {
    listen 9005;
    server_name 82.25.105.18;
    
    root /var/www/vsfintech/Risk-Return;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Enable gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;
    
    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

Enable the site:

```bash
sudo ln -s /etc/nginx/sites-available/risk-return-9005.conf /etc/nginx/sites-enabled/
```

### Step 4: Add to Main Site (Optional but Recommended)

Edit main site configuration:

```bash
sudo nano /etc/nginx/sites-available/vsfintech.conf
```

Add this location block inside the existing `server` block:

```nginx
    # Risk-Return - Static HTML
    location /risk-return {
        alias /var/www/vsfintech/Risk-Return;
        try_files $uri $uri/ /risk-return/index.html;
        index index.html;
    }
```

**Important:** Add this block BEFORE the closing `}` of the server block, and make sure not to modify any existing location blocks.

### Step 5: Test Nginx Configuration

```bash
# Test configuration (this won't affect running services)
sudo nginx -t
```

Expected output:
```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

### Step 6: Reload Nginx (Safe - Won't Affect Other Services)

```bash
# Reload Nginx gracefully (no downtime)
sudo systemctl reload nginx
```

**Note:** `reload` is safe - it doesn't restart the service or affect other running applications.

### Step 7: Set Permissions

```bash
sudo chown -R www-data:www-data /var/www/vsfintech/Risk-Return
sudo chmod -R 755 /var/www/vsfintech/Risk-Return
```

### Step 8: Test Deployment

```bash
# Test port 9005
curl -I http://localhost:9005/

# Test main site path
curl -I http://localhost/risk-return/

# Test from external browser
# http://82.25.105.18:9005
# http://82.25.105.18/risk-return/
```

### Step 9: Verify Other Services Are Unaffected

```bash
# Check PM2 services (should all still be running)
pm2 status

# Test other applications
curl -I http://localhost/
curl -I http://localhost:8000/
curl -I http://localhost:5000/
```

---

## 🔍 Verification & Testing

### Check Files

```bash
# List Risk-Return files
ls -la /var/www/vsfintech/Risk-Return/

# Check index.html content
cat /var/www/vsfintech/Risk-Return/index.html | head -20

# Check file permissions
ls -l /var/www/vsfintech/Risk-Return/index.html
# Should show: -rwxr-xr-x ... www-data www-data ... index.html
```

### Test HTTP Responses

```bash
# Test port 9005 (should return 200)
curl -I http://localhost:9005/

# Test main site path (should return 200)
curl -I http://localhost/risk-return/

# Test with actual content
curl http://localhost:9005/ | head -50
```

### Check Nginx Logs

```bash
# View access logs
sudo tail -f /var/log/nginx/access.log | grep risk-return

# View error logs
sudo tail -f /var/log/nginx/error.log
```

### Test in Browser

Open these URLs in your browser:
1. http://82.25.105.18:9005 - Should show Risk-Return dashboard
2. http://82.25.105.18/risk-return/ - Should show same dashboard

---

## 🔧 Troubleshooting

### Issue: 404 Not Found

**Cause:** Files not in correct location or wrong path

**Solution:**
```bash
# Check if files exist
ls -la /var/www/vsfintech/Risk-Return/index.html

# If missing, upload files
scp -r ./Risk-Return/* root@82.25.105.18:/var/www/vsfintech/Risk-Return/

# Check nginx error logs
sudo tail -f /var/log/nginx/error.log
```

### Issue: 403 Forbidden

**Cause:** Wrong file permissions

**Solution:**
```bash
# Fix permissions
sudo chown -R www-data:www-data /var/www/vsfintech/Risk-Return
sudo chmod -R 755 /var/www/vsfintech/Risk-Return

# Make sure index.html is readable
sudo chmod 644 /var/www/vsfintech/Risk-Return/index.html
```

### Issue: Port 9005 Not Accessible

**Cause:** Nginx not listening on port 9005

**Solution:**
```bash
# Check if nginx is listening on port 9005
sudo netstat -tulpn | grep 9005

# If not, check nginx configuration
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx
```

### Issue: CSS/JS Not Loading

**Cause:** Incorrect paths in HTML or missing MIME types

**Solution:**
```bash
# Check if CSS/JS files exist
ls -la /var/www/vsfintech/Risk-Return/css/
ls -la /var/www/vsfintech/Risk-Return/js/

# Verify paths in index.html
grep -E 'href=|src=' /var/www/vsfintech/Risk-Return/index.html

# Make sure all files are readable
sudo find /var/www/vsfintech/Risk-Return -type f -exec chmod 644 {} \;
```

### Issue: Nginx Configuration Error

**Cause:** Syntax error in nginx config

**Solution:**
```bash
# Test configuration and see detailed error
sudo nginx -t

# If there's an error, restore backup
sudo cp /etc/nginx/sites-available/vsfintech.conf.backup.* /etc/nginx/sites-available/vsfintech.conf

# Or remove the new config
sudo rm /etc/nginx/sites-enabled/risk-return-9005.conf
sudo systemctl reload nginx
```

---

## 🔗 Integration with Main Platform

Risk-Return is linked from the main VS Fintech Platform:

### Frontend Links

**Homepage** (`frontend/src/pages/HomePage.tsx`):
```typescript
href="http://82.25.105.18:9005"
// or
href="http://82.25.105.18/risk-return"
```

**Fundoscope Page** (`frontend/src/pages/tools/FundoscopePage.tsx`):
```typescript
href="http://82.25.105.18/risk-return"
```

---

## 📝 Sample index.html Structure

If you're creating Risk-Return from scratch, here's a minimal template:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Risk-Return Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <h1>Risk-Return Analysis Dashboard</h1>
    </header>
    
    <main>
        <section class="dashboard">
            <h2>Portfolio Analysis</h2>
            <div id="chart-container">
                <!-- Charts and visualizations -->
            </div>
        </section>
        
        <section class="controls">
            <h3>Parameters</h3>
            <!-- Input controls -->
        </section>
        
        <section class="results">
            <h3>Results</h3>
            <div id="results-container">
                <!-- Results display -->
            </div>
        </section>
    </main>
    
    <footer>
        <p>&copy; 2025 VS Fintech Platform</p>
    </footer>
    
    <script src="js/app.js"></script>
</body>
</html>
```

---

## ✅ Deployment Checklist

- [ ] Risk-Return files uploaded to `/var/www/vsfintech/Risk-Return/`
- [ ] `index.html` file exists and is accessible
- [ ] All CSS, JS, and image files uploaded
- [ ] Nginx config created for port 9005
- [ ] Nginx config updated with `/risk-return` location
- [ ] Nginx configuration tested (`nginx -t`)
- [ ] Nginx reloaded successfully
- [ ] File permissions set (www-data:www-data, 755)
- [ ] Port 9005 accessible (HTTP 200)
- [ ] Main site path `/risk-return/` accessible
- [ ] CSS and JavaScript loading correctly
- [ ] Images displaying correctly
- [ ] Other services still running (PM2 status checked)
- [ ] No errors in Nginx logs
- [ ] Integration links in main platform working

---

## 🎯 Quick Reference Commands

```bash
# Check files
ls -la /var/www/vsfintech/Risk-Return/

# Test access
curl -I http://localhost:9005/
curl -I http://localhost/risk-return/

# Nginx commands
sudo nginx -t                    # Test config
sudo systemctl reload nginx      # Reload safely
sudo systemctl status nginx      # Check status

# View logs
sudo tail -f /var/log/nginx/access.log | grep risk-return
sudo tail -f /var/log/nginx/error.log

# Permissions
sudo chown -R www-data:www-data /var/www/vsfintech/Risk-Return
sudo chmod -R 755 /var/www/vsfintech/Risk-Return

# Check other services
pm2 status
curl -I http://localhost:8000/
```

---

## 📞 Support & Next Steps

**Deployment Type:** Static HTML Application  
**No Backend Required:** ✅  
**Expected Result:** Risk-Return accessible at both port 9005 and /risk-return/

**Next Steps:**
1. Prepare Risk-Return HTML files (index.html + assets)
2. Upload to `/var/www/vsfintech/Risk-Return/`
3. Run deployment script or follow manual steps
4. Test both access URLs
5. Verify integration with main platform
6. Update DEPLOYMENT-SUMMARY.md

**Safety Note:** This deployment is completely isolated and will not affect:
- ❌ PM2 services (backend APIs)
- ❌ Other Nginx locations
- ❌ Database
- ❌ Any other deployed applications

---

**Ready to deploy?** Run the automated script for safe, zero-impact deployment!
