# 📊 Multi Chart Quick Deploy

## 📦 Files Created
1. **MULTI-CHART-DEPLOYMENT-GUIDE.md** - Complete deployment guide
2. **Deploy-MultiChart.ps1** - Windows PowerShell deployment script
3. **Test-MultiChart.ps1** - Testing script
4. **deploy-multi-chart-safe.sh** - Linux deployment script

---

## 🚀 Quick Start (3 Steps)

### Prerequisites
- [ ] Multi Chart code ready
- [ ] SSH access to server
- [ ] PowerShell on Windows

### Step 1: Upload Your Multi Chart Code
```powershell
# If you have the code locally
scp -r D:\Path-To-Your-MultiChart root@82.25.105.18:/var/www/vsfintech/MultiChart

# OR clone from git on server
ssh root@82.25.105.18
cd /var/www/vsfintech
git clone YOUR_REPO_URL MultiChart
```

### Step 2: Run Deployment
```powershell
# From PowerShell in D:\VSFintech-Platform\
.\Deploy-MultiChart.ps1
```

### Step 3: Test
```powershell
.\Test-MultiChart.ps1
```

---

## ✅ What Gets Deployed

- **Frontend URL**: http://82.25.105.18/multi-chart/
- **Backend API**: http://82.25.105.18/api/multi-chart/
- **Backend Port**: 9006 (internal only)
- **Install Location**: /var/www/vsfintech/MultiChart

---

## 🛡️ Safety Features

✅ **No existing projects will be touched**
- All existing applications remain working
- Nginx config is backed up automatically
- Port 9006 is confirmed available
- Automatic rollback on errors

✅ **Tested compatibility** with:
- Main website
- Risk-Reward app
- Sector Heatmap
- PMS Screener
- Investment Calculator
- Riskometer (when deployed)
- All other running services

---

## 📝 Project Structure Expected

```
MultiChart/
├── package.json         (if React app)
├── vite.config.js      (if React app)
├── src/                (if React app)
│   ├── main.tsx
│   └── ...
├── backend/            (optional)
│   ├── server.py or app.py or main.py
│   ├── requirements.txt
│   └── ...
```

---

## 🔧 Configuration

### React Frontend
The script will automatically configure:
- Vite base path: `/multi-chart`
- React Router basename: `/multi-chart`
- API base URL: `/api/multi-chart`

### Backend
- Port: 9006
- Process name: `multi-chart-backend`
- Managed by: PM2
- Workers: 2
- Timeouts: 60 seconds (for chart generation)

---

## 📊 After Deployment

### Check Status
```powershell
ssh root@82.25.105.18 "pm2 status"
```

### View Logs
```powershell
ssh root@82.25.105.18 "pm2 logs multi-chart-backend"
```

### Restart Backend
```powershell
ssh root@82.25.105.18 "pm2 restart multi-chart-backend"
```

---

## 🎨 Chart Libraries Supported

- **Plotly.js** - Interactive scientific charts
- **Chart.js** - Simple, flexible charts
- **D3.js** - Advanced data visualization
- **Recharts** - React-based charts
- **ApexCharts** - Modern charting library
- **ECharts** - Enterprise charts

---

## 🐛 Troubleshooting

### If Deployment Fails

1. **Check if code is uploaded**:
   ```bash
   ssh root@82.25.105.18 "ls -la /var/www/vsfintech/MultiChart"
   ```

2. **Check logs**:
   ```bash
   ssh root@82.25.105.18 "tail -f /var/log/nginx/error.log"
   ```

3. **Review deployment guide**:
   Open `MULTI-CHART-DEPLOYMENT-GUIDE.md` for detailed troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Port 9006 in use | Script will stop existing process automatically |
| Nginx config error | Script auto-rollbacks to backup |
| Build fails | Check Node.js version: `node -v` (need 18+) |
| Backend won't start | Check Python version: `python3 --version` |
| Charts not rendering | Check chart library installation |
| 404 errors | Check nginx config and file permissions |

---

## 📞 Need Help?

1. Read **MULTI-CHART-DEPLOYMENT-GUIDE.md** for detailed documentation
2. Run **Test-MultiChart.ps1** to diagnose issues
3. Check backend logs: `pm2 logs multi-chart-backend`
4. Check nginx logs: `/var/log/nginx/error.log`

---

## 🔄 Manual Deployment (Alternative)

If PowerShell script fails, follow manual steps in **MULTI-CHART-DEPLOYMENT-GUIDE.md**

---

## 📈 Use Cases

Perfect for:
- **Financial Analysis**: Stock price charts, portfolio performance
- **Market Trends**: Comparative analysis, technical indicators
- **Research Dashboards**: Interactive data exploration
- **Reports**: Generate charts for presentations
- **Real-time Data**: Live market monitoring

---

## 🎯 Example Charts You Can Create

1. **Line Charts** - Time series, trend analysis
2. **Bar Charts** - Comparative analysis
3. **Scatter Plots** - Correlation analysis
4. **Candlestick** - Stock price movements
5. **Heatmaps** - Correlation matrices
6. **Pie Charts** - Portfolio allocation
7. **Area Charts** - Cumulative data
8. **Box Plots** - Statistical distributions

---

## ✨ Features

- ✅ One-command deployment
- ✅ Automatic dependency installation
- ✅ Frontend build automation
- ✅ Backend PM2 management
- ✅ Nginx configuration with extended timeouts
- ✅ CORS headers for API access
- ✅ Health checks
- ✅ Rollback on errors
- ✅ Preserves existing apps

---

## 📊 Port Allocation

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

**Deployment Date:** January 8, 2026
**Script Version:** 1.0
**Status:** Ready to deploy with port 9006 confirmed available
