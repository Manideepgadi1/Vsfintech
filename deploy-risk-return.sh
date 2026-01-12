#!/bin/bash

# Risk-Return Deployment Script
# Deploy Risk-Return static HTML application on VPS
# Port: 9005 (independent) or /risk-return (via main nginx)
# Server: 82.25.105.18
# Type: Static HTML/JavaScript application (NO BACKEND)

set -e  # Exit on error

echo "🚀 Risk-Return Deployment Script"
echo "================================="
echo ""
echo "⚠️  SAFE MODE: This script will NOT affect other deployed applications"
echo ""

# Configuration
APP_NAME="risk-return"
APP_DIR="/var/www/vsfintech/Risk-Return"
PORT=9005

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ Please run as root (use sudo)${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 Step 1: Checking prerequisites...${NC}"

# Check if Nginx is installed
if ! command -v nginx &> /dev/null; then
    echo -e "${RED}❌ Nginx not found. Installing...${NC}"
    apt-get update
    apt-get install -y nginx
fi

# Check if the app directory exists
if [ ! -d "$APP_DIR" ]; then
    echo -e "${RED}❌ Application directory not found: $APP_DIR${NC}"
    echo "Please upload your Risk-Return code to $APP_DIR first"
    exit 1
fi

# Check if index.html exists
if [ ! -f "$APP_DIR/index.html" ]; then
    echo -e "${RED}❌ index.html not found in $APP_DIR${NC}"
    echo "Risk-Return is a static HTML app and requires index.html"
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites checked${NC}"
echo ""

echo -e "${YELLOW}🌐 Step 2: Configuring Nginx for Port 9005...${NC}"

# Create independent Nginx configuration for port 9005
NGINX_SITE="/etc/nginx/sites-available/risk-return-9005.conf"

cat > "$NGINX_SITE" << 'EOF'
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
EOF

echo -e "${GREEN}✅ Port 9005 configuration created${NC}"

# Enable the site
ln -sf "$NGINX_SITE" /etc/nginx/sites-enabled/

echo ""
echo -e "${YELLOW}🌐 Step 3: Adding /risk-return location to main site...${NC}"

# Check if main site config exists
MAIN_CONFIG="/etc/nginx/sites-available/vsfintech.conf"

if [ -f "$MAIN_CONFIG" ]; then
    # Check if risk-return location already exists
    if grep -q "location /risk-return" "$MAIN_CONFIG"; then
        echo -e "${BLUE}ℹ️  /risk-return location already exists in main config${NC}"
    else
        echo -e "${YELLOW}Adding /risk-return location to main config...${NC}"
        
        # Backup the config
        cp "$MAIN_CONFIG" "$MAIN_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Add the location block (find the last location block and add after it)
        # This is a safe addition that won't break existing config
        sed -i '/^}/i \
    # Risk-Return - Static HTML\
    location /risk-return {\
        alias /var/www/vsfintech/Risk-Return;\
        try_files $uri $uri/ /risk-return/index.html;\
        index index.html;\
    }\
' "$MAIN_CONFIG"
        
        echo -e "${GREEN}✅ /risk-return location added${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Main config not found. Creating minimal config...${NC}"
    
    cat > "$MAIN_CONFIG" << 'EOF'
server {
    listen 80;
    server_name 82.25.105.18;
    
    # Risk-Return - Static HTML
    location /risk-return {
        alias /var/www/vsfintech/Risk-Return;
        try_files $uri $uri/ /risk-return/index.html;
        index index.html;
    }
}
EOF
    
    ln -sf "$MAIN_CONFIG" /etc/nginx/sites-enabled/
    echo -e "${GREEN}✅ Main config created${NC}"
fi

echo ""
echo -e "${YELLOW}🔧 Step 4: Testing Nginx configuration...${NC}"

# Test Nginx configuration
if nginx -t; then
    echo -e "${GREEN}✅ Nginx configuration is valid${NC}"
else
    echo -e "${RED}❌ Nginx configuration error${NC}"
    echo "Restoring backup..."
    if [ -f "$MAIN_CONFIG.backup."* ]; then
        cp "$MAIN_CONFIG.backup."* "$MAIN_CONFIG"
    fi
    exit 1
fi

echo ""
echo -e "${YELLOW}🔄 Step 5: Reloading Nginx (safe reload)...${NC}"

# Reload Nginx (this doesn't stop other services)
systemctl reload nginx

echo -e "${GREEN}✅ Nginx reloaded successfully${NC}"
echo ""

echo -e "${YELLOW}🔐 Step 6: Setting permissions...${NC}"

# Set correct ownership and permissions
chown -R www-data:www-data "$APP_DIR"
chmod -R 755 "$APP_DIR"

echo -e "${GREEN}✅ Permissions set${NC}"
echo ""

echo -e "${YELLOW}🧪 Step 7: Testing deployment...${NC}"

# Wait a moment for nginx to fully reload
sleep 2

# Test port 9005
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/ || echo "000")

if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ Port 9005 is accessible (HTTP $HTTP_CODE)${NC}"
else
    echo -e "${YELLOW}⚠️  Port 9005 status: HTTP $HTTP_CODE${NC}"
fi

# Test through main site
HTTP_CODE_MAIN=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/risk-return/ || echo "000")

if [ "$HTTP_CODE_MAIN" = "200" ]; then
    echo -e "${GREEN}✅ Main site /risk-return is accessible (HTTP $HTTP_CODE_MAIN)${NC}"
else
    echo -e "${YELLOW}⚠️  Main site /risk-return status: HTTP $HTTP_CODE_MAIN${NC}"
fi

# Check if other services are still running
echo ""
echo -e "${BLUE}ℹ️  Checking other services (to ensure nothing was disturbed)...${NC}"

if command -v pm2 &> /dev/null; then
    echo ""
    echo "PM2 Services Status:"
    pm2 status | grep -E "online|stopped|errored" || echo "No PM2 services or all running"
fi

echo ""
echo "================================="
echo -e "${GREEN}🎉 Risk-Return Deployment Complete!${NC}"
echo "================================="
echo ""
echo "📊 Service Information:"
echo "  - Name: $APP_NAME"
echo "  - Type: Static HTML Application"
echo "  - Directory: $APP_DIR"
echo ""
echo "🌐 Access URLs:"
echo "  - Independent Port: http://82.25.105.18:$PORT"
echo "  - Via Main Site: http://82.25.105.18/risk-return/"
echo ""
echo "✅ Deployment completed without affecting other applications"
echo ""
echo "🔧 Useful Commands:"
echo "  - Test port 9005: curl http://localhost:9005/"
echo "  - Test main site: curl http://localhost/risk-return/"
echo "  - Nginx status: systemctl status nginx"
echo "  - Nginx reload: systemctl reload nginx"
echo "  - View logs: tail -f /var/log/nginx/access.log"
echo ""
echo "📝 Note: This is a static HTML application (no backend/PM2 needed)"
echo ""
