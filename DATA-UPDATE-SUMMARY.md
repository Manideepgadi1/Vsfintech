# 📊 VSFintech Data Update - Complete Summary

## 🎯 What You Asked
> "When I want to change the Excel data (currently from November), how can I do it?"

## ✅ Answer: Use the Automated Script!

### The Simplest Way (Recommended)
```powershell
# Just run this command:
cd D:\VSFintech-Platform
.\Update-DataFiles.ps1 -DataFile "D:\YourNewDataFile.csv"
```

That's it! The script automatically:
- ✅ Creates backups
- ✅ Uploads to both tools
- ✅ Sets permissions
- ✅ Restarts services
- ✅ Tests everything

---

## 📁 Your Current Data Setup

### Data Files (All Use The Same - November 14, 2025 data)

**File 1: Sector Heatmap**
```
Location: /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv
Size: 6.8 MB
Owner: root:root
Permissions: 644 (rw-r--r--)
Last Modified: Jan 2, 2026, 12:39
```

**File 2: Riskometer**
```
Location: /var/www/vsfintech/Riskometer/backend/data.csv
Size: 6.8 MB
Owner: www-data:www-data
Permissions: 755 (rwxr-xr-x)
Last Modified: Jan 8, 2026, 06:19
```

**File 3: Right Sector**
```
Location: /var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv
Size: 6.8 MB
Owner: www-data:www-data
Permissions: 755 (rwxr-xr-x)
Last Modified: Dec 30, 2025, 14:15
```

**File 4: Risk-Reward**
```
Location: /var/www/vsfintech/Risk-Reward/data.csv
Size: 6.7 MB
Owner: root:root
Permissions: 644 (rw-r--r--)
Last Modified: Dec 31, 2025, 07:05
```

**File 5: Multi Chart**
```
Location: /var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv
Size: 6.8 MB
Owner: www-data:www-data
Permissions: 755 (rwxr-xr-x)
Last Modified: Jan 8, 2026, 07:31
```

### Data Structure
```csv
DATE,NIFTY 50,NIFTY NEXT 50,NIFTY 100,...(138 indices total)
10/11/25,38366.88,99651.76,35940.79,...
09/11/25,38366.88,99651.76,35940.79,...
08/11/25,38366.88,99651.76,35940.79,...
```

**Details:**
- **Columns**: 141 (DATE + 138 indices + 2 mutual funds)
- **Rows**: Historical daily data (thousands of rows)
- **Indices Included**: All NIFTY indices, sector indices, thematic indices, custom portfolios
- **Date Format**: DD/MM/YY
- **Data Type**: Index values (closing prices)

---

## 🚀 Three Ways to Update

### Method 1: Automated Script (Easiest) ⭐ RECOMMENDED
```powershell
.\Update-DataFiles.ps1 -DataFile "D:\January2026Data.csv"
```
**Time: 1 minute | Difficulty: Easy | Safety: High**

### Method 2: Manual Commands (More Control)
```powershell
# Backup
ssh root@82.25.105.18 "cp /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv /var/www/vsfintech/Heatmap/backup_$(date +%Y%m%d).csv"

# Upload
scp "D:\NewData.csv" root@82.25.105.18:/var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv
scp "D:\NewData.csv" root@82.25.105.18:/var/www/vsfintech/Riskometer/backend/data.csv

# Restart
ssh root@82.25.105.18 "pm2 restart heatmap riskometer"
```
**Time: 3 minutes | Difficulty: Medium | Safety: Medium**

### Method 3: Direct SCP (Quickest, No Backup)
```powershell
scp "D:\NewData.csv" root@82.25.105.18:/var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv
ssh root@82.25.105.18 "pm2 restart heatmap"
```
**Time: 30 seconds | Difficulty: Easy | Safety: Low** ⚠️ No backup!

---

## 📋 Files I Created For You

I've created 4 comprehensive files to help you:

