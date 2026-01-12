# Sector Heatmap - Deployment & Troubleshooting Guide

## 📍 Current Status
**Issue**: Frontend loads but API calls timeout when fetching large datasets (NIFTY 500, NIFTY MIDCAP 50)

---

## 🏗️ Architecture

### Frontend (React + Vite)
- **Location**: `/var/www/vsfintech/Heatmap/frontend/`
- **Build Directory**: `/var/www/vsfintech/Heatmap/frontend/dist/`
- **URL**: `http://82.25.105.18/sector-heatmap/`
- **Framework**: React 18 with Vite
- **Key Files**:
  - Source: `/var/www/vsfintech/Heatmap/frontend/src/`
  - API Service: `/var/www/vsfintech/Heatmap/frontend/src/services/api.js`
  - Main Component: `/var/www/vsfintech/Heatmap/frontend/src/components/Heatmap.jsx`

### Backend API (FastAPI + Python)
- **Location**: `/var/www/vsfintech/Heatmap/backend/`
- **Port**: `8002`
- **URL**: `http://127.0.0.1:8002` (internal)
- **Public API**: `http://82.25.105.18/api/heatmap/`
- **Framework**: FastAPI with Uvicorn
- **Process ID**: 130100 (running)
- **CPU Usage**: 4.7%

---

## 🔌 API Endpoints

### 1. Get Available Indices
```
GET http://82.25.105.18/api/heatmap/indices
```
**Response**: 
```json
{
  "indices": ["NIFTY 50", "NIFTY 500", "NIFTY MIDCAP 50", ...]
}
```

### 2. Get Heatmap Data
```
GET http://82.25.105.18/api/heatmap/heatmap/{index_name}
```
**Example**:
```
GET http://82.25.105.18/api/heatmap/heatmap/NIFTY%20500
GET http://82.25.105.18/api/heatmap/heatmap/NIFTY%20MIDCAP%2050
```

**Response Size**:
- NIFTY 500: ~11,374 bytes (500 stocks)
- NIFTY MIDCAP 50: Similar large dataset

**Processing Time**: 
- Takes more than 10 seconds for large indices
- Can take up to 30-60 seconds depending on data

---

## ⚙️ Nginx Configuration

**Config File**: `/etc/nginx/sites-enabled/default`

### Frontend Location Block
```nginx
location /sector-heatmap/ {
    alias /var/www/vsfintech/Heatmap/frontend/dist/;
    try_files $uri $uri/ /sector-heatmap/index.html;
}
```

### API Location Block (Lines 47-74)
```nginx
location /api/heatmap/ {
    proxy_pass http://127.0.0.1:8002/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    
    # Timeouts (INCREASED TO 60s)
    proxy_connect_timeout 60s;
    proxy_send_timeout 60s;
    proxy_read_timeout 60s;
    
    # CORS headers (ADDED)
    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization' always;
    
    # Handle preflight requests
    if ($request_method = 'OPTIONS') {
        return 204;
    }
}
```

---

## 🐛 Current Problem

### Error Message in Browser Console
```
Error fetching heatmap for NIFTY 500: 
{message: 'timeout of 10000ms exceeded', name: 'AxiosError', code: 'ECONNABORTED', ...}
```

### Frontend Timeout Configuration
**File**: `/var/www/vsfintech/Heatmap/frontend/src/services/api.js`

**Current Setting** (Line 17):
```javascript
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 60000, // UPDATED to 60 seconds
});
```

### What We've Done
✅ Increased nginx proxy timeouts to 60 seconds
✅ Added CORS headers to nginx
✅ Increased frontend axios timeout to 60 seconds
✅ Rebuilt frontend with new timeout

### Why It's Still Failing
The issue may be:

1. **Backend Processing Time**: The Python backend takes too long to calculate heatmap for 500 stocks
2. **Database/Data Source Delay**: If backend is fetching data from external API or database
3. **Backend Timeout**: The FastAPI backend itself may have timeout limits
4. **Resource Constraints**: Server may not have enough CPU/Memory to process quickly

---

## 🔧 Backend Investigation Needed

### Check Backend Logs
```bash
ssh root@82.25.105.18
cd /var/www/vsfintech/Heatmap/backend
# Check if there's a log file
ls -la *.log
# Check systemd logs if running as service
journalctl -u heatmap-backend -f
# Or check process output
ps aux | grep 8002
```

### Test Backend Directly
```bash
# From server
curl -w "\nTime: %{time_total}s\n" "http://127.0.0.1:8002/heatmap/NIFTY%20500"

# From Windows
Invoke-WebRequest -Uri "http://82.25.105.18/api/heatmap/heatmap/NIFTY%20500" -UseBasicParsing
```

### Check Backend Code
```bash
cd /var/www/vsfintech/Heatmap/backend
cat main.py  # or app.py or whatever the main file is
# Look for:
# - Timeout settings
# - Data fetching logic
# - External API calls
```

---

## 🚀 Possible Solutions

### Solution 1: Increase Backend Processing Timeout
If backend uses Uvicorn:
```bash
# Check how backend is started
ps aux | grep 8002

# Restart with longer timeout (if needed)
uvicorn main:app --host 0.0.0.0 --port 8002 --timeout-keep-alive 120
```

