# Right Sector Deployment Guide

**Application:** Right Sector - Sector Analysis Dashboard  
**Port:** 9004  
**Type:** Static HTML/JavaScript Application  
**URL:** http://82.25.105.18:9004 or http://82.25.105.18/right-sector

---

## Prerequisites

1. SSH access to VPS (82.25.105.18)
2. Right Sector application source code
3. Nginx installed and running
4. Git repository with Right Sector code

---

## Deployment Steps

### Step 1: Prepare Application on Local Machine

If Right Sector is a static HTML app:
```bash
# Navigate to Right Sector project directory
cd /path/to/right-sector

# If it needs building (React/Vue/etc), build it:
npm install
npm run build
# This creates a 'dist' or 'build' folder
```

If it's already static HTML:
```bash
# Ensure all files are ready (index.html, CSS, JS)
# No build step needed
```

### Step 2: Upload to VPS

**Option A: Using SCP (if files are local)**
```bash
# Upload the entire dist/build folder
scp -r ./dist/* root@82.25.105.18:/var/www/vsfintech/Right-Sector/dist/
```

**Option B: Using Git (recommended)**
```bash
# SSH to server
ssh root@82.25.105.18

# Navigate to vsfintech directory
cd /var/www/vsfintech

# Clone or pull Right Sector repository
git clone https://github.com/YOUR_USERNAME/Right-Sector.git
# OR if already exists:
cd Right-Sector
git pull origin main

# If application needs building on server:
npm install
npm run build
```

**Option C: Create from GitHub repo**
```bash
ssh root@82.25.105.18
cd /var/www/vsfintech

# If you have the repo URL:
git clone <RIGHT_SECTOR_REPO_URL> Right-Sector
cd Right-Sector

# Build if needed
npm install && npm run build
```

### Step 3: Configure Nginx

The nginx configuration is already in place from `deploy-independent-apps.sh`. Verify it exists:

```bash
ssh root@82.25.105.18

# Check if config exists
sudo nginx -t

# If you need to add/update config for port 9004:
sudo nano /etc/nginx/sites-available/right-sector-9004.conf
```

Add this configuration:
```nginx
server {
    listen 9004;
    server_name 82.25.105.18;
    
    root /var/www/vsfintech/Right-Sector/dist;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Enable gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;
}
```

Enable the site:
```bash
sudo ln -s /etc/nginx/sites-available/right-sector-9004.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### Step 4: Configure Main Site Integration

The main site at port 80 should also serve Right Sector at `/right-sector`. This is already configured in `nginx-complete-config.conf`:

```nginx
location /right-sector {
    alias /var/www/vsfintech/Right-Sector/dist;
    try_files $uri $uri/ /right-sector/index.html;
}
```

Ensure this is in `/etc/nginx/sites-available/vsfintech.conf` and reload nginx.

### Step 5: Set Permissions

```bash
ssh root@82.25.105.18

# Set correct ownership and permissions
sudo chown -R www-data:www-data /var/www/vsfintech/Right-Sector/dist
sudo chmod -R 755 /var/www/vsfintech/Right-Sector/dist
```

### Step 6: Test Deployment

```bash
# Test port 9004
curl http://localhost:9004/

# Test main site path
curl http://82.25.105.18/right-sector/

# Open in browser
# http://82.25.105.18:9004
# http://82.25.105.18/right-sector
```

---

## Directory Structure

Expected structure on VPS:
```
/var/www/vsfintech/Right-Sector/
├── dist/                    # Built application files
│   ├── index.html          # Main HTML file
│   ├── assets/             # CSS, JS, images
│   │   ├── index-*.js
│   │   ├── index-*.css
│   │   └── ...
│   └── ...
└── [optional source files if using git]
```

---

## Troubleshooting

### Issue: 404 Not Found
```bash
# Check if files exist
ls -la /var/www/vsfintech/Right-Sector/dist/

# Check nginx error logs
sudo tail -f /var/log/nginx/error.log