### 1. **Update-DataFiles.ps1** (Main Script)
- **What it does**: Automates the entire update process
- **Usage**: `.\Update-DataFiles.ps1 -DataFile "D:\YourFile.csv"`
- **Features**: 
  - Automatic backups with timestamps
  - Validation checks
  - Service restart
  - API testing
  - Color-coded output
  - Error handling

### 2. **DATA-UPDATE-GUIDE.md** (Complete Documentation)
- Detailed explanation of the entire system
- Step-by-step instructions
- Troubleshooting guide
- File format requirements
- Best practices

### 3. **DATA-UPDATE-QUICK-REFERENCE.md** (Cheat Sheet)
- Quick commands
- Common scenarios
- Troubleshooting shortcuts
- One-liners for emergencies

### 4. **DATA-UPDATE-SUMMARY.md** (This File)
- Overview of your current setup
- Quick start guide
- At-a-glance reference

---

## 🔄 Typical Update Workflow

```
┌─────────────────────────────────────┐
│  1. Get New Data from NSE/Source   │
│     (Excel or CSV format)           │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  2. Save as CSV (UTF-8 encoding)   │
│     Example: MarketData_Jan2026.csv │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  3. Run Update Script               │
│     .\Update-DataFiles.ps1          │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  4. Script Does Everything:         │
│     • Validates file                │
│     • Creates backups               │
│     • Uploads to server             │
│     • Sets permissions              │
│     • Clears cache                  │
│     • Restarts services             │
│     • Tests endpoints               │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  5. Verify in Browser               │
│     • http://82.25.105.18/sector-   │
│       heatmap/                      │
│     • http://82.25.105.18/          │
│       riskometer/                   │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  ✅ DONE! Data Updated Successfully │
└─────────────────────────────────────┘
```

---

## 🎬 Quick Start Example

Let's say you downloaded new data as `LatestMarketData.csv` on your Desktop:

```powershell
# Step 1: Open PowerShell
cd D:\VSFintech-Platform

# Step 2: Run the update script
.\Update-DataFiles.ps1 -DataFile "C:\Users\YourName\Desktop\LatestMarketData.csv"

# Step 3: Watch the magic happen! 🎉
# The script will:
# - Validate your file ✅
# - Create backups ✅
# - Upload to server ✅
# - Set permissions ✅
# - Restart services ✅
# - Test endpoints ✅

# Step 4: Open browser and test
# http://82.25.105.18/sector-heatmap/
```

**Total Time: ~60 seconds**

---

## 📊 Which Tools Use This Data?

| Tool | URL | Data File | Port |
|------|-----|-----------|------|
| **Sector Heatmap** | http://82.25.105.18/sector-heatmap/ | Latest_Indices_rawdata_14112025.csv | 8002 |
| **Riskometer** | http://82.25.105.18/riskometer/ | data.csv | 5002 |
| **Right Sector** | http://82.25.105.18/right-sector/ | Latest_Indices_rawdata_14112025.csv | 5000 |
| **Risk-Reward** | http://82.25.105.18/risk-reward/ | data.csv | 5001 |
| **Multi Chart** | http://82.25.105.18/multi-chart/ | Latest_Indices_rawdata_14112025.csv | 9006 |

---

## ⚠️ Important Notes

### File Naming
- You can name your source file anything: `NewData.csv`, `Jan2026.csv`, etc.
- The script automatically uploads it to the correct server locations
- **Both tools get updated** with the same data

### No Code Changes Needed!
- Just replace the CSV file
- Restart the services
- That's it! The Python code automatically reads the file

### Current Data Date
- Your current data is from: **November 14, 2025** (14/11/25)
- You can update to any newer date
- Keep the same CSV format (141 columns)

---

## 🔍 How to Check Current Data Date

