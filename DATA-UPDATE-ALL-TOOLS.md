# 🎯 VSFintech Data Update - All Tools Overview

## ✅ Confirmed: 5 Tools Use The Same Data File

Based on the server analysis, these **5 tools** all use the same November 14, 2025 market data:

### 📊 Data Files Inventory

| # | Tool | Data File Path | Size | Port | Status |
|---|------|----------------|------|------|--------|
| 1 | **Sector Heatmap** | `/var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv` | 6.8 MB | 8002 | ✅ Active |
| 2 | **Riskometer** | `/var/www/vsfintech/Riskometer/backend/data.csv` | 6.8 MB | 5002 | ✅ Active |
| 3 | **Right Sector** | `/var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv` | 6.8 MB | 5000 | ✅ Active |
| 4 | **Risk-Reward** | `/var/www/vsfintech/Risk-Reward/data.csv` | 6.7 MB | 5001 | ✅ Active |
| 5 | **Multi Chart** | `/var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv` | 6.8 MB | 9006 | ✅ Active |

---

## 🚀 How to Update ALL 5 Tools at Once

### The Automated Way (Recommended) ⭐

```powershell
cd D:\VSFintech-Platform
.\Update-DataFiles.ps1 -DataFile "D:\YourNewDataFile.csv"
```

**What the script does:**
1. ✅ Validates your new data file
2. ✅ Creates backups of all 5 existing files
3. ✅ Uploads to all 5 locations
4. ✅ Sets correct permissions for each tool
5. ✅ Clears Python cache
6. ✅ Restarts all 5 services
7. ✅ Tests all API endpoints

**Time: 60-90 seconds | All 5 tools updated automatically!**

---

## 📁 File Locations Breakdown

### Common Data Format
All 5 files contain:
- **Date Range**: Historical data up to November 14, 2025
- **Columns**: 141 (DATE + 138 NIFTY indices + 2 mutual funds)
- **Format**: CSV (comma-separated values)
- **Encoding**: UTF-8
- **Size**: ~6.7-6.8 MB

### File Structure
```
/var/www/vsfintech/
│
├── Heatmap/
│   └── Latest_Indices_rawdata_14112025.csv          [6.8 MB] ← Tool 1
│
├── Riskometer/
│   └── backend/
│       └── data.csv                                  [6.8 MB] ← Tool 2
│
├── Right-Sector/
│   └── data/
│       └── Latest_Indices_rawdata_14112025.csv      [6.8 MB] ← Tool 3
│
├── Risk-Reward/
│   └── data.csv                                      [6.7 MB] ← Tool 4
│
└── MultiChart/
    └── Latest_Indices_rawdata_14112025.csv          [6.8 MB] ← Tool 5
```

---

## 🔄 Manual Update Process (If Needed)

### Step 1: Backup All Files
```bash
ssh root@82.25.105.18
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)

cp /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv \
   /var/www/vsfintech/Heatmap/backup_$BACKUP_DATE.csv

cp /var/www/vsfintech/Riskometer/backend/data.csv \
   /var/www/vsfintech/Riskometer/backend/backup_$BACKUP_DATE.csv

cp /var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv \
   /var/www/vsfintech/Right-Sector/data/backup_$BACKUP_DATE.csv

cp /var/www/vsfintech/Risk-Reward/data.csv \
   /var/www/vsfintech/Risk-Reward/backup_$BACKUP_DATE.csv

cp /var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv \
   /var/www/vsfintech/MultiChart/backup_$BACKUP_DATE.csv
```

### Step 2: Upload New Data to All 5 Locations
```powershell
# From Windows PowerShell
$dataFile = "D:\YourNewMarketData.csv"
$server = "root@82.25.105.18"

# Upload to all 5 tools
scp $dataFile "${server}:/var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv"
scp $dataFile "${server}:/var/www/vsfintech/Riskometer/backend/data.csv"
scp $dataFile "${server}:/var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv"
scp $dataFile "${server}:/var/www/vsfintech/Risk-Reward/data.csv"
scp $dataFile "${server}:/var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv"
```