# Verify nginx config
sudo nginx -t
```

### Issue: 403 Forbidden
```bash
# Fix permissions
sudo chown -R www-data:www-data /var/www/vsfintech/Right-Sector/dist
sudo chmod -R 755 /var/www/vsfintech/Right-Sector/dist
```

### Issue: Port Already in Use
```bash
# Check what's using port 9004
sudo netstat -tulpn | grep 9004
sudo lsof -i :9004

# Kill the process if needed
sudo kill <PID>
```

### Issue: CSS/JS Not Loading
```bash
# Check if base path is correct in built files
# If using Vite, ensure vite.config.ts has correct base:
# base: '/right-sector/' or base: '/'

# Update nginx to serve assets correctly
```

---

## Quick Deployment Script

Create a file `deploy-right-sector.sh` on the VPS:

```bash
#!/bin/bash

echo "🚀 Deploying Right Sector..."

# Navigate to app directory
cd /var/www/vsfintech/Right-Sector || exit 1

# Pull latest changes (if using git)
git pull origin main

# Install dependencies and build (if needed)
if [ -f "package.json" ]; then
    npm install
    npm run build
    echo "✅ Build completed"
fi

# Set permissions
sudo chown -R www-data:www-data dist/
sudo chmod -R 755 dist/

# Test nginx config
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx

# Test deployment
echo ""
echo "🧪 Testing deployment..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9004/)
if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Right Sector deployed successfully!"
    echo "   Port 9004: http://82.25.105.18:9004"
    echo "   Main site: http://82.25.105.18/right-sector"
else
    echo "❌ Deployment test failed (HTTP $HTTP_CODE)"
fi
```

Make it executable:
```bash
chmod +x deploy-right-sector.sh
./deploy-right-sector.sh
```

---

## Integration with Main Platform

The Right Sector tool is accessible from:

1. **Homepage** - Tool button linking to Right Sector
2. **Fundoscope Page** - Listed as first tool in the suite
3. **Direct URLs:**
   - http://82.25.105.18:9004
   - http://82.25.105.18/right-sector

Frontend links are configured in:
- `frontend/src/pages/HomePage.tsx`
- `frontend/src/pages/tools/FundoscopePage.tsx`

---

## Monitoring

Add Right Sector to PM2 monitoring if it has a backend:
```bash
# Only if Right Sector has a backend API
pm2 start right-sector-backend.py --name right-sector --interpreter python3
pm2 save
```

For static-only deployment, no PM2 needed. Monitor via nginx access logs:
```bash
sudo tail -f /var/log/nginx/access.log | grep right-sector
```

---

## Update Process

To update Right Sector after changes:

```bash
# SSH to server
ssh root@82.25.105.18

# Update code
cd /var/www/vsfintech/Right-Sector
git pull

# Rebuild if needed
npm run build

# Set permissions
sudo chown -R www-data:www-data dist/
sudo chmod -R 755 dist/

# Reload nginx
sudo systemctl reload nginx

# Test
curl http://localhost:9004/
```

---

## Status Check

Add to monitoring dashboard:
```bash
# Check if port 9004 is accessible
curl -I http://82.25.105.18:9004/

# Check nginx configuration
sudo nginx -t

# View access logs
sudo tail /var/log/nginx/access.log | grep 9004
```

---

**Deployment Checklist:**

- [ ] Right Sector source code uploaded to `/var/www/vsfintech/Right-Sector/`
- [ ] Application built (if needed) - `dist/` folder exists
- [ ] Nginx config for port 9004 created and enabled
- [ ] Main site nginx config includes `/right-sector` location
- [ ] File permissions set correctly (www-data:www-data, 755)
- [ ] Nginx configuration tested (`nginx -t`)
- [ ] Nginx reloaded
- [ ] Port 9004 accessible: http://82.25.105.18:9004
- [ ] Main site path accessible: http://82.25.105.18/right-sector
- [ ] Links from homepage working
- [ ] Links from Fundoscope page working

---

**Next Steps:**

1. Obtain Right Sector application source code
2. Follow deployment steps above
3. Test all access points
4. Update DEPLOYMENT-SUMMARY.md with deployment date and status
