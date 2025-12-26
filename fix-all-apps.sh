#!/bin/bash

# Comprehensive fix script for all VSFintech applications
# Run this on the VPS: bash fix-all-apps.sh

set -e

echo "========================================="
echo "VSFintech Platform - Fix All Applications"
echo "========================================="

cd /var/www/vsfintech

# 1. Fix AlphaNifty - Add basename to React Router
echo ""
echo "1. Fixing AlphaNifty React Router..."
cd ALPHANIFTYY
if [ -f "src/main.tsx" ]; then
    # Backup original
    cp src/main.tsx src/main.tsx.backup
    
    # Add basename to BrowserRouter
    sed -i 's/<BrowserRouter>/<BrowserRouter basename="\/alphanifty">/' src/main.tsx
    
    # Rebuild with correct API URL
    echo "VITE_API_URL=/api/alphanifty" > .env
    npm run build
    echo "✓ AlphaNifty fixed and rebuilt"
else
    echo "⚠ AlphaNifty main.tsx not found"
fi

# 2. Fix Bar-Line - Add basename to React Router
echo ""
echo "2. Fixing Bar-Line (Right Amount) React Router..."
cd /var/www/vsfintech/Bar-Line
if [ -f "src/main.tsx" ]; then
    cp src/main.tsx src/main.tsx.backup
    sed -i 's/<BrowserRouter>/<BrowserRouter basename="\/right-amount">/' src/main.tsx
    echo "VITE_API_URL=/api/right-amount" > .env
    npm run build
    echo "✓ Bar-Line fixed and rebuilt"
else
    echo "⚠ Bar-Line main.tsx not found"
fi

# 3. Fix Heatmap - Add basename to React Router
echo ""
echo "3. Fixing Heatmap React Router..."
cd /var/www/vsfintech/Heatmap/frontend
if [ -f "src/main.tsx" ]; then
    cp src/main.tsx src/main.tsx.backup
    sed -i 's/<BrowserRouter>/<BrowserRouter basename="\/sector-heatmap">/' src/main.tsx
    echo "VITE_API_URL=/api/heatmap" > .env
    npm run build
    echo "✓ Heatmap fixed and rebuilt"
else
    echo "⚠ Heatmap main.tsx not found"
fi

# 4. Update Nginx configuration
echo ""
echo "4. Updating Nginx configuration..."
cd /var/www/vsfintech
if [ -f "VSFintech-Platform/nginx-complete-config.conf" ]; then
    cp VSFintech-Platform/nginx-complete-config.conf /etc/nginx/sites-available/vsfintech
    nginx -t && systemctl reload nginx
    echo "✓ Nginx configuration updated"
else
    echo "⚠ Nginx config not found"
fi

# 5. Restart PM2 services
echo ""
echo "5. Restarting PM2 services..."
cd /var/www/vsfintech
pm2 restart all
pm2 save
echo "✓ PM2 services restarted"

# 6. Verify all services
echo ""
echo "========================================="
echo "Verification"
echo "========================================="
pm2 status

echo ""
echo "Testing endpoints..."
curl -s -o /dev/null -w "Main Platform: %{http_code}\n" http://localhost/
curl -s -o /dev/null -w "AlphaNifty: %{http_code}\n" http://localhost/alphanifty/
curl -s -o /dev/null -w "Bar-Line: %{http_code}\n" http://localhost/right-amount/
curl -s -o /dev/null -w "Heatmap: %{http_code}\n" http://localhost/sector-heatmap/
curl -s -o /dev/null -w "PMS Screener: %{http_code}\n" http://localhost/pms-screener/
curl -s -o /dev/null -w "Risk-Reward: %{http_code}\n" http://localhost/risk-reward/
curl -s -o /dev/null -w "Riskometer: %{http_code}\n" http://localhost/riskometer/

echo ""
echo "========================================="
echo "✓ Fix script completed!"
echo "========================================="
echo ""
echo "All applications should now be working with proper routing."
echo "Visit http://82.25.105.18/ to test the main platform."
echo ""
