#!/bin/bash

# Investment Calculator SAFE Deployment Script
# This script will NOT disturb any existing applications
# Frontend: /investment-calculator/ | Backend Port: 5003 | API: /api/investment-calculator/
# Server: 82.25.105.18

set -e  # Exit on error

echo "🚀 Investment Calculator SAFE Deployment"
echo "=========================================="
echo ""

# Configuration
APP_NAME="investment-calculator"
BACKEND_NAME="investment-calculator-backend"
APP_DIR="/var/www/vsfintech/Investment-Calculator"
BACKEND_PORT=5003
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
    echo "Please upload your Investment-Calculator code to $APP_DIR first"
    exit 1
fi

echo -e "${YELLOW}📋 Checking prerequisites...${NC}"

# Check if it's a React app or static HTML
IS_REACT=false
if [ -f "$APP_DIR/package.json" ]; then
    IS_REACT=true
    echo -e "${GREEN}✓ React application detected${NC}"
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js not found. Please install Node.js first${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Node.js: $(node -v)${NC}"
else
    echo -e "${GREEN}✓ Static HTML application detected${NC}"
fi

# Check if backend exists
HAS_BACKEND=false
if [ -d "$APP_DIR/backend" ] && ([ -f "$APP_DIR/backend/server.py" ] || [ -f "$APP_DIR/backend/app.py" ]); then
    HAS_BACKEND=true
    echo -e "${GREEN}✓ Backend found${NC}"
    
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
else
    echo -e "${YELLOW}ℹ️  No backend found (static app)${NC}"
fi

echo ""

# ========================================
# Deploy Backend (if exists)
# ========================================
if [ "$HAS_BACKEND" = true ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}📦 Step 1: Deploying Backend (Flask)...${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    cd "$APP_DIR/backend"

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
fi

# ========================================
# Deploy Frontend
# ========================================
if [ "$IS_REACT" = true ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}📦 Step 2: Deploying Frontend (React + Vite)...${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    cd "$APP_DIR"

    # Install npm dependencies
    echo "Installing npm dependencies..."
    npm install -q

    # Configure vite.config
    echo "Configuring Vite for /investment-calculator subpath..."
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
            sed -i "s|base:.*|base: '/investment-calculator',|" "$VITE_CONFIG"
        else
            sed -i "/export default defineConfig({/a\\  base: '/investment-calculator'," "$VITE_CONFIG"
        fi
        echo -e "${GREEN}✓ Vite config updated${NC}"
    fi

    # Configure React Router
    if [ -f "src/main.tsx" ]; then
        cp src/main.tsx "src/main.tsx.backup.$(date +%s)" 2>/dev/null || true
        
        if grep -q "<BrowserRouter>" src/main.tsx && ! grep -q 'basename=' src/main.tsx; then
            sed -i 's|<BrowserRouter>|<BrowserRouter basename="/investment-calculator">|' src/main.tsx
            echo -e "${GREEN}✓ React Router basename configured${NC}"
        elif grep -q 'basename=' src/main.tsx; then
            echo -e "${GREEN}✓ React Router basename already configured${NC}"
        fi
    fi

    # Create .env file
    if [ "$HAS_BACKEND" = true ]; then
        echo "VITE_API_URL=/api/investment-calculator" > .env
        echo -e "${GREEN}✓ Environment file created${NC}"
    fi

    # Build
    echo "Building React application..."
    npm run build

    if [ ! -d "dist" ]; then
        echo -e "${RED}❌ Build failed - dist folder not created${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Frontend built successfully${NC}"
    FRONTEND_PATH="$APP_DIR/dist"
else
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}📦 Step 2: Configuring Static Frontend...${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    FRONTEND_PATH="$APP_DIR"
    echo -e "${GREEN}✓ Static files ready${NC}"
fi

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
if [ "$HAS_BACKEND" = true ]; then
    cat > /tmp/investment-calculator-nginx.conf << 'EOF'

    # =====================================================
    # INVESTMENT CALCULATOR - Financial Planning Tool
    # =====================================================
    # Investment Calculator Backend API
    location /api/investment-calculator/ {
        proxy_pass http://127.0.0.1:5003/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Prefix /investment-calculator;
    }

    # Investment Calculator Frontend
    location /investment-calculator/ {
        alias FRONTEND_PATH_PLACEHOLDER/;
        try_files $uri $uri/ /investment-calculator/index.html;
        index index.html;
    }

    location /investment-calculator {
        return 301 /investment-calculator/;
    }
EOF
else
    cat > /tmp/investment-calculator-nginx.conf << 'EOF'

    # =====================================================
    # INVESTMENT CALCULATOR - Financial Planning Tool (Static)
    # =====================================================
    location /investment-calculator/ {
        alias FRONTEND_PATH_PLACEHOLDER/;
        try_files $uri $uri/ /investment-calculator/index.html;
        index index.html;
    }

    location /investment-calculator {
        return 301 /investment-calculator/;
    }
EOF
fi

# Replace placeholder with actual path
sed -i "s|FRONTEND_PATH_PLACEHOLDER|$FRONTEND_PATH|g" /tmp/investment-calculator-nginx.conf

# Check if Investment Calculator config already exists
if grep -q "INVESTMENT CALCULATOR" "$NGINX_CONFIG"; then
    echo -e "${YELLOW}⚠️  Investment Calculator config already exists in nginx${NC}"
    echo "Skipping nginx modification. Please add manually if needed."
else
    # Insert before the main location / block
    if grep -q "location / {" "$NGINX_CONFIG"; then
        sed -i '/location \/ {/i\    # INVESTMENT CALCULATOR CONFIGURATION' "$NGINX_CONFIG"
        sed -i '/# INVESTMENT CALCULATOR CONFIGURATION/r /tmp/investment-calculator-nginx.conf' "$NGINX_CONFIG"
        sed -i '/# INVESTMENT CALCULATOR CONFIGURATION/d' "$NGINX_CONFIG"
        echo -e "${GREEN}✓ Nginx configuration added${NC}"
    else
        echo -e "${YELLOW}⚠️  Could not automatically add nginx config${NC}"
        echo "Please manually add the config from: /tmp/investment-calculator-nginx.conf"
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
    LATEST_BACKUP=$(ls -t "$NGINX_CONFIG.backup."* | head -1)
    cp "$LATEST_BACKUP" "$NGINX_CONFIG"
    exit 1
fi

echo ""

# ========================================
# Set Permissions
# ========================================
echo -e "${YELLOW}🔐 Step 4: Setting permissions...${NC}"

chown -R www-data:www-data "$FRONTEND_PATH" 2>/dev/null || true
chmod -R 755 "$FRONTEND_PATH" 2>/dev/null || true

echo -e "${GREEN}✅ Permissions set${NC}"
echo ""

# ========================================
# Test Deployment
# ========================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🧪 Step 5: Testing deployment...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

sleep 2

# Test backend if exists
if [ "$HAS_BACKEND" = true ]; then
    BACKEND_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$BACKEND_PORT/ 2>/dev/null || echo "000")
    if [ "$BACKEND_CODE" = "200" ] || [ "$BACKEND_CODE" = "404" ]; then
        echo -e "${GREEN}✅ Backend responding (HTTP $BACKEND_CODE)${NC}"
    else
        echo -e "${RED}❌ Backend not responding (HTTP $BACKEND_CODE)${NC}"
    fi
fi

# Test frontend
FRONTEND_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/investment-calculator/ 2>/dev/null || echo "000")
if [ "$FRONTEND_CODE" = "200" ]; then
    echo -e "${GREEN}✅ Frontend accessible (HTTP $FRONTEND_CODE)${NC}"
else
    echo -e "${YELLOW}⚠️  Frontend status: HTTP $FRONTEND_CODE${NC}"
fi

# Check PM2 status if backend exists
if [ "$HAS_BACKEND" = true ]; then
    echo ""
    echo "PM2 Process Status:"
    pm2 status | grep -E "investment-calculator|name" || pm2 list
fi

echo ""
echo "=============================================="
echo -e "${GREEN}🎉 Investment Calculator Deployment Complete!${NC}"
echo "=============================================="
echo ""
echo "📊 Service Information:"
if [ "$HAS_BACKEND" = true ]; then
    echo "  - Backend Name: $BACKEND_NAME"
    echo "  - Backend Port: $BACKEND_PORT"
fi
echo "  - Type: $([ "$IS_REACT" = true ] && echo "React Application" || echo "Static HTML")"
echo "  - Directory: $APP_DIR"
echo ""
echo "🌐 Access URLs:"
echo "  - Frontend: http://82.25.105.18/investment-calculator/"
if [ "$HAS_BACKEND" = true ]; then
    echo "  - Backend API: http://82.25.105.18/api/investment-calculator/"
fi
echo ""
if [ "$HAS_BACKEND" = true ]; then
    echo "🔧 Management Commands:"
    echo "  - Backend logs: pm2 logs $BACKEND_NAME"
    echo "  - Restart backend: pm2 restart $BACKEND_NAME"
    echo "  - Nginx logs: tail -f /var/log/nginx/error.log"
fi
echo ""
echo "✅ All existing applications remain untouched!"
echo ""
