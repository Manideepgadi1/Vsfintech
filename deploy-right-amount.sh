#!/bin/bash

# Right Amount (Bar-Line) Deployment Script
# Deploy Bar-Line React frontend + Flask backend on VPS
# Frontend Port: 9002 (independent) or /right-amount (via main nginx)
# Backend Port: 8001
# Server: 82.25.105.18

set -e  # Exit on error

echo "🚀 Right Amount (Bar-Line) Deployment Script"
echo "=============================================="
echo ""

# Configuration
APP_NAME="bar-line"
FRONTEND_NAME="right-amount"
BACKEND_NAME="bar-line-backend"
APP_DIR="/var/www/vsfintech/Bar-Line"
FRONTEND_PORT=9002
BACKEND_PORT=8001
PYTHON_VERSION="python3"

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

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js not found. Installing...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
fi

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
    echo "Please upload your Bar-Line code to $APP_DIR first"
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites checked${NC}"
echo ""

# ========================================
# Deploy Backend
# ========================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📦 Step 2: Deploying Backend (Flask)...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

cd "$APP_DIR/backend"

# Check if backend directory exists
if [ ! -f "server.py" ] && [ ! -f "app.py" ]; then
    echo -e "${RED}❌ Backend entry point (server.py or app.py) not found${NC}"
    exit 1
fi

# Remove old venv if exists
if [ -d "venv" ]; then
    echo "Removing old virtual environment..."
    rm -rf venv
fi

# Create new virtual environment
echo "Creating Python virtual environment..."
$PYTHON_VERSION -m venv venv
source venv/bin/activate

# Install dependencies
echo "Installing Python dependencies..."
if [ -f "requirements.txt" ]; then
    pip install --upgrade pip
    pip install -r requirements.txt
else
    echo -e "${YELLOW}⚠️  No requirements.txt found. Installing common dependencies...${NC}"
    pip install --upgrade pip
    pip install flask gunicorn flask-cors pandas numpy
fi

deactivate

# Stop existing PM2 process if running
pm2 stop $BACKEND_NAME 2>/dev/null || true
pm2 delete $BACKEND_NAME 2>/dev/null || true

# Determine the entry point
ENTRY_POINT="server:app"
if [ ! -f "server.py" ] && [ -f "app.py" ]; then
    ENTRY_POINT="app:app"
fi

# Start backend with PM2
pm2 start "$APP_DIR/backend/venv/bin/gunicorn" \
    --name "$BACKEND_NAME" \
    --cwd "$APP_DIR/backend" \
    --interpreter none \
    -- -w 2 -b 0.0.0.0:$BACKEND_PORT $ENTRY_POINT

pm2 save

echo -e "${GREEN}✅ Backend deployed successfully on port $BACKEND_PORT${NC}"
echo ""

# ========================================
# Deploy Frontend
# ========================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📦 Step 3: Deploying Frontend (React + Vite)...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

cd "$APP_DIR"

# Check if package.json exists
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ package.json not found${NC}"
    exit 1
fi

# Install npm dependencies
echo "Installing npm dependencies..."
npm install

# Configure for subpath deployment
echo "Configuring React app for /right-amount subpath..."

# Backup vite.config file
VITE_CONFIG=""
if [ -f "vite.config.ts" ]; then
    VITE_CONFIG="vite.config.ts"
    cp "$VITE_CONFIG" "$VITE_CONFIG.backup"
elif [ -f "vite.config.js" ]; then
    VITE_CONFIG="vite.config.js"
    cp "$VITE_CONFIG" "$VITE_CONFIG.backup"
fi

# Update vite config for correct base path
if [ -n "$VITE_CONFIG" ]; then
    if grep -q "base:" "$VITE_CONFIG"; then
        sed -i "s|base:.*|base: '/right-amount',|" "$VITE_CONFIG"
    else
        sed -i "/export default defineConfig({/a\\  base: '/right-amount'," "$VITE_CONFIG"
    fi
    echo -e "${GREEN}✓ Vite config updated${NC}"
fi

# Update React Router basename if using main.tsx
if [ -f "src/main.tsx" ]; then
    # Backup main.tsx
    cp src/main.tsx src/main.tsx.backup 2>/dev/null || true
    
    # Add basename to BrowserRouter if not present
    if grep -q "<BrowserRouter>" src/main.tsx; then
        sed -i 's|<BrowserRouter>|<BrowserRouter basename="/right-amount">|' src/main.tsx
        echo -e "${GREEN}✓ React Router basename configured${NC}"
    fi
