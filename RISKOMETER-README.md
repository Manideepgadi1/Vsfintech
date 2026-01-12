# 🎯 Riskometer Quick Deploy

## 📦 Files Created
1. **RISKOMETER-DEPLOYMENT-GUIDE.md** - Complete deployment guide
2. **Deploy-Riskometer.ps1** - Windows PowerShell deployment script
3. **Test-Riskometer.ps1** - Testing script
4. **deploy-riskometer-safe.sh** - Linux deployment script (already exists)

---

## 🚀 Quick Start (3 Steps)

### Prerequisites
- [ ] Riskometer code ready
- [ ] SSH access to server
- [ ] PowerShell on Windows

### Step 1: Upload Your Riskometer Code
```powershell
# If you have the code locally
scp -r D:\Path-To-Your-Riskometer root@82.25.105.18:/var/www/vsfintech/Riskometer

# OR clone from git on server
ssh root@82.25.105.18
cd /var/www/vsfintech
git clone YOUR_REPO_URL Riskometer
```

### Step 2: Run Deployment
```powershell
# From PowerShell in D:\VSFintech-Platform\
.\Deploy-Riskometer.ps1
```

### Step 3: Test
```powershell
.\Test-Riskometer.ps1
```

---

## ✅ What Gets Deployed

- **Frontend URL**: http://82.25.105.18/riskometer/
- **Backend API**: http://82.25.105.18/api/riskometer/
- **Backend Port**: 5002 (internal only)
- **Install Location**: /var/www/vsfintech/Riskometer

---

## 🛡️ Safety Features

✅ **No existing projects will be touched**
- All existing applications remain working
- Nginx config is backed up automatically
- Port 5002 is confirmed available
- Automatic rollback on errors

✅ **Tested compatibility** with:
- Main website
- Risk-Reward app
- Sector Heatmap
- PMS Screener
- Investment Calculator
- All other running services

---

## 📝 Project Structure Expected

```
Riskometer/
├── package.json         (if React app)
├── vite.config.js      (if React app)
├── src/                (if React app)
│   ├── main.tsx
│   └── ...
├── backend/            (optional)
│   ├── server.py or app.py
│   ├── requirements.txt
│   └── ...
```

---

## 🔧 Configuration

### React Frontend
The script will automatically configure:
- Vite base path: `/riskometer`
- React Router basename: `/riskometer`
- API base URL: `/api/riskometer`

### Backend
- Port: 5002
- Process name: `riskometer-backend`
- Managed by: PM2
- Workers: 2

---

## 📊 After Deployment

### Check Status
```powershell
ssh root@82.25.105.18 "pm2 status"
```

### View Logs
```powershell
ssh root@82.25.105.18 "pm2 logs riskometer-backend"
```

### Restart Backend
```powershell
ssh root@82.25.105.18 "pm2 restart riskometer-backend"
```

---

## 🐛 Troubleshooting

### If Deployment Fails

1. **Check if code is uploaded**:
   ```bash
   ssh root@82.25.105.18 "ls -la /var/www/vsfintech/Riskometer"
   ```

2. **Check logs**:
   ```bash
   ssh root@82.25.105.18 "tail -f /var/log/nginx/error.log"
   ```

3. **Review deployment guide**:
   Open `RISKOMETER-DEPLOYMENT-GUIDE.md` for detailed troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Port 5002 in use | Script will stop existing process automatically |
| Nginx config error | Script auto-rollbacks to backup |
| Build fails | Check Node.js version: `node -v` (need 18+) |
| Backend won't start | Check Python version: `python3 --version` |
| 404 errors | Check nginx config and file permissions |

---

## 📞 Need Help?

1. Read **RISKOMETER-DEPLOYMENT-GUIDE.md** for detailed documentation
2. Run **Test-Riskometer.ps1** to diagnose issues
3. Check backend logs: `pm2 logs riskometer-backend`
4. Check nginx logs: `/var/log/nginx/error.log`

---

## 🔄 Manual Deployment (Alternative)

If PowerShell script fails, follow manual steps in **RISKOMETER-DEPLOYMENT-GUIDE.md**

---

## ✨ Features

- ✅ One-command deployment
- ✅ Automatic dependency installation
- ✅ Frontend build automation
- ✅ Backend PM2 management
- ✅ Nginx configuration
- ✅ Health checks
- ✅ Rollback on errors
- ✅ Preserves existing apps

---

**Last Updated**: January 8, 2026
**Port**: 5002 (confirmed available)
**Status**: Ready to deploy
