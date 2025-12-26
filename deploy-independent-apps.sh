#!/bin/bash

# Complete Independent Deployment for All VS Fintech Applications
# Each app works independently - no cross-dependencies
# Run this on VPS: bash deploy-independent-apps.sh

set -e  # Exit on error

echo "================================================="
echo "VS Fintech - Independent Apps Deployment"
echo "================================================="
echo ""

BASE_DIR="/var/www/vsfintech"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Fixing React Apps - Vite Base Configuration${NC}"
echo ""

# ========================================
# Fix AlphaNifty - Independent Deployment
# ========================================
echo -e "${YELLOW}1. AlphaNifty - Independent Deployment${NC}"
cd $BASE_DIR/ALPHANIFTYY

# Backup files
cp src/main.tsx src/main.tsx.backup 2>/dev/null || true
cp vite.config.ts vite.config.ts.backup 2>/dev/null || true

# Fix Vite config - set base to root for independent deployment
if grep -q "base:" vite.config.ts; then
    sed -i "s|base:.*|base: '/',|" vite.config.ts
else
    sed -i "/export default defineConfig({/a\\  base: '/'," vite.config.ts
fi

# Set API URL to direct backend port
echo "VITE_API_URL=http://82.25.105.18:8003" > .env

echo "Building AlphaNifty..."
npm run build
echo -e "${GREEN}✓ AlphaNifty built successfully${NC}"
echo ""

# ========================================
# Fix Bar-Line (Right Amount) - Independent
# ========================================
echo -e "${YELLOW}2. Bar-Line (Right Amount) - Independent Deployment${NC}"
cd $BASE_DIR/Bar-Line

cp src/main.tsx src/main.tsx.backup 2>/dev/null || true
cp vite.config.ts vite.config.ts.backup 2>/dev/null || true

if grep -q "base:" vite.config.ts; then
    sed -i "s|base:.*|base: '/',|" vite.config.ts
else
    sed -i "/export default defineConfig({/a\\  base: '/'," vite.config.ts
fi

echo "VITE_API_URL=http://82.25.105.18:8001" > .env

echo "Building Bar-Line..."
npm run build
echo -e "${GREEN}✓ Bar-Line built successfully${NC}"
echo ""

# ========================================
# Fix Heatmap (Sector Heatmap) - Independent
# ========================================
echo -e "${YELLOW}3. Heatmap (Sector Heatmap) - Independent Deployment${NC}"
cd $BASE_DIR/Heatmap/frontend

cp src/main.tsx src/main.tsx.backup 2>/dev/null || true
cp vite.config.ts vite.config.ts.backup 2>/dev/null || true

if grep -q "base:" vite.config.ts; then
    sed -i "s|base:.*|base: '/',|" vite.config.ts
else
    sed -i "/export default defineConfig({/a\\  base: '/'," vite.config.ts
fi

echo "VITE_API_URL=http://82.25.105.18:8002" > .env

echo "Building Heatmap..."
npm run build
echo -e "${GREEN}✓ Heatmap built successfully${NC}"
echo ""

# ========================================
# Create Nginx Configuration - Independent Apps
# ========================================
echo -e "${YELLOW}4. Creating Nginx Configuration for Independent Apps${NC}"

