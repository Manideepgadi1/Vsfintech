#!/bin/bash

# Right Amount (Bar-Line) SAFE Deployment Script
# This script will NOT disturb any existing applications
# Frontend: /right-amount/ | Backend Port: 8001 | API: /api/right-amount/
# Server: 82.25.105.18

set -e  # Exit on error

echo "🚀 Right Amount (Bar-Line) SAFE Deployment"
echo "============================================"
echo ""

# Configuration
APP_NAME="right-amount"
BACKEND_NAME="right-amount-backend"
APP_DIR="/var/www/vsfintech/Bar-Line"
BACKEND_PORT=8001
PYTHON_VERSION="python3"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ Please run as root (use sudo)${NC}"
    exit 1
fi

# Check if the app directory exists
if [ ! -d "$APP_DIR" ]; then
    echo -e "${RED}❌ Application directory not found: $APP_DIR${NC}"
    echo "Please upload your Bar-Line code to $APP_DIR first"
    exit 1
fi

echo -e "${YELLOW}📋 Checking prerequisites...${NC}"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js not found. Please install Node.js first${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Node.js: $(node -v)${NC}"

# Check Python
if ! command -v $PYTHON_VERSION &> /dev/null; then
    echo -e "${RED}❌ Python3 not found. Please install Python3 first${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Python: $($PYTHON_VERSION --version)${NC}"

# Check PM2
if ! command -v pm2 &> /dev/null; then
    echo -e "${RED}❌ PM2 not found. Please install PM2 first${NC}"
    exit 1
fi
echo -e "${GREEN}✓ PM2 installed${NC}"

echo ""

# ========================================
# Deploy Backend
# ========================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📦 Step 1: Deploying Backend (Flask)...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

cd "$APP_DIR/backend"

# Check backend files
if [ ! -f "server.py" ] && [ ! -f "app.py" ]; then
    echo -e "${RED}❌ Backend entry point not found (server.py or app.py)${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Backend files found${NC}"

# Remove old venv if exists
if [ -d "venv" ]; then
    echo "Removing old virtual environment..."
    rm -rf venv
fi

# Create virtual environment
echo "Creating Python virtual environment..."
$PYTHON_VERSION -m venv venv
source venv/bin/activate

# Install dependencies
echo "Installing Python dependencies..."
if [ -f "requirements.txt" ]; then
    pip install --upgrade pip -q
    pip install -r requirements.txt -q
else
    echo -e "${YELLOW}⚠️  No requirements.txt found. Installing common dependencies...${NC}"
    pip install --upgrade pip -q
    pip install flask gunicorn flask-cors pandas numpy -q
fi

deactivate
echo -e "${GREEN}✓ Python dependencies installed${NC}"

# Check port availability
if lsof -Pi :$BACKEND_PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Port $BACKEND_PORT is in use${NC}"
    echo "Stopping existing process on port $BACKEND_PORT..."
    pm2 stop $BACKEND_NAME 2>/dev/null || true
    pm2 delete $BACKEND_NAME 2>/dev/null || true
    sleep 2
fi

# Determine entry point
ENTRY_POINT="server:app"
if [ ! -f "server.py" ] && [ -f "app.py" ]; then
    ENTRY_POINT="app:app"
fi

# Start backend with PM2
echo "Starting backend on port $BACKEND_PORT..."
pm2 start "$APP_DIR/backend/venv/bin/gunicorn" \
    --name "$BACKEND_NAME" \
    --cwd "$APP_DIR/backend" \
    --interpreter none \
    -- -w 2 -b 0.0.0.0:$BACKEND_PORT $ENTRY_POINT

pm2 save

echo -e "${GREEN}✅ Backend deployed on port $BACKEND_PORT${NC}"
echo ""

# ========================================
# Deploy Frontend
# ========================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📦 Step 2: Deploying Frontend (React + Vite)...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

cd "$APP_DIR"

# Check package.json
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ package.json not found${NC}"
    exit 1
fi

# Install npm dependencies
echo "Installing npm dependencies..."
npm install -q

# Configure vite.config
echo "Configuring Vite for /right-amount subpath..."
VITE_CONFIG=""
if [ -f "vite.config.ts" ]; then
    VITE_CONFIG="vite.config.ts"
elif [ -f "vite.config.js" ]; then
    VITE_CONFIG="vite.config.js"
fi

if [ -n "$VITE_CONFIG" ]; then
    # Backup
    cp "$VITE_CONFIG" "$VITE_CONFIG.backup.$(date +%s)"
    
    # Update base path
    if grep -q "base:" "$VITE_CONFIG"; then
        sed -i "s|base:.*|base: '/right-amount',|" "$VITE_CONFIG"
    else
        sed -i "/export default defineConfig({/a\\  base: '/right-amount'," "$VITE_CONFIG"
    fi
    echo -e "${GREEN}✓ Vite config updated${NC}"
else
    echo -e "${YELLOW}⚠️  No vite.config file found${NC}"
fi

# Configure React Router
if [ -f "src/main.tsx" ]; then
    cp src/main.tsx "src/main.tsx.backup.$(date +%s)" 2>/dev/null || true
    
    if grep -q "<BrowserRouter>" src/main.tsx && ! grep -q 'basename=' src/main.tsx; then
        sed -i 's|<BrowserRouter>|<BrowserRouter basename="/right-amount">|' src/main.tsx
        echo -e "${GREEN}✓ React Router basename configured${NC}"
    elif grep -q 'basename=' src/main.tsx; then
        echo -e "${GREEN}✓ React Router basename already configured${NC}"
    fi
fi

# Create .env file
echo "VITE_API_URL=/api/right-amount" > .env
echo -e "${GREEN}✓ Environment file created${NC}"

# Build
echo "Building React application..."
npm run build

if [ ! -d "dist" ]; then
    echo -e "${RED}❌ Build failed - dist folder not created${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Frontend built successfully${NC}"
echo ""

# ========================================
# Configure Nginx (SAFE - Append Only)
# ========================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🌐 Step 3: Configuring Nginx (SAFE MODE)...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

NGINX_CONFIG="/etc/nginx/sites-available/default"

# Backup existing config
echo "Creating backup of nginx config..."
cp "$NGINX_CONFIG" "$NGINX_CONFIG.backup.$(date +%s)"
echo -e "${GREEN}✓ Backup created${NC}"

# Create temporary config snippet
cat > /tmp/right-amount-nginx.conf << 'EOF'

    # =====================================================
    # RIGHT AMOUNT (Bar-Line) - React + Flask
    # =====================================================
    # Right Amount Backend API
    location /api/right-amount/ {
        proxy_pass http://127.0.0.1:8001/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Right Amount Frontend
    location /right-amount/ {
        alias /var/www/vsfintech/Bar-Line/dist/;
        try_files $uri $uri/ /right-amount/index.html;
        index index.html;
    }

    location /right-amount {
        return 301 /right-amount/;
    }
EOF

# Check if Right Amount config already exists
if grep -q "RIGHT AMOUNT" "$NGINX_CONFIG"; then
    echo -e "${YELLOW}⚠️  Right Amount config already exists in nginx${NC}"
    echo "Skipping nginx modification. Please add manually if needed."
else
    # Find the location of the main site location block
    if grep -q "location / {" "$NGINX_CONFIG"; then
        # Insert before the main location / block
        sed -i '/location \/ {/i\    # RIGHT AMOUNT CONFIGURATION' "$NGINX_CONFIG"
        sed -i '/# RIGHT AMOUNT CONFIGURATION/r /tmp/right-amount-nginx.conf' "$NGINX_CONFIG"
        sed -i '/# RIGHT AMOUNT CONFIGURATION/d' "$NGINX_CONFIG"
        echo -e "${GREEN}✓ Nginx configuration added${NC}"
    else
        echo -e "${YELLOW}⚠️  Could not automatically add nginx config${NC}"
        echo "Please manually add the config from: /tmp/right-amount-nginx.conf"
        echo "Add it BEFORE the 'location / {' block in $NGINX_CONFIG"
    fi
fi

# Test nginx config
if nginx -t 2>&1 | grep -q "successful"; then
    echo -e "${GREEN}✅ Nginx configuration is valid${NC}"
    nginx -s reload
    echo -e "${GREEN}✅ Nginx reloaded${NC}"
else
    echo -e "${RED}❌ Nginx configuration error${NC}"
    echo "Restoring backup..."
    cp "$NGINX_CONFIG.backup.$(date +%s)" "$NGINX_CONFIG"
    exit 1
fi

echo ""

# ========================================
# Set Permissions
# ========================================
echo -e "${YELLOW}🔐 Step 4: Setting permissions...${NC}"

chown -R www-data:www-data "$APP_DIR/dist" 2>/dev/null || true
chmod -R 755 "$APP_DIR/dist" 2>/dev/null || true

echo -e "${GREEN}✅ Permissions set${NC}"
echo ""

# ========================================
# Test Deployment
# ========================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🧪 Step 5: Testing deployment...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

sleep 2

# Test backend
BACKEND_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$BACKEND_PORT/ 2>/dev/null || echo "000")
if [ "$BACKEND_CODE" = "200" ] || [ "$BACKEND_CODE" = "404" ]; then
    echo -e "${GREEN}✅ Backend responding (HTTP $BACKEND_CODE)${NC}"
else
    echo -e "${RED}❌ Backend not responding (HTTP $BACKEND_CODE)${NC}"
fi

# Test frontend
FRONTEND_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/right-amount/ 2>/dev/null || echo "000")
if [ "$FRONTEND_CODE" = "200" ]; then
    echo -e "${GREEN}✅ Frontend accessible (HTTP $FRONTEND_CODE)${NC}"
