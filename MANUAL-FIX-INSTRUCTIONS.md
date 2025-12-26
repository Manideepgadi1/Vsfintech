# Manual Fix Instructions for VSFintech Platform

## Problem
React apps (AlphaNifty, Bar-Line, Heatmap) don't work correctly at subpaths because React Router doesn't know it's at /alphanifty instead of root /

## Solution
Add `basename` prop to BrowserRouter in each React app

---

## Fix 1: AlphaNifty

```bash
cd /var/www/vsfintech/ALPHANIFTYY

# Edit src/main.tsx
# Find: <BrowserRouter>
# Replace with: <BrowserRouter basename="/alphanifty">

# Or use sed:
sed -i 's/<BrowserRouter>/<BrowserRouter basename="\/alphanifty">/' src/main.tsx

# Rebuild
echo "VITE_API_URL=/api/alphanifty" > .env
npm run build
```

---

## Fix 2: Bar-Line (Right Amount)

```bash
cd /var/www/vsfintech/Bar-Line

# Edit src/main.tsx
sed -i 's/<BrowserRouter>/<BrowserRouter basename="\/right-amount">/' src/main.tsx

# Rebuild
echo "VITE_API_URL=/api/right-amount" > .env
npm run build
```

---

## Fix 3: Heatmap (Sector Heatmap)

```bash
cd /var/www/vsfintech/Heatmap/frontend

# Edit src/main.tsx
sed -i 's/<BrowserRouter>/<BrowserRouter basename="\/sector-heatmap">/' src/main.tsx

# Rebuild
echo "VITE_API_URL=/api/heatmap" > .env
npm run build
```

---

## Fix 4: Update Nginx

```bash
# Pull latest config from GitHub
cd /var/www/vsfintech/VSFintech-Platform
git pull

# Copy nginx config
cp nginx-complete-config.conf /etc/nginx/sites-available/vsfintech

# Test and reload
nginx -t
systemctl reload nginx
```

---

## Fix 5: Restart Services

```bash
cd /var/www/vsfintech
pm2 restart all
pm2 save
```

---

## Verify Everything Works

```bash
# Check PM2 status
pm2 status

# Test endpoints
curl http://localhost/
curl http://localhost/alphanifty/
curl http://localhost/right-amount/
curl http://localhost/sector-heatmap/
curl http://localhost/pms-screener/
```

---

## Expected Results

After these fixes:
✓ AlphaNifty internal navigation works (baskets, funds, etc.)
✓ Bar-Line internal navigation works
✓ Heatmap internal navigation works
✓ PMS Screener loads data (556 funds)
✓ All static apps work (Right-Sector, Risk-Return, Multichart, Risk-Reward, Riskometer)

---

## If Something Still Doesn't Work

1. Check PM2 logs: `pm2 logs [app-name]`
2. Check Nginx error log: `tail -f /var/log/nginx/error.log`
3. Check browser console for JavaScript errors
4. Verify backend is running: `curl http://localhost:[PORT]/`

---

## Quick Test Commands

```bash
# Test AlphaNifty backend
curl http://localhost:8003/api/baskets

# Test Bar-Line backend
curl http://localhost:8001/

# Test Heatmap backend
curl http://localhost:8002/docs

# Test PMS Screener
curl http://localhost:3003/api/funds
```
