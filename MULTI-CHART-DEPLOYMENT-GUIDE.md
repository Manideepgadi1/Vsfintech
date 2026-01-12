# Multi Chart Deployment Guide

## 📋 Overview
This guide will help you deploy the Multi Chart application safely without breaking any existing projects.

**Target Configuration:**
- Frontend URL: `http://82.25.105.18/multi-chart/`
- Backend API: `http://82.25.105.18/api/multi-chart/`
- Backend Port: `9006` (confirmed available)
- Installation Path: `/var/www/vsfintech/MultiChart`

---

## 🎯 Pre-Deployment Checklist

### 1. Project Structure
Your Multi Chart project should have this structure:
```
MultiChart/
├── frontend/ (or root with package.json)
│   ├── package.json
│   ├── vite.config.js/ts
│   ├── src/
│   │   ├── main.tsx
│   │   └── ...
│   └── ...
├── backend/ (optional)
│   ├── server.py or app.py or main.py
│   ├── requirements.txt
│   └── ...
```

### 2. Required Information
- [ ] Do you have a backend? (Yes/No)
- [ ] Is frontend React or static HTML?
- [ ] Backend port preference (default: 9006)
- [ ] Chart library used (Plotly, Chart.js, D3.js, etc.)

---

## 🚀 Deployment Steps

### Step 1: Upload Your Code

**Option A: From Local Machine**
```powershell
# If you have the code locally
scp -r D:\Your-MultiChart-Path root@82.25.105.18:/var/www/vsfintech/MultiChart
```

**Option B: From Git**
```bash
ssh root@82.25.105.18
cd /var/www/vsfintech
git clone YOUR_REPOSITORY_URL MultiChart
```

**Option C: Manual Upload**
- ZIP your project
- Use WinSCP or FileZilla to upload to `/var/www/vsfintech/MultiChart`

---

### Step 2: Run Deployment Script

**Upload the deployment script:**
```powershell
scp D:\VSFintech-Platform\deploy-multi-chart-safe.sh root@82.25.105.18:/root/
```

**Make it executable and run:**
```bash
ssh root@82.25.105.18
chmod +x /root/deploy-multi-chart-safe.sh
sudo /root/deploy-multi-chart-safe.sh
```

The script will:
- ✅ Check prerequisites (Node.js, Python, PM2)
- ✅ Install dependencies
- ✅ Build frontend (if React)
- ✅ Start backend on port 9006 (if exists)
- ✅ Configure nginx (without touching existing config)
- ✅ Test deployment

---

### Step 3: Verify Deployment

**Test URLs:**
```powershell
# Frontend
Invoke-WebRequest -Uri "http://82.25.105.18/multi-chart/" -UseBasicParsing

# Backend API (if exists)
Invoke-WebRequest -Uri "http://82.25.105.18/api/multi-chart/" -UseBasicParsing
```

**Check backend process:**
```bash
ssh root@82.25.105.18
pm2 status
pm2 logs multi-chart-backend
```

---

## 🔧 Manual Configuration (If Needed)

### Nginx Configuration

If automatic configuration fails, manually add to `/etc/nginx/sites-enabled/default` before the main `location / {` block:

```nginx
# =====================================================
# MULTI CHART - Advanced Charting Tool
# =====================================================
# Multi Chart Backend API
location /api/multi-chart/ {
    proxy_pass http://127.0.0.1:9006/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    
    # CORS headers
    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization' always;
    
    # Timeouts for chart generation
    proxy_connect_timeout 60s;
    proxy_send_timeout 60s;
    proxy_read_timeout 60s;
}

# Multi Chart Frontend
location /multi-chart/ {
    alias /var/www/vsfintech/MultiChart/dist/;  # or just /MultiChart/ for static
    try_files $uri $uri/ /multi-chart/index.html;
    index index.html;
}

location /multi-chart {
    return 301 /multi-chart/;
}
```

Test and reload:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## 🎨 Frontend Configuration

### For React + Vite

**1. Update `vite.config.ts` or `vite.config.js`:**
```javascript
export default defineConfig({
  base: '/multi-chart',  // Important for subpath
  // ... rest of config
})
```