fi

# Create .env file for API URL
echo "VITE_API_URL=/api/right-amount" > .env
echo -e "${GREEN}✓ Environment file created${NC}"

# Build the application
echo "Building React application..."
npm run build

if [ ! -d "dist" ]; then
    echo -e "${RED}❌ Build failed - dist folder not created${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Frontend built successfully${NC}"
echo ""

# ========================================
# Configure Nginx
# ========================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🌐 Step 4: Configuring Nginx...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Add to main vsfintech config
NGINX_CONFIG="/etc/nginx/sites-available/vsfintech.conf"

# Create/update configuration
if [ ! -f "$NGINX_CONFIG" ]; then
    echo "Creating new Nginx configuration..."
    cat > "$NGINX_CONFIG" << 'EOF'
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
    }
}
EOF
    
    ln -sf "$NGINX_CONFIG" /etc/nginx/sites-enabled/
else
    echo "Nginx configuration already exists"
fi

# Create independent port configuration (Port 9002)
cat > /etc/nginx/sites-available/right-amount-9002.conf << 'EOF'
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
EOF

ln -sf /etc/nginx/sites-available/right-amount-9002.conf /etc/nginx/sites-enabled/

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

# ========================================
# Set Permissions
# ========================================
echo -e "${YELLOW}🔐 Step 5: Setting permissions...${NC}"

chown -R www-data:www-data "$APP_DIR"
chmod -R 755 "$APP_DIR"

echo -e "${GREEN}✅ Permissions set${NC}"
echo ""

# ========================================
# Test Deployment
# ========================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🧪 Step 6: Testing deployment...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Wait for services to start
sleep 3

# Test backend
BACKEND_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$BACKEND_PORT/ || echo "000")
if [ "$BACKEND_CODE" = "200" ] || [ "$BACKEND_CODE" = "404" ]; then
    echo -e "${GREEN}✅ Backend responding (HTTP $BACKEND_CODE)${NC}"
else
    echo -e "${RED}❌ Backend not responding (HTTP $BACKEND_CODE)${NC}"
fi

# Test frontend through main site
FRONTEND_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/right-amount/ || echo "000")
if [ "$FRONTEND_CODE" = "200" ]; then
    echo -e "${GREEN}✅ Frontend accessible via main site (HTTP $FRONTEND_CODE)${NC}"
else
    echo -e "${YELLOW}⚠️  Frontend status via main site: HTTP $FRONTEND_CODE${NC}"
fi

# Test frontend on independent port
PORT_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$FRONTEND_PORT/ || echo "000")
if [ "$PORT_CODE" = "200" ]; then
    echo -e "${GREEN}✅ Frontend accessible on port $FRONTEND_PORT (HTTP $PORT_CODE)${NC}"
else
    echo -e "${YELLOW}⚠️  Frontend status on port $FRONTEND_PORT: HTTP $PORT_CODE${NC}"
fi

# Check PM2 status
echo ""
echo "PM2 Process Status:"
pm2 status | grep -E "bar-line|name"

echo ""
echo "=============================================="
echo -e "${GREEN}🎉 Right Amount (Bar-Line) Deployment Complete!${NC}"
echo "=============================================="
echo ""
echo "📊 Service Information:"
echo "  - Backend Name: $BACKEND_NAME"
echo "  - Backend Port: $BACKEND_PORT"
echo "  - Frontend Port: $FRONTEND_PORT"
echo "  - Directory: $APP_DIR"
echo ""
echo "🌐 Access URLs:"
echo "  - Main Site: http://82.25.105.18/right-amount/"
echo "  - Independent: http://82.25.105.18:$FRONTEND_PORT"
echo "  - Backend API: http://82.25.105.18/api/right-amount/"
echo ""
echo "🔧 Management Commands:"
echo "  - Backend logs: pm2 logs $BACKEND_NAME"
echo "  - Restart backend: pm2 restart $BACKEND_NAME"
echo "  - PM2 status: pm2 status"
echo "  - Nginx logs: tail -f /var/log/nginx/error.log"
echo ""
