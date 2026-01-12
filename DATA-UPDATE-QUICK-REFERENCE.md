# Quick Data Update Reference Card

## 🚀 Quick Start (3 Simple Steps)

### For Busy Updates (Automated)
```powershell
# Step 1: Run the script
cd D:\VSFintech-Platform
.\Update-DataFiles.ps1 -DataFile "D:\YourNewData.csv"

# That's it! The script handles everything:
# ✅ Backs up old files
# ✅ Uploads new files
# ✅ Sets permissions
# ✅ Restarts services
# ✅ Tests endpoints
```

### For Manual Control
```powershell
# Step 1: Backup
ssh root@82.25.105.18
cp /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv \
   /var/www/vsfintech/Heatmap/backup_$(date +%Y%m%d).csv

# Step 2: Upload
scp "D:\YourNewData.csv" root@82.25.105.18:/var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv

# Step 3: Restart
ssh root@82.25.105.18 "pm2 restart heatmap riskometer"
```

---

## 📁 Where Are The Data Files?

| Tool | File Location | Size | Port |
|------|--------------|------|------|
| **Sector Heatmap** | `/var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv` | 6.8 MB | 8002 |
| **Riskometer** | `/var/www/vsfintech/Riskometer/backend/data.csv` | 6.8 MB | 5002 |
| **Right Sector** | `/var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv` | 6.8 MB | 5000 |
| **Risk-Reward** | `/var/www/vsfintech/Risk-Reward/data.csv` | 6.7 MB | 5001 |
| **Multi Chart** | `/var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv` | 6.8 MB | 9006 |

---

## 🔄 Update Process Flow

```
Your New Data File (D:\)
         ↓
    [Upload via SCP]
         ↓
    Server Files Updated
         ↓
    Set Permissions
         ↓
    Clear Python Cache
         ↓
    Restart Services
         ↓
    Test Endpoints
         ↓
    ✅ DONE!
```

---

## 📋 Script Usage Examples

### Example 1: Standard Update
```powershell
.\Update-DataFiles.ps1 -DataFile "D:\MarketData_January2026.csv"
```

### Example 2: Update Without Service Restart
```powershell
.\Update-DataFiles.ps1 -DataFile "D:\MarketData.csv" -RestartServices $false
```

### Example 3: Update Without Backup (Not Recommended)
```powershell
.\Update-DataFiles.ps1 -DataFile "D:\MarketData.csv" -BackupFirst $false
```

### Example 4: Different Server
```powershell
.\Update-DataFiles.ps1 -DataFile "D:\MarketData.csv" -ServerIP "192.168.1.100" -ServerUser "admin"
```

---

## ⚠️ Before You Update

### ✅ Pre-Update Checklist
- [ ] New data file is ready (CSV format)
- [ ] File size is reasonable (5-10 MB typical)
- [ ] SSH access to server works
- [ ] Current data is backed up (script does this)
- [ ] Update during off-peak hours

### ⚡ Data File Requirements
- **Format**: CSV (comma-separated)
- **Encoding**: UTF-8
- **Required Columns**: Date, Index, Symbol, Price, etc.
- **Size**: ~6-8 MB for full dataset
- **Date Range**: Latest market data

---

## 🔍 Verify Update Worked

### Check 1: File Uploaded?
```powershell
ssh root@82.25.105.18 "ls -lh /var/www/vsfintech/Heatmap/*.csv"
```

### Check 2: Services Running?
```powershell
ssh root@82.25.105.18 "pm2 status"
```

### Check 3: API Responding?
```powershell
ssh root@82.25.105.18 "curl http://localhost:8002/api/indices"
```

### Check 4: Browser Test
- Open: http://82.25.105.18/sector-heatmap/
- Open: http://82.25.105.18/riskometer/
- Select an index and check if data loads

---

## 🆘 Troubleshooting

### Problem: Upload Fails
**Solution:**
```powershell
# Check SSH connection
ssh root@82.25.105.18 "echo 'Connected'"

# Check disk space
ssh root@82.25.105.18 "df -h /var/www"
```

### Problem: Service Not Updating
**Solution:**
```powershell
# Clear cache and restart
ssh root@82.25.105.18 "
  find /var/www/vsfintech -name '__pycache__' -exec rm -rf {} + 2>/dev/null
  pm2 restart all
  pm2 logs heatmap --lines 20
"
```