### Solution 2: Add Caching
Implement caching in backend to store calculated heatmaps:
- Use Redis for short-term cache (5-10 minutes)
- Pre-calculate heatmaps for popular indices
- Store in database

### Solution 3: Optimize Backend Algorithm
- Use async processing
- Parallel data fetching
- Database query optimization
- Reduce data processing steps

### Solution 4: Progressive Loading
Update frontend to:
- Show loading progress
- Fetch data in chunks
- Display partial results

### Solution 5: Background Job Processing
- Move heavy calculation to background job
- Return job ID immediately
- Poll for results
- Use WebSocket for updates

---

## 📊 Backend Requirements

### System Requirements
```bash
# Check current resources
ssh root@82.25.105.18
free -h        # Check memory
df -h          # Check disk space
top            # Check CPU usage
```

### Python Dependencies
Check backend requirements:
```bash
cd /var/www/vsfintech/Heatmap/backend
cat requirements.txt
pip list  # Check installed packages
```

---

## 🧪 Testing Commands

### Test API Health
```powershell
# Quick health check
Invoke-WebRequest -Uri "http://82.25.105.18/api/heatmap/indices" -UseBasicParsing

# Test with timing
Measure-Command { 
    Invoke-WebRequest -Uri "http://82.25.105.18/api/heatmap/heatmap/NIFTY%20500" -UseBasicParsing -TimeoutSec 90
}
```

### Check Frontend
```powershell
# Check if frontend files are served
Invoke-WebRequest -Uri "http://82.25.105.18/sector-heatmap/" -UseBasicParsing
```

### Check Backend Process
```bash
ssh root@82.25.105.18
ps aux | grep 8002
netstat -tlnp | grep 8002
```

---

## 📝 Deployment Checklist

### Frontend Deployment
```bash
# On Windows (local machine)
cd D:\VSFintech-Platform\Heatmap\frontend  # If you have source
npm install
npm run build
scp -r dist/* root@82.25.105.18:/var/www/vsfintech/Heatmap/frontend/dist/

# On Server
cd /var/www/vsfintech/Heatmap/frontend
npm run build  # If building on server
```

### Backend Deployment
```bash
# On Server
cd /var/www/vsfintech/Heatmap/backend
pip install -r requirements.txt

# Restart backend
# Find process
ps aux | grep 8002
kill <PID>

# Start backend
nohup uvicorn main:app --host 0.0.0.0 --port 8002 &
# Or if using gunicorn/systemd, restart service
```

### Nginx Restart
```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## 🔍 Next Steps for Debugging

1. **Check Backend Logs**: See what's happening when request comes in
2. **Test Backend Directly**: Bypass nginx and test backend on port 8002
3. **Profile Backend Code**: Find where the slowdown is
4. **Check External Dependencies**: See if backend calls external APIs
5. **Monitor Resources**: Check if server runs out of memory/CPU

---

## 📞 Information to Share with Backend Team

**Problem**: Heatmap API times out for large indices (NIFTY 500, NIFTY MIDCAP 50)

**Configuration**:
- Backend Port: 8002
- Nginx Timeout: 60 seconds
- Frontend Timeout: 60 seconds
- Current Processing Time: >60 seconds for 500 stocks

**Error**: Frontend receives timeout error after 60 seconds

**Expected**: API should respond within 30 seconds or implement:
1. Caching mechanism
2. Background processing with job polling
3. Optimized data fetching/calculation

**API Endpoint**: 
```
GET /heatmap/{index_name}
Example: GET /heatmap/NIFTY%20500
```

**Response Expected**: JSON with heatmap data (~11KB)

**Question for Backend Team**:
- What's causing the delay in calculation?
- Is data fetched from external API?
- Can caching be implemented?
- Can we optimize the algorithm?
- Should we implement async job processing?

---

## 📁 File Locations Summary

```
Frontend:
├── Source: /var/www/vsfintech/Heatmap/frontend/src/
├── Build: /var/www/vsfintech/Heatmap/frontend/dist/
├── Config: /var/www/vsfintech/Heatmap/frontend/vite.config.js
└── API Service: /var/www/vsfintech/Heatmap/frontend/src/services/api.js

Backend:
├── Location: /var/www/vsfintech/Heatmap/backend/
├── Port: 8002
└── Process: PID 130100

Nginx:
└── Config: /etc/nginx/sites-enabled/default (Lines 47-74)

URLs:
├── Frontend: http://82.25.105.18/sector-heatmap/
└── API: http://82.25.105.18/api/heatmap/
```

---

## ⏱️ Current Timeouts Summary

| Component | Setting | Value |
|-----------|---------|-------|
| Nginx proxy_connect_timeout | `/etc/nginx/sites-enabled/default` | 60s |
| Nginx proxy_send_timeout | `/etc/nginx/sites-enabled/default` | 60s |
| Nginx proxy_read_timeout | `/etc/nginx/sites-enabled/default` | 60s |
| Frontend axios timeout | `api.js` line 17 | 60000ms (60s) |
| Backend timeout | Unknown - needs investigation | ? |

---

**Last Updated**: January 2, 2026
**Status**: Frontend and nginx configured, backend processing time needs optimization