cat > /etc/nginx/sites-available/vsfintech-independent << 'NGINX_EOF'
# Main VS Fintech Platform
server {
    listen 80 default_server;
    server_name 82.25.105.18 vsfintech.com www.vsfintech.com;
    
    root /var/www/vsfintech/VSFintech-Platform/frontend/dist;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location /api/ {
        proxy_pass http://localhost:8000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

# AlphaNifty - Port 9001
server {
    listen 9001;
    server_name 82.25.105.18;
    
    root /var/www/vsfintech/ALPHANIFTYY/dist;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}

# Bar-Line (Right Amount) - Port 9002
server {
    listen 9002;
    server_name 82.25.105.18;
    
    root /var/www/vsfintech/Bar-Line/dist;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}

# Heatmap (Sector Heatmap) - Port 9003
server {
    listen 9003;
    server_name 82.25.105.18;
    
    root /var/www/vsfintech/Heatmap/frontend/dist;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}

# PMS Screener - Port 3003 (already configured in backend)
# Access at: http://82.25.105.18:3003

# Right Sector - Port 9004
server {
    listen 9004;
    server_name 82.25.105.18;
    
    root /var/www/vsfintech/Right-Sector/dist;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}

# Risk-Reward - Port 5000 (already configured in backend)
# Access at: http://82.25.105.18:5000

# Risk-Return - Port 9005
server {
    listen 9005;
    server_name 82.25.105.18;
    
    root /var/www/vsfintech/Risk-Return;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}

# Riskometer - Port 5002 (already configured in backend)
# Access at: http://82.25.105.18:5002

# Multichart - Port 9006
server {
    listen 9006;
    server_name 82.25.105.18;
    
    root /var/www/vsfintech/Multichart;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}
NGINX_EOF

echo -e "${GREEN}✓ Nginx configuration created${NC}"

# Remove old config and enable new one
rm -f /etc/nginx/sites-enabled/vsfintech 2>/dev/null || true
ln -sf /etc/nginx/sites-available/vsfintech-independent /etc/nginx/sites-enabled/

# Test nginx
echo "Testing nginx configuration..."
nginx -t

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Nginx configuration valid${NC}"
    systemctl reload nginx
    echo -e "${GREEN}✓ Nginx reloaded${NC}"
else
    echo -e "${RED}✗ Nginx configuration error${NC}"
    exit 1
fi

echo ""

# ========================================
# Restart All Backend Services
# ========================================
echo -e "${YELLOW}5. Restarting All Backend Services${NC}"
cd $BASE_DIR/VSFintech-Platform
pm2 restart all
pm2 save
echo -e "${GREEN}✓ All services restarted${NC}"
echo ""

# ========================================
# Verification
# ========================================
echo -e "${YELLOW}6. Verifying All Services${NC}"
echo ""

echo "PM2 Status:"
pm2 status
echo ""

echo "Testing Backend Services:"
curl -s -o /dev/null -w "VS Fintech Backend (8000): %{http_code}\n" http://localhost:8000/ || echo "VS Fintech Backend: Failed"
curl -s -o /dev/null -w "AlphaNifty Backend (8003): %{http_code}\n" http://localhost:8003/ || echo "AlphaNifty Backend: Failed"
curl -s -o /dev/null -w "Bar-Line Backend (8001): %{http_code}\n" http://localhost:8001/ || echo "Bar-Line Backend: Failed"
curl -s -o /dev/null -w "Heatmap Backend (8002): %{http_code}\n" http://localhost:8002/ || echo "Heatmap Backend: Failed"
curl -s -o /dev/null -w "PMS Screener (3003): %{http_code}\n" http://localhost:3003/ || echo "PMS Screener: Failed"
curl -s -o /dev/null -w "Risk-Reward (5000): %{http_code}\n" http://localhost:5000/ || echo "Risk-Reward: Failed"
curl -s -o /dev/null -w "Riskometer (5002): %{http_code}\n" http://localhost:5002/ || echo "Riskometer: Failed"

echo ""
echo "Testing Frontend Services:"
curl -s -o /dev/null -w "Main Platform (80): %{http_code}\n" http://localhost:80/ || echo "Main Platform: Failed"
curl -s -o /dev/null -w "AlphaNifty Frontend (9001): %{http_code}\n" http://localhost:9001/ || echo "AlphaNifty Frontend: Failed"
curl -s -o /dev/null -w "Bar-Line Frontend (9002): %{http_code}\n" http://localhost:9002/ || echo "Bar-Line Frontend: Failed"
curl -s -o /dev/null -w "Heatmap Frontend (9003): %{http_code}\n" http://localhost:9003/ || echo "Heatmap Frontend: Failed"
curl -s -o /dev/null -w "Right Sector (9004): %{http_code}\n" http://localhost:9004/ || echo "Right Sector: Failed"
curl -s -o /dev/null -w "Risk-Return (9005): %{http_code}\n" http://localhost:9005/ || echo "Risk-Return: Failed"
curl -s -o /dev/null -w "Multichart (9006): %{http_code}\n" http://localhost:9006/ || echo "Multichart: Failed"

echo ""
echo -e "${GREEN}=================================================${NC}"
echo -e "${GREEN}All Apps Deployed Independently!${NC}"
echo -e "${GREEN}=================================================${NC}"
echo ""
echo "Access your apps at:"
echo ""
echo "  Main Platform:     http://82.25.105.18"
echo "  AlphaNifty:        http://82.25.105.18:9001"
echo "  Right Amount:      http://82.25.105.18:9002"
echo "  Sector Heatmap:    http://82.25.105.18:9003"
echo "  Right Sector:      http://82.25.105.18:9004"
echo "  Risk-Return:       http://82.25.105.18:9005"
echo "  Multichart:        http://82.25.105.18:9006"
echo ""
echo "  PMS Screener:      http://82.25.105.18:3003"
echo "  Risk-Reward:       http://82.25.105.18:5000"
echo "  Riskometer:        http://82.25.105.18:5002"
echo ""
echo -e "${YELLOW}Backend APIs:${NC}"
echo "  VS Fintech API:    http://82.25.105.18:8000"
echo "  AlphaNifty API:    http://82.25.105.18:8003"
echo "  Bar-Line API:      http://82.25.105.18:8001"
echo "  Heatmap API:       http://82.25.105.18:8002"
echo ""
echo -e "${GREEN}All apps are now completely independent!${NC}"
echo ""
