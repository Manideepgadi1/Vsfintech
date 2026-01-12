#!/bin/bash
# Quick Sector Heatmap Fix - Run this NOW on your VPS

echo "🚀 Quick Fix: Sector Heatmap"
echo "============================"

# Check if Heatmap directory exists
if [ ! -d "/var/www/vsfintech/Heatmap" ]; then
    echo "❌ Heatmap directory not found!"
    echo "Please upload your Heatmap code first"
    exit 1
fi

cd /var/www/vsfintech/Heatmap

# Check structure
echo "Checking structure..."
if [ -d "frontend" ] && [ -d "backend" ]; then
    echo "✅ Frontend and backend folders found"
    
    # Deploy Backend
    echo ""
    echo "📦 Deploying Backend..."
    cd backend
    
    if [ ! -d "venv" ]; then
        python3 -m venv venv
    fi
    
    source venv/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt 2>/dev/null || pip install fastapi uvicorn pandas numpy
    deactivate
    
    pm2 stop heatmap-backend 2>/dev/null
    pm2 delete heatmap-backend 2>/dev/null
    pm2 start venv/bin/uvicorn --name heatmap-backend --cwd /var/www/vsfintech/Heatmap/backend --interpreter none -- main:app --host 0.0.0.0 --port 8002
    pm2 save
    
    echo "✅ Backend deployed on port 8002"
    
    # Deploy Frontend
    echo ""
    echo "📦 Deploying Frontend..."
    cd ../frontend
    
    # Update vite config
    if [ -f "vite.config.ts" ]; then
        sed -i "s|base:.*|base: '/sector-heatmap',|" vite.config.ts
    fi
    
    # Update React Router
    if [ -f "src/main.tsx" ]; then
        sed -i 's|<BrowserRouter>|<BrowserRouter basename="/sector-heatmap">|' src/main.tsx
    fi
    
    # Create env
    echo "VITE_API_URL=/api/heatmap" > .env
    
    # Build
    npm install
    npm run build
    
    echo "✅ Frontend built"
    
    # Fix permissions
    chown -R www-data:www-data /var/www/vsfintech/Heatmap
    chmod -R 755 /var/www/vsfintech/Heatmap
    
    # Reload nginx
    nginx -t && systemctl reload nginx
    
    echo ""
    echo "✅ DONE!"
    echo "Access: http://82.25.105.18/sector-heatmap/"
    
else
    echo "❌ Structure issue - need frontend/ and backend/ folders"
    ls -la
fi
