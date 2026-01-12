#!/bin/bash

# Risk-Reward Deployment Script
# Deploy Risk-Reward Flask application on VPS
# Port: 5000
# Server: 82.25.105.18

set -e  # Exit on error

echo "🚀 Risk-Reward Deployment Script"
echo "================================="
echo ""

# Configuration
APP_NAME="risk-reward"
APP_DIR="/var/www/vsfintech/Risk-Reward"
PORT=5000
PYTHON_VERSION="python3"
VENV_DIR="$APP_DIR/venv"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ Please run as root (use sudo)${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 Step 1: Checking prerequisites...${NC}"

# Check if Python is installed
if ! command -v $PYTHON_VERSION &> /dev/null; then
    echo -e "${RED}❌ Python3 not found. Installing...${NC}"
    apt-get update
    apt-get install -y python3 python3-pip python3-venv
fi

# Check if PM2 is installed
if ! command -v pm2 &> /dev/null; then
    echo -e "${RED}❌ PM2 not found. Installing...${NC}"
    npm install -g pm2
fi

# Check if the app directory exists
if [ ! -d "$APP_DIR" ]; then
    echo -e "${RED}❌ Application directory not found: $APP_DIR${NC}"
    echo "Please upload your Risk-Reward code to $APP_DIR first"
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites checked${NC}"
echo ""

echo -e "${YELLOW}📦 Step 2: Setting up Python virtual environment...${NC}"
cd "$APP_DIR"

# Remove old venv if exists
if [ -d "$VENV_DIR" ]; then
    echo "Removing old virtual environment..."
    rm -rf "$VENV_DIR"
fi

# Create new virtual environment
$PYTHON_VERSION -m venv venv
source venv/bin/activate

echo -e "${GREEN}✅ Virtual environment created${NC}"
echo ""

echo -e "${YELLOW}📚 Step 3: Installing Python dependencies...${NC}"

# Check if requirements.txt exists
if [ -f "requirements.txt" ]; then
    pip install --upgrade pip
    pip install -r requirements.txt
    echo -e "${GREEN}✅ Dependencies installed from requirements.txt${NC}"
else
    echo -e "${YELLOW}⚠️  No requirements.txt found. Installing common dependencies...${NC}"
    pip install --upgrade pip
    pip install flask gunicorn flask-cors pandas numpy
    echo -e "${GREEN}✅ Basic dependencies installed${NC}"
fi

deactivate
echo ""

echo -e "${YELLOW}🔧 Step 4: Configuring PM2...${NC}"

# Stop existing PM2 process if running
pm2 stop $APP_NAME 2>/dev/null || true
pm2 delete $APP_NAME 2>/dev/null || true

# Start with PM2
pm2 start "$VENV_DIR/bin/gunicorn" \
    --name "$APP_NAME" \
    --cwd "$APP_DIR" \
    --interpreter none \
    -- -w 2 -b 0.0.0.0:$PORT app:app

# Save PM2 configuration
pm2 save

echo -e "${GREEN}✅ PM2 configured and application started${NC}"
echo ""

echo -e "${YELLOW}🌐 Step 5: Configuring Nginx...${NC}"

# Create Nginx configuration for Risk-Reward
NGINX_CONFIG="/etc/nginx/sites-available/vsfintech.conf"

# Check if main config exists and update it
if [ ! -f "$NGINX_CONFIG" ]; then
    echo -e "${YELLOW}⚠️  Main vsfintech config not found, creating minimal config...${NC}"
    
    cat > "$NGINX_CONFIG" << 'EOF'
server {
    listen 80;
    server_name 82.25.105.18;
    
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
}
EOF
    
    # Enable site
    ln -sf "$NGINX_CONFIG" /etc/nginx/sites-enabled/
else
    echo "Using existing Nginx configuration"
fi

# Test and reload Nginx
if nginx -t; then
    echo -e "${GREEN}✅ Nginx configuration is valid${NC}"
    systemctl reload nginx
    echo -e "${GREEN}✅ Nginx reloaded${NC}"
else
    echo -e "${RED}❌ Nginx configuration error${NC}"
    exit 1
fi

echo ""

echo -e "${YELLOW}🔐 Step 6: Setting permissions...${NC}"

# Set correct ownership and permissions
chown -R www-data:www-data "$APP_DIR"
chmod -R 755 "$APP_DIR"

echo -e "${GREEN}✅ Permissions set${NC}"
echo ""

echo -e "${YELLOW}🧪 Step 7: Testing deployment...${NC}"

# Wait for service to start
sleep 3

# Test direct connection
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/ || echo "000")

if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "404" ]; then
    echo -e "${GREEN}✅ Backend service is responding (HTTP $HTTP_CODE)${NC}"
else
    echo -e "${RED}❌ Backend service not responding (HTTP $HTTP_CODE)${NC}"
    echo "Check logs with: pm2 logs $APP_NAME"
fi

# Test through Nginx
HTTP_CODE_NGINX=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/risk-reward/ || echo "000")

if [ "$HTTP_CODE_NGINX" = "200" ] || [ "$HTTP_CODE_NGINX" = "404" ]; then
    echo -e "${GREEN}✅ Nginx proxy is working (HTTP $HTTP_CODE_NGINX)${NC}"
else
    echo -e "${RED}❌ Nginx proxy not working (HTTP $HTTP_CODE_NGINX)${NC}"
fi

echo ""
echo "================================="
echo -e "${GREEN}🎉 Risk-Reward Deployment Complete!${NC}"
echo "================================="
echo ""
echo "📊 Service Information:"
echo "  - Name: $APP_NAME"
echo "  - Port: $PORT"
echo "  - Directory: $APP_DIR"
echo ""
echo "🌐 Access URLs:"
echo "  - Direct: http://82.25.105.18:$PORT"
echo "  - Via Nginx: http://82.25.105.18/risk-reward/"
echo ""
echo "🔧 Management Commands:"
echo "  - View logs: pm2 logs $APP_NAME"
echo "  - Restart: pm2 restart $APP_NAME"
echo "  - Stop: pm2 stop $APP_NAME"
echo "  - Status: pm2 status"
echo ""
echo "📝 Nginx Commands:"
echo "  - Test config: nginx -t"
echo "  - Reload: systemctl reload nginx"
echo "  - View logs: tail -f /var/log/nginx/error.log"
echo ""