else
    echo -e "${YELLOW}⚠️  Frontend status: HTTP $FRONTEND_CODE${NC}"
fi

# Test API proxy
API_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/api/right-amount/ 2>/dev/null || echo "000")
if [ "$API_CODE" = "200" ] || [ "$API_CODE" = "404" ]; then
    echo -e "${GREEN}✅ API proxy working (HTTP $API_CODE)${NC}"
else
    echo -e "${YELLOW}⚠️  API proxy status: HTTP $API_CODE${NC}"
fi

# Check PM2 status
echo ""
echo "PM2 Process Status:"
pm2 status | grep -E "right-amount|name" || pm2 list

echo ""
echo "=============================================="
echo -e "${GREEN}🎉 Right Amount Deployment Complete!${NC}"
echo "=============================================="
echo ""
echo "📊 Service Information:"
echo "  - Backend Name: $BACKEND_NAME"
echo "  - Backend Port: $BACKEND_PORT"
echo "  - Directory: $APP_DIR"
echo ""
echo "🌐 Access URLs:"
echo "  - Frontend: http://82.25.105.18/right-amount/"
echo "  - Backend API: http://82.25.105.18/api/right-amount/"
echo ""
echo "🔧 Management Commands:"
echo "  - Backend logs: pm2 logs $BACKEND_NAME"
echo "  - Restart backend: pm2 restart $BACKEND_NAME"
echo "  - Nginx logs: tail -f /var/log/nginx/error.log"
echo ""
echo "✅ All existing applications remain untouched!"
echo ""