### Step 3: Set Correct Permissions
```bash
ssh root@82.25.105.18

# Heatmap (root:root, 644)
chown root:root /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv
chmod 644 /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv

# Riskometer (www-data:www-data, 755)
chown www-data:www-data /var/www/vsfintech/Riskometer/backend/data.csv
chmod 755 /var/www/vsfintech/Riskometer/backend/data.csv

# Right Sector (www-data:www-data, 755)
chown www-data:www-data /var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv
chmod 755 /var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv

# Risk-Reward (root:root, 644)
chown root:root /var/www/vsfintech/Risk-Reward/data.csv
chmod 644 /var/www/vsfintech/Risk-Reward/data.csv

# Multi Chart (www-data:www-data, 755)
chown www-data:www-data /var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv
chmod 755 /var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv
```

### Step 4: Clear Cache and Restart All Services
```bash
ssh root@82.25.105.18

# Clear Python cache
find /var/www/vsfintech -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null

# Restart all 5 services
pm2 restart heatmap        # Sector Heatmap
pm2 restart riskometer     # Riskometer
pm2 restart right-sector   # Right Sector
pm2 restart risk-reward    # Risk-Reward
pm2 restart multi-chart    # Multi Chart

# Or restart everything at once
pm2 restart all
```

### Step 5: Verify All Updates
```bash
# Check file timestamps
ls -lh /var/www/vsfintech/Heatmap/*.csv
ls -lh /var/www/vsfintech/Riskometer/backend/data.csv
ls -lh /var/www/vsfintech/Right-Sector/data/*.csv
ls -lh /var/www/vsfintech/Risk-Reward/data.csv
ls -lh /var/www/vsfintech/MultiChart/*.csv

# Check service status
pm2 status

# Test APIs
curl -s http://localhost:8002/api/indices | head -c 100  # Heatmap
curl -s http://localhost:5002/api/indices | head -c 100  # Riskometer
curl -s http://localhost:5000/ | head -c 100             # Right Sector
curl -s http://localhost:5001/ | head -c 100             # Risk-Reward
curl -s http://localhost:9006/ | head -c 100             # Multi Chart (if active)
```

---

## 🧪 Test All Tools After Update

Open each tool in your browser and verify:

| Tool | URL | Test Action |
|------|-----|-------------|
| Sector Heatmap | http://82.25.105.18/sector-heatmap/ | Select NIFTY 50, check heatmap loads |
| Riskometer | http://82.25.105.18/riskometer/ | Select an index, verify risk chart appears |
| Right Sector | http://82.25.105.18/right-sector/ | Check sector rotation data |
| Risk-Reward | http://82.25.105.18/risk-reward/ | Verify risk-reward metrics display |
| Multi Chart | http://82.25.105.18/multi-chart/ | Test chart rendering (if deployed) |

---

## 📊 Data File Details

### Current Data Information
- **Source Date**: November 14, 2025 (14/11/25)
- **Total Indices**: 138 NIFTY indices
- **Additional Data**: 2 mutual fund portfolios (DSP QUANT, DSP ELSS, etc.)
- **Format**: CSV with headers

### Sample Data Structure
```csv
DATE,NIFTY 50,NIFTY NEXT 50,NIFTY 100,...(138 more columns)
10/11/25,38366.88,99651.76,35940.79,...
09/11/25,38366.88,99651.76,35940.79,...
08/11/25,38366.88,99651.76,35940.79,...
```

### Indices Categories Included
- **Broad Market**: NIFTY 50, NIFTY 100, NIFTY 500, etc.
- **Sectoral**: Auto, Bank, IT, Pharma, Energy, etc.
- **Thematic**: EV, Manufacturing, Defence, Digital, etc.
- **Strategy**: Momentum, Quality, Value, Low Volatility, etc.
- **Custom**: Corporate Groups (Tata, Birla, Mahindra)

---

## 🔍 Verification Commands

### Check Current Data Dates
```bash
ssh root@82.25.105.18 "head -2 /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv"
```

### Check File Sizes (Should All Be Similar)
```bash
ssh root@82.25.105.18 "
  echo 'Tool 1 - Heatmap:' && du -h /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv
  echo 'Tool 2 - Riskometer:' && du -h /var/www/vsfintech/Riskometer/backend/data.csv
  echo 'Tool 3 - Right Sector:' && du -h /var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv
  echo 'Tool 4 - Risk-Reward:' && du -h /var/www/vsfintech/Risk-Reward/data.csv
  echo 'Tool 5 - Multi Chart:' && du -h /var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv
"
```