**2. Update `src/main.tsx` (if using React Router):**
```tsx
import { BrowserRouter } from 'react-router-dom';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter basename="/multi-chart">
      <App />
    </BrowserRouter>
  </StrictMode>
);
```

**3. Update API calls:**
```javascript
// Use relative path
const API_BASE_URL = '/api/multi-chart';

// Or create .env file
VITE_API_URL=/api/multi-chart
```

**4. Build:**
```bash
npm install
npm run build
```

---

## 🐍 Backend Configuration

### Flask Backend Example with Plotly

**server.py or app.py:**
```python
from flask import Flask, jsonify, request
from flask_cors import CORS
import plotly.graph_objects as go
import plotly.express as px
import json

app = Flask(__name__)
CORS(app)  # Enable CORS

@app.route('/')
def index():
    return jsonify({"status": "Multi Chart API running", "version": "1.0"})

@app.route('/chart/line', methods=['POST'])
def create_line_chart():
    data = request.json
    
    fig = go.Figure()
    fig.add_trace(go.Scatter(
        x=data.get('x', []),
        y=data.get('y', []),
        mode='lines+markers',
        name=data.get('name', 'Series 1')
    ))
    
    fig.update_layout(
        title=data.get('title', 'Line Chart'),
        xaxis_title=data.get('xlabel', 'X Axis'),
        yaxis_title=data.get('ylabel', 'Y Axis')
    )
    
    return jsonify(fig.to_json())

@app.route('/chart/bar', methods=['POST'])
def create_bar_chart():
    data = request.json
    
    fig = go.Figure(data=[
        go.Bar(x=data.get('x', []), y=data.get('y', []))
    ])
    
    fig.update_layout(title=data.get('title', 'Bar Chart'))
    
    return jsonify(fig.to_json())

@app.route('/chart/scatter', methods=['POST'])
def create_scatter_chart():
    data = request.json
    
    fig = px.scatter(
        x=data.get('x', []),
        y=data.get('y', []),
        title=data.get('title', 'Scatter Plot')
    )
    
    return jsonify(fig.to_json())

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9006, debug=False)
```

**requirements.txt:**
```
Flask==3.0.0
flask-cors==4.0.0
gunicorn==21.2.0
plotly==5.17.0
pandas==2.1.0
numpy==1.24.0
```

**Install dependencies:**
```bash
cd /var/www/vsfintech/MultiChart/backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

**Start with PM2:**
```bash
pm2 start venv/bin/gunicorn \
    --name multi-chart-backend \
    --cwd /var/www/vsfintech/MultiChart/backend \
    --interpreter none \
    -- -w 2 -b 0.0.0.0:9006 server:app

pm2 save
```

---

## 🧪 Testing

### Frontend Test
```bash
curl http://82.25.105.18/multi-chart/
```
**Expected:** HTML content with status 200

### Backend Test
```bash
curl http://82.25.105.18/api/multi-chart/
```
**Expected:** JSON response with status 200

### Chart Generation Test
```bash
curl -X POST http://82.25.105.18/api/multi-chart/chart/line \
  -H "Content-Type: application/json" \
  -d '{"x": [1,2,3], "y": [4,5,6], "title": "Test Chart"}'
```

### From Windows
```powershell
$urls = @('/multi-chart/', '/api/multi-chart/')
foreach($url in $urls) {
    $response = Invoke-WebRequest -Uri "http://82.25.105.18$url" -UseBasicParsing
    Write-Host "$url - HTTP $($response.StatusCode)" -ForegroundColor $(if($response.StatusCode -eq 200){'Green'}else{'Red'})
}
```

---

## 🛠️ Troubleshooting

### Issue: Backend Not Starting
```bash
# Check logs
pm2 logs multi-chart-backend

# Check if port is in use
lsof -i :9006

# Try starting manually
cd /var/www/vsfintech/MultiChart/backend
source venv/bin/activate
python server.py
```

### Issue: Frontend Shows 404
```bash
# Check nginx config
sudo nginx -t

# Check file permissions
ls -la /var/www/vsfintech/MultiChart/dist/