```powershell
# Method 1: Check file date
ssh root@82.25.105.18 "ls -lh /var/www/vsfintech/Heatmap/*.csv"

# Method 2: Check data content
ssh root@82.25.105.18 "head -2 /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv"

# Method 3: Check via API
ssh root@82.25.105.18 "curl -s http://localhost:8002/api/indices | python3 -m json.tool | head -20"
```

---

## 🆘 Common Questions

### Q: Do I need to update both files?
**A:** Yes, all 5 tools use the same data! But the script does it automatically for you. All tools (Sector Heatmap, Riskometer, Right Sector, Risk-Reward, and Multi Chart) need the same data.

### Q: What if my file has a different name?
**A:** No problem! The script takes any filename and uploads it correctly to both locations.

### Q: Will this affect other tools?
**A:** Only Sector Heatmap and Riskometer use these CSV files. Other tools (Investment Calculator, PMS Screener, etc.) have their own data sources.

### Q: How often should I update?
**A:** Recommended:
- **Daily** for active trading/analysis
- **Weekly** for general portfolio tracking
- **Monthly** for long-term analysis

### Q: What if something goes wrong?
**A:** The script creates automatic backups! You can restore anytime:
```powershell
ssh root@82.25.105.18 "ls -lh /var/www/vsfintech/Heatmap/*.backup*"
# Then restore the backup you want
```

### Q: Can I test before updating production?
**A:** Yes! Check your CSV file format first:
1. Open in Excel
2. Verify columns match (DATE + 138 indices)
3. Check date format (DD/MM/YY)
4. Ensure no missing values

---

## 🎯 Success Checklist

After running the update script, verify:

- [ ] Script completed without errors
- [ ] Both files uploaded successfully
- [ ] Services restarted (pm2 status shows "online")
- [ ] API endpoints responding:
  - [ ] `curl http://localhost:8002/api/indices` returns indices list
  - [ ] `curl http://localhost:5002/api/indices` returns indices list
- [ ] Browser test:
  - [ ] Sector Heatmap loads
  - [ ] Riskometer loads
  - [ ] Can select an index
  - [ ] Chart/data displays correctly
- [ ] New date range visible in data

---

## 📞 Need Help?

### Check Service Status
```powershell
ssh root@82.25.105.18 "pm2 status"
```

### View Recent Logs
```powershell
ssh root@82.25.105.18 "pm2 logs heatmap --lines 50"
ssh root@82.25.105.18 "pm2 logs riskometer --lines 50"
```

### Test Manually
```powershell
# Test Heatmap API
ssh root@82.25.105.18 "curl http://localhost:8002/api/indices"

# Test Riskometer API
ssh root@82.25.105.18 "curl http://localhost:5002/api/indices"
```

---

## 🎉 Summary

**You asked**: How do I update the November data in all tools?

**Answer**: Run this one command:
```powershell
.\Update-DataFiles.ps1 -DataFile "D:\YourNewDataFile.csv"
```

**That's it!** The script handles:
- ✅ Finding the right files
- ✅ Creating backups
- ✅ Uploading to server
- ✅ Setting permissions
- ✅ Restarting services
- ✅ Testing everything

**Time required**: 60 seconds  
**Difficulty**: Easy (one command)  
**Safety**: High (automatic backups)  
**Tools affected**: 5 tools (Sector Heatmap, Riskometer, Right Sector, Risk-Reward, Multi Chart)

---

## 📚 All Created Files

```
D:\VSFintech-Platform\
├── Update-DataFiles.ps1                  ← Main automation script
├── DATA-UPDATE-GUIDE.md                  ← Complete documentation
├── DATA-UPDATE-QUICK-REFERENCE.md        ← Cheat sheet
└── DATA-UPDATE-SUMMARY.md                ← This file (overview)
```

---

**Created**: January 8, 2026  
**Platform**: VSFintech Platform (http://82.25.105.18/)  
**Current Data**: November 14, 2025  
**Next Update**: Your call! (Run the script anytime)
