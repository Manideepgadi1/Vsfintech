#!/bin/bash
# Fix BOTH Sector Heatmap AND AlphaNifty - No More Conflicts!

echo "🔧 Fixing Nginx Conflicts - AlphaNifty + Sector Heatmap"
echo "======================================================"

# Backup current nginx config
cp /etc/nginx/sites-available/vsfintech.conf /etc/nginx/sites-available/vsfintech.conf.backup.$(date +%Y%m%d_%H%M%S)

# Create a clean nginx config with BOTH apps properly configured
cat > /etc/nginx/sites-available/vsfintech.conf << 'NGINX_END'
server {
    listen 80;
    server_name 82.25.105.18;
    
    # Main VS Fintech Platform
    root /var/www/vsfintech/VSFintech-Platform/frontend/dist;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # VS Fintech Platform Backend API
    location /api/ {
        proxy_pass http://localhost:8000/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    
    # ========================================
    # ALPHANIFTY - React App + Backend
    # ========================================
    location /alphanifty/ {
        alias /var/www/vsfintech/ALPHANIFTYY/dist/;
        try_files $uri $uri/ /alphanifty/index.html;
        add_header Cache-Control "no-cache";
    }
    
    location = /alphanifty {
        return 301 /alphanifty/;
    }
    
    # AlphaNifty Backend API
    location /alphanifty/api/ {
        proxy_pass http://localhost:8003/api/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    
    # ========================================
    # SECTOR HEATMAP - React App + Backend
    # ========================================
    location /sector-heatmap/ {
        alias /var/www/vsfintech/Heatmap/frontend/dist/;
        try_files $uri $uri/ /sector-heatmap/index.html;
        add_header Cache-Control "no-cache";
    }
    
    location = /sector-heatmap {
        return 301 /sector-heatmap/;
    }
    
    # Sector Heatmap Backend API
    location /api/heatmap/ {
        proxy_pass http://localhost:8002/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    
    # ========================================
    # RIGHT AMOUNT (Bar-Line) - React App + Backend
    # ========================================
    location /right-amount/ {
        alias /var/www/vsfintech/Bar-Line/dist/;
        try_files $uri $uri/ /right-amount/index.html;
        add_header Cache-Control "no-cache";
    }
    
    location = /right-amount {
        return 301 /right-amount/;
    }
    
    # Right Amount Backend API
    location /api/right-amount/ {
        proxy_pass http://localhost:8001/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    
    # ========================================
    # OTHER APPS (add as needed)
    # ========================================
    
    # Risk-Reward (Flask)
    location /risk-reward {
        proxy_pass http://localhost:5000/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # Risk-Return (Static HTML)
    location /risk-return/ {
        alias /var/www/vsfintech/Risk-Return/;
        try_files $uri $uri/ /risk-return/index.html;
        index index.html;
    }
    
    # Riskometer
    location /riskometer {
        proxy_pass http://localhost:5002/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
    }
    
    # PMS Screener
    location /pms-screener/ {
        proxy_pass http://localhost:3003/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
    }
}
NGINX_END

echo "✓ Nginx config created"

# Test nginx config
if nginx -t; then
    echo "✅ Nginx config is valid"
else
    echo "❌ Nginx config error - restoring backup"
    cp /etc/nginx/sites-available/vsfintech.conf.backup.* /etc/nginx/sites-available/vsfintech.conf
    exit 1
fi

# Now fix AlphaNifty frontend to use correct API path
echo ""
echo "🔧 Fixing AlphaNifty frontend..."
cd /var/www/vsfintech/ALPHANIFTYY

# Update vite config
if [ -f "vite.config.ts" ]; then
    if ! grep -q "base: '/alphanifty'" vite.config.ts; then
        sed -i "s|base:.*|base: '/alphanifty',|" vite.config.ts
        echo "✓ Updated vite.config.ts"
    fi
fi

# Update React Router
if [ -f "src/main.tsx" ]; then
    if grep -q "<BrowserRouter>" src/main.tsx && ! grep -q 'basename="/alphanifty"' src/main.tsx; then
        sed -i 's|<BrowserRouter>|<BrowserRouter basename="/alphanifty">|' src/main.tsx
        echo "✓ Updated React Router basename"
    fi
fi

# Create .env with correct API path
echo 'VITE_API_URL=/alphanifty/api' > .env
echo "✓ Created .env with API path"

# Rebuild AlphaNifty
npm install
npm run build
echo "✅ AlphaNifty rebuilt"

# Fix Sector Heatmap frontend
echo ""
echo "🔧 Fixing Sector Heatmap frontend..."
cd /var/www/vsfintech/Heatmap/frontend

# Update vite config
if [ -f "vite.config.ts" ]; then
    if ! grep -q "base: '/sector-heatmap'" vite.config.ts; then
        sed -i "s|base:.*|base: '/sector-heatmap',|" vite.config.ts
        echo "✓ Updated vite.config.ts"
    fi
fi

# Update React Router
if [ -f "src/main.tsx" ]; then
    if grep -q "<BrowserRouter>" src/main.tsx && ! grep -q 'basename="/sector-heatmap"' src/main.tsx; then
        sed -i 's|<BrowserRouter>|<BrowserRouter basename="/sector-heatmap">|' src/main.tsx
        echo "✓ Updated React Router basename"
    fi
fi

# Create .env with correct API path
echo 'VITE_API_URL=/api/heatmap' > .env
echo "✓ Created .env with API path"

# Rebuild Sector Heatmap
npm install
npm run build
echo "✅ Sector Heatmap rebuilt"

# Fix permissions
echo ""
echo "🔐 Fixing permissions..."
chown -R www-data:www-data /var/www/vsfintech/ALPHANIFTYY
chown -R www-data:www-data /var/www/vsfintech/Heatmap
chmod -R 755 /var/www/vsfintech/ALPHANIFTYY
chmod -R 755 /var/www/vsfintech/Heatmap

# Reload nginx
systemctl reload nginx
echo "✅ Nginx reloaded"

# Check PM2 backends
echo ""
echo "📊 Checking backend services..."
pm2 status | grep -E "alphanifty|heatmap|name"

echo ""
echo "🧪 Testing..."
sleep 2

# Test AlphaNifty
ALPHA_FRONT=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/alphanifty/ 2>/dev/null)
ALPHA_BACK=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8003/ 2>/dev/null)
echo "AlphaNifty Frontend: HTTP $ALPHA_FRONT"
echo "AlphaNifty Backend: HTTP $ALPHA_BACK"

# Test Sector Heatmap
HEAT_FRONT=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/sector-heatmap/ 2>/dev/null)
HEAT_BACK=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8002/ 2>/dev/null)
echo "Sector Heatmap Frontend: HTTP $HEAT_FRONT"
echo "Sector Heatmap Backend: HTTP $HEAT_BACK"

echo ""
echo "============================================"
echo "✅ FIX COMPLETE!"
echo "============================================"
echo ""
echo "Both apps now use separate API paths:"
echo "  - AlphaNifty API: /alphanifty/api/"
echo "  - Sector Heatmap API: /api/heatmap/"
echo ""
echo "Access URLs:"
echo "  - AlphaNifty: http://82.25.105.18/alphanifty/"
echo "  - Sector Heatmap: http://82.25.105.18/sector-heatmap/"
echo ""
echo "Clear browser cache (Ctrl+Shift+Delete) and refresh!"
echo ""
