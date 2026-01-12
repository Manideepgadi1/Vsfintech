#!/bin/bash
# Quick Right Amount (Bar-Line) Deployment - Run NOW on your VPS

echo "🚀 Quick Deploy: Right Amount (Bar-Line)"
echo "========================================"

# Check if Bar-Line directory exists
if [ ! -d "/var/www/vsfintech/Bar-Line" ]; then
    echo "❌ Bar-Line directory not found!"
    echo "Please upload your Bar-Line code first"
    exit 1
fi

cd /var/www/vsfintech/Bar-Line

echo "Checking structure..."

# Deploy Backend (Flask)
if [ -d "backend" ]; then
    echo ""
    echo "📦 Deploying Backend (Flask)..."
    cd backend
    
    if [ ! -d "venv" ]; then
        python3 -m venv venv
    fi
    
    source venv/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt 2>/dev/null || pip install flask gunicorn flask-cors pandas numpy
    deactivate
    
    pm2 stop bar-line-backend 2>/dev/null
    pm2 delete bar-line-backend 2>/dev/null
    
    # Check for server.py or app.py
    if [ -f "server.py" ]; then
        ENTRY="server:app"
    else
        ENTRY="app:app"
    fi
    
    pm2 start venv/bin/gunicorn --name bar-line-backend --cwd /var/www/vsfintech/Bar-Line/backend --interpreter none -- -w 2 -b 0.0.0.0:8001 $ENTRY
    pm2 save
    
    echo "✅ Backend deployed on port 8001"
    cd ..
fi

# Deploy Frontend (React + Vite)
echo ""
echo "📦 Deploying Frontend..."

if [ ! -f "package.json" ]; then
    echo "❌ package.json not found in Bar-Line root"
    exit 1
fi

# Backup and update vite.config
if [ -f "vite.config.ts" ]; then
    cp vite.config.ts vite.config.ts.backup 2>/dev/null
    # Update base path
    if grep -q "base:" vite.config.ts; then
        sed -i "s|base:.*|base: '/right-amount',|" vite.config.ts
    else
        sed -i "/export default defineConfig({/a\\  base: '/right-amount'," vite.config.ts
    fi
    echo "✓ Vite config updated"
fi

# Update React Router basename
if [ -f "src/main.tsx" ]; then
    cp src/main.tsx src/main.tsx.backup 2>/dev/null
    if grep -q "<BrowserRouter>" src/main.tsx && ! grep -q 'basename="/right-amount"' src/main.tsx; then
        sed -i 's|<BrowserRouter>|<BrowserRouter basename="/right-amount">|' src/main.tsx
        echo "✓ React Router basename configured"
    fi
fi

# Create .env
echo "VITE_API_URL=/api/right-amount" > .env
echo "✓ Environment file created"

# Install and build
echo "Installing dependencies..."
npm install

echo "Building application..."
npm run build

if [ ! -d "dist" ]; then
    echo "❌ Build failed - dist folder not created"
    exit 1
fi

echo "✅ Frontend built"

# Configure Nginx - Port 9002
echo ""
echo "🌐 Configuring Nginx..."

cat > /etc/nginx/sites-available/right-amount-9002.conf << 'EOF'
# Right Amount - Port 9002
server {
    listen 9002;
    server_name 82.25.105.18;
    
    root /var/www/vsfintech/Bar-Line/dist;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location /api/ {
        proxy_pass http://localhost:8001/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;
}
EOF

ln -sf /etc/nginx/sites-available/right-amount-9002.conf /etc/nginx/sites-enabled/

# Update main config for /right-amount
MAIN_CONFIG="/etc/nginx/sites-available/vsfintech.conf"

if [ -f "$MAIN_CONFIG" ]; then
    if ! grep -q "location /right-amount" "$MAIN_CONFIG"; then
        # Backup
        cp "$MAIN_CONFIG" "$MAIN_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Add right-amount locations
        sed -i '/^}/i \
    # Right Amount (Bar-Line)\
    location /right-amount/ {\
        alias /var/www/vsfintech/Bar-Line/dist/;\
        try_files $uri $uri/ /right-amount/index.html;\
        add_header Cache-Control "no-cache";\
    }\
    \
    location = /right-amount {\
        return 301 /right-amount/;\
    }\
    \
    location /api/right-amount/ {\
        proxy_pass http://localhost:8001/;\
        proxy_http_version 1.1;\
        proxy_set_header Upgrade $http_upgrade;\
        proxy_set_header Connection '"'"'upgrade'"'"';\
        proxy_set_header Host $host;\
        proxy_cache_bypass $http_upgrade;\
        proxy_set_header X-Real-IP $remote_addr;\
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\
    }\
' "$MAIN_CONFIG"
        echo "✓ Added to main config"
    else
        echo "✓ Already in main config"
    fi
fi

# Test and reload nginx
if nginx -t; then
    systemctl reload nginx
    echo "✅ Nginx reloaded"
else
    echo "❌ Nginx config error"
    exit 1
fi

# Fix permissions
chown -R www-data:www-data /var/www/vsfintech/Bar-Line
chmod -R 755 /var/www/vsfintech/Bar-Line

echo ""
echo "🧪 Testing..."
sleep 2

# Test backend
BACKEND_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8001/ 2>/dev/null || echo "000")
echo "Backend (8001): HTTP $BACKEND_CODE"

# Test frontend
FRONTEND_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/right-amount/ 2>/dev/null || echo "000")
echo "Frontend (main): HTTP $FRONTEND_CODE"

PORT_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9002/ 2>/dev/null || echo "000")
echo "Frontend (9002): HTTP $PORT_CODE"

echo ""
echo "================================"
echo "✅ Right Amount Deployed!"
echo "================================"
echo ""
echo "Access URLs:"
echo "  - Main Site: http://82.25.105.18/right-amount/"
echo "  - Independent: http://82.25.105.18:9002"
echo "  - Backend API: http://82.25.105.18:8001"
echo ""
echo "PM2 Status:"
pm2 status | grep -E "bar-line|name"
echo ""