### Compare File Checksums (Verify They're All The Same)
```bash
ssh root@82.25.105.18 "
  md5sum /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv
  md5sum /var/www/vsfintech/Riskometer/backend/data.csv
  md5sum /var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv
  md5sum /var/www/vsfintech/Risk-Reward/data.csv
  md5sum /var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv
"
```
*All checksums should match if files contain identical data*

---

## ⚠️ Important Notes

### About Right Amount (Port 8001)
Right Amount tool was not found to use a local CSV file. It may:
- Use API calls to fetch data dynamically
- Store data in a database
- Use a different data source

**Action**: No need to update Right Amount when updating market data CSVs.

### About PMS Screener (Port 8004)
PMS Screener uses a separate data source:
- Location: `/var/www/vsfintech/fundscreener/FinExport_11-12-2025.csv`
- Different format (mutual fund data)
- Not affected by this update

---

## 🎯 Quick Command Summary

### One-Line Update (Automated)
```powershell
.\Update-DataFiles.ps1 -DataFile "D:\NewData.csv"
```

### One-Line Manual Upload
```powershell
$f="D:\NewData.csv"; $s="root@82.25.105.18"; scp $f "$s:/var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv"; scp $f "$s:/var/www/vsfintech/Riskometer/backend/data.csv"; scp $f "$s:/var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv"; scp $f "$s:/var/www/vsfintech/Risk-Reward/data.csv"; scp $f "$s:/var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv"; ssh $s "pm2 restart heatmap riskometer right-sector risk-reward multi-chart"
```

### One-Line Verification
```bash
ssh root@82.25.105.18 "ls -lh /var/www/vsfintech/{Heatmap,Riskometer/backend,Right-Sector/data,Risk-Reward,MultiChart}/*.csv 2>/dev/null | grep -E 'Latest_Indices|data.csv'"
```

---

## 📚 Documentation Files

All comprehensive guides are available:

1. **[Update-DataFiles.ps1](file:///d:/VSFintech-Platform/Update-DataFiles.ps1)** - Automated script (includes all 5 tools)
2. **[DATA-UPDATE-GUIDE.md](file:///d:/VSFintech-Platform/DATA-UPDATE-GUIDE.md)** - Complete manual (updated)
3. **[DATA-UPDATE-QUICK-REFERENCE.md](file:///d:/VSFintech-Platform/DATA-UPDATE-QUICK-REFERENCE.md)** - Cheat sheet (updated)
4. **[DATA-UPDATE-SUMMARY.md](file:///d:/VSFintech-Platform/DATA-UPDATE-SUMMARY.md)** - Overview (updated)
5. **[DATA-UPDATE-ALL-TOOLS.md](file:///d:/VSFintech-Platform/DATA-UPDATE-ALL-TOOLS.md)** - This file (complete inventory)

---

## ✅ Summary

**You asked**: "Risk Reward, Right Sector, Right Amount, and Multi Chart also use the same Excel sheet, right?"

**Answer**: 
- ✅ **YES** - Risk Reward uses same data (`/var/www/vsfintech/Risk-Reward/data.csv`)
- ✅ **YES** - Right Sector uses same data (`/var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv`)
- ✅ **YES** - Multi Chart uses same data (`/var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv`)
- ❌ **NO** - Right Amount doesn't appear to use local CSV files (may use API or database)

**Total Tools Using Same Data**: **5 tools**
1. Sector Heatmap (Port 8002)
2. Riskometer (Port 5002)
3. Right Sector (Port 5000)
4. Risk-Reward (Port 5001)
5. Multi Chart (Port 9006)

**Updated Script**: The `Update-DataFiles.ps1` script now automatically updates all 5 tools at once!

---

**Created**: January 8, 2026  
**Status**: All 5 tools identified and script updated  
**Next Action**: Run `.\Update-DataFiles.ps1 -DataFile "YourNewData.csv"` when ready to update