### Problem: Permission Denied
**Solution:**
```powershell
ssh root@82.25.105.18 "
  chown root:root /var/www/vsfintech/Heatmap/*.csv
  chmod 644 /var/www/vsfintech/Heatmap/*.csv
  chown www-data:www-data /var/www/vsfintech/Riskometer/backend/data.csv
  chmod 755 /var/www/vsfintech/Riskometer/backend/data.csv
"
```

### Problem: Data Not Showing
**Solution:**
```powershell
# Check if file is being read
ssh root@82.25.105.18 "
  pm2 logs heatmap --lines 50 | grep -i 'csv\|data\|error'
"
```

---

## 📊 Understanding Your Data File

### Current File Structure
```csv
Date,Index,Symbol,Price,Change,%Change,Volume,...
2025-11-14,NIFTY 50,RELIANCE,2500.50,15.25,0.61,5234567,...
2025-11-14,NIFTY 50,TCS,3800.25,-12.50,-0.33,3456789,...
...
```

### What Each Tool Uses
- **Sector Heatmap**: Stock prices, index composition, sectors
- **Riskometer**: Historical returns, volatility data
- **Risk-Reward**: Return metrics, risk indicators
- **Right Sector**: Sector performance, rotations

---

## 🔒 Backup and Recovery

### Restore Previous Data
```powershell
# List available backups
ssh root@82.25.105.18 "ls -lh /var/www/vsfintech/Heatmap/*.backup*"

# Restore specific backup
ssh root@82.25.105.18 "
  cp /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv.backup_20260108 \
     /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv
  pm2 restart heatmap riskometer
"
```

### Manual Backup
```powershell
# Create backup with timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
ssh root@82.25.105.18 "
  cp /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv \
     /var/www/vsfintech/Heatmap/backup_$timestamp.csv
"
```

---

## 📅 Recommended Update Schedule

| Frequency | When | Use Case |
|-----------|------|----------|
| **Daily** | After market close | High-frequency trading, daily analytics |
| **Weekly** | Friday EOD | Most retail applications |
| **Monthly** | Month-end | Long-term portfolio analysis |
| **As-Needed** | Major events | Index rebalancing, corporate actions |

---

## 🎯 Quick Commands Cheat Sheet

```powershell
# Update data (automated)
.\Update-DataFiles.ps1 -DataFile "D:\NewData.csv"

# Check file dates
ssh root@82.25.105.18 "ls -lh /var/www/vsfintech/Heatmap/*.csv /var/www/vsfintech/Riskometer/backend/data.csv /var/www/vsfintech/Right-Sector/data/*.csv /var/www/vsfintech/Risk-Reward/data.csv /var/www/vsfintech/MultiChart/*.csv"

# Restart services
ssh root@82.25.105.18 "pm2 restart heatmap riskometer right-sector risk-reward multi-chart"

# View logs
ssh root@82.25.105.18 "pm2 logs heatmap --lines 50"

# Test API
ssh root@82.25.105.18 "curl http://localhost:8002/api/indices"

# Clear cache
ssh root@82.25.105.18 "find /var/www/vsfintech -name '__pycache__' -rm -rf"
```

---

## 📞 Support

### Check Services Status
```powershell
ssh root@82.25.105.18 "pm2 status"
```

### View Error Logs
```powershell
ssh root@82.25.105.18 "pm2 logs heatmap --err --lines 100"
```

### Full System Check
```powershell
ssh root@82.25.105.18 "
  echo '=== Disk Space ==='
  df -h /var/www
  echo ''
  echo '=== Services ==='
  pm2 status
  echo ''
  echo '=== Data Files ==='
  ls -lh /var/www/vsfintech/Heatmap/*.csv
  ls -lh /var/www/vsfintech/Riskometer/backend/data.csv
"
```

---

## ✨ Best Practices

1. ✅ **Always backup before updating**
2. ✅ **Test data file locally first** (open in Excel, check format)
3. ✅ **Update during off-peak hours** (less user impact)
4. ✅ **Verify after update** (check all tools work)
5. ✅ **Keep old backups** (at least last 3-5 versions)
6. ✅ **Document changes** (what data, when updated)
7. ✅ **Monitor logs** (first 30 minutes after update)

---

## 📝 Notes

- Files are named with date format: `DDMMYYYY` (e.g., 14112025)
- Both tools use the same data source (same content, different filenames)
- Services auto-reload data on restart (no code changes needed)
- Backups are stored in the same directory with `.backup_TIMESTAMP` suffix
- PM2 process manager handles service lifecycle

---

**Last Updated**: January 8, 2026  
**Script Version**: 1.0  
**Tested On**: Windows 11 PowerShell 7.x