# Fix permissions
sudo chown -R www-data:www-data /var/www/vsfintech/MultiChart/dist/
sudo chmod -R 755 /var/www/vsfintech/MultiChart/dist/
```

### Issue: Charts Not Rendering
- Check browser console for errors
- Verify chart library is loaded
- Test API endpoints individually
- Check CORS headers in response

### Issue: API Returns CORS Error
Add CORS headers to nginx (see manual configuration above) or enable in Flask backend:
```python
from flask_cors import CORS
CORS(app)
```

---

## 📊 Port Allocation Reference

| Service | Port | Status |
|---------|------|--------|
| AlphaNifty | 5000 | ✅ Used |
| Risk-Reward | 5001 | ✅ Used |
| Riskometer | 5002 | ⏳ Planned |
| Investment Calc API | 5003 | ✅ Used |
| Right Amount | 8001 | ✅ Used |
| Sector Heatmap | 8002 | ✅ Used |
| PMS Screener | 8004 | ✅ Used |
| **Multi Chart** | **9006** | ✅ Available |
| Investment Calc UI | 3000 | ✅ Used |

---

## 🔄 Maintenance Commands

### View Backend Logs
```bash
pm2 logs multi-chart-backend
pm2 logs multi-chart-backend --lines 100
```

### Restart Backend
```bash
pm2 restart multi-chart-backend
```

### Stop Backend
```bash
pm2 stop multi-chart-backend
```

### Delete Backend (Remove from PM2)
```bash
pm2 delete multi-chart-backend
pm2 save
```

### Rebuild Frontend
```bash
cd /var/www/vsfintech/MultiChart
npm run build
```

### View Nginx Logs
```bash
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

---

## 🔐 Security Considerations

1. **Never expose backend port directly** - Always use nginx reverse proxy
2. **Enable CORS** only for required origins in production
3. **Validate all chart inputs** to prevent injection attacks
4. **Limit chart data size** to prevent memory issues
5. **Use HTTPS** in production (configure SSL certificate)
6. **Rate limit API** to prevent abuse

---

## 📁 Directory Structure After Deployment

```
/var/www/vsfintech/MultiChart/
├── dist/                    # Built frontend (if React)
│   ├── index.html
│   ├── assets/
│   └── ...
├── backend/                 # Backend (if exists)
│   ├── venv/               # Python virtual environment
│   ├── server.py
│   ├── requirements.txt
│   └── ...
├── package.json            # Frontend dependencies (if React)
├── vite.config.js          # Vite configuration
└── ...
```

---

## 📚 Chart Library Integration

### Plotly.js
```javascript
import Plotly from 'plotly.js-dist';

Plotly.newPlot('chart', [{
  x: [1, 2, 3],
  y: [4, 5, 6],
  type: 'scatter'
}]);
```

### Chart.js
```javascript
import Chart from 'chart.js/auto';

new Chart(ctx, {
  type: 'line',
  data: { ... }
});
```

### D3.js
```javascript
import * as d3 from 'd3';

d3.select('#chart')
  .append('svg')
  .attr('width', 800)
  .attr('height', 600);
```

---

## ✅ Safety Features

The deployment script ensures:
- ✅ **No existing projects are modified**
- ✅ **Nginx config is backed up** before changes
- ✅ **Port conflict check** before starting backend
- ✅ **Automatic rollback** on nginx config error
- ✅ **Validation tests** after deployment
- ✅ **Isolated virtual environment** for Python
- ✅ **Extended timeouts** for chart generation (60s)

---

## 📞 Support

If you encounter issues:

1. **Check logs**: `pm2 logs multi-chart-backend` and `/var/log/nginx/error.log`
2. **Verify configuration**: Review this guide's manual configuration section
3. **Test each component**: Frontend, backend, and nginx separately
4. **Check permissions**: Ensure www-data owns frontend files
5. **Test chart generation**: Use curl to test API endpoints

---

## 🎯 Use Cases

Multi Chart is perfect for:
- **Financial Data Visualization**: Stock prices, portfolio performance
- **Market Analysis**: Trend analysis, comparative charts
- **Research Dashboards**: Interactive data exploration
- **Reporting Tools**: Generate charts for reports
- **Real-time Monitoring**: Live data visualization

---

**Deployment Date:** January 8, 2026
**Script Version:** 1.0
**Status:** Ready for deployment with port 9006 confirmed available
