# Data Update Guide for VSFintech Platform

## Overview
All tools use Excel/CSV data files with market indices data. The current data is from **November 14, 2025** and needs periodic updates.

## Current Data Files Location

### Main Data File
```
📁 /var/www/vsfintech/Heatmap/
   └── Latest_Indices_rawdata_14112025.csv (6.8 MB)
   
📁 /var/www/vsfintech/Riskometer/backend/
   └── data.csv (6.8 MB)

📁 /var/www/vsfintech/Right-Sector/data/
   └── Latest_Indices_rawdata_14112025.csv (6.8 MB)

📁 /var/www/vsfintech/Risk-Reward/
   └── data.csv (6.7 MB)

📁 /var/www/vsfintech/MultiChart/
   └── Latest_Indices_rawdata_14112025.csv (6.8 MB)
```

All files contain the same dataset (same size ~6.8 MB).

## Tools Using This Data

1. **Sector Heatmap** - `/var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv`
2. **Riskometer** - `/var/www/vsfintech/Riskometer/backend/data.csv`
3. **Right Sector** - `/var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv`
4. **Risk-Reward** - `/var/www/vsfintech/Risk-Reward/data.csv`
5. **Multi Chart** - `/var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv`
6. **Right Amount** - May use API or different data source

## Data File Format

The CSV file contains:
- **Columns**: Date, Index Name, Stock Symbols, Prices, Returns, etc.
- **Size**: ~6.8 MB (thousands of rows)
- **Date Range**: Historical data up to November 14, 2025

## How to Update Data Files

### Method 1: Direct Upload (Recommended)

#### Step 1: Prepare Your Updated Excel/CSV File
```powershell
# Make sure your file is named appropriately with the new date
# Example: Latest_Indices_rawdata_08012026.csv
```

#### Step 2: Backup Current Data
```bash
# On server
ssh root@82.25.105.18

# Backup existing files
cp /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv \
   /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv.backup

cp /var/www/vsfintech/Riskometer/backend/data.csv \
   /var/www/vsfintech/Riskometer/backend/data.csv.backup

cp /var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv \
   /var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv.backup

cp /var/www/vsfintech/Risk-Reward/data.csv \
   /var/www/vsfintech/Risk-Reward/data.csv.backup

cp /var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv \
   /var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv.backup
```

#### Step 3: Upload New Data File
```powershell
# From your local machine (Windows)
# Upload to all tools
scp "D:\YourNewDataFile.csv" root@82.25.105.18:/var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv
scp "D:\YourNewDataFile.csv" root@82.25.105.18:/var/www/vsfintech/Riskometer/backend/data.csv
scp "D:\YourNewDataFile.csv" root@82.25.105.18:/var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv
scp "D:\YourNewDataFile.csv" root@82.25.105.18:/var/www/vsfintech/Risk-Reward/data.csv
scp "D:\YourNewDataFile.csv" root@82.25.105.18:/var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv
```

#### Step 4: Set Correct Permissions
```bash
# On server
ssh root@82.25.105.18

# Set permissions for Heatmap
chown root:root /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv
chmod 644 /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv

# Set permissions for Riskometer
chown www-data:www-data /var/www/vsfintech/Riskometer/backend/data.csv
chmod 755 /var/www/vsfintech/Riskometer/backend/data.csv

# Set permissions for Right Sector
chown www-data:www-data /var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv
chmod 755 /var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv

# Set permissions for Risk-Reward
chown root:root /var/www/vsfintech/Risk-Reward/data.csv
chmod 644 /var/www/vsfintech/Risk-Reward/data.csv

# Set permissions for Multi Chart
chown www-data:www-data /var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv
chmod 755 /var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv
```

#### Step 5: Restart Backend Services
```bash
# Restart all services that use the data
pm2 restart heatmap        # Sector Heatmap (Port 8002)
pm2 restart riskometer     # Riskometer (Port 5002)
pm2 restart right-sector   # Right Sector (Port 5000)
pm2 restart risk-reward    # Risk-Reward (Port 5001)
pm2 restart multi-chart    # Multi Chart (Port 9006)

# Or restart all services at once
pm2 restart all
```

#### Step 6: Verify Data Update
```bash
# Check file dates
ls -lh /var/www/vsfintech/Heatmap/*.csv
ls -lh /var/www/vsfintech/Riskometer/backend/data.csv
ls -lh /var/www/vsfintech/Right-Sector/data/*.csv
ls -lh /var/www/vsfintech/Risk-Reward/data.csv
ls -lh /var/www/vsfintech/MultiChart/*.csv

# Test API endpoints
curl http://localhost:8002/api/indices | head
curl http://localhost:5002/api/indices | head
curl http://localhost:5000/ | head
curl http://localhost:5001/ | head
```

---

### Method 2: Update with New Filename (Requires Code Changes)

If you want to keep the date in the filename (e.g., `Latest_Indices_rawdata_08012026.csv`):

#### Step 1: Upload with New Name
```powershell
scp "D:\YourNewDataFile_08012026.csv" root@82.25.105.18:/var/www/vsfintech/Heatmap/
```

#### Step 2: Update Code References
You need to update the Python code that reads the CSV file:

**For Sector Heatmap:**
```bash
# Edit the main Python file
nano /var/www/vsfintech/Heatmap/main.py

# Find lines like:
# df = pd.read_csv('Latest_Indices_rawdata_14112025.csv')
# Change to:
# df = pd.read_csv('Latest_Indices_rawdata_08012026.csv')
```

**For Riskometer:**
```bash
# Edit the main Python file
nano /var/www/vsfintech/Riskometer/backend/main.py

# Update CSV filename in the code
```

#### Step 3: Restart Services
```bash
pm2 restart all
```

---

## Quick Update Script

I'll create a PowerShell script for you to automate this process:

### Prerequisites
- Your new data file ready (Excel or CSV)
- SSH access to server
- File path: `D:\YourDataFile.csv`

---

## Data File Requirements

### Expected CSV Format
```csv
Date,Index,Symbol,Price,Change,Volume,...
2025-11-14,NIFTY 50,RELIANCE,2500.50,1.2,1000000,...
2025-11-14,NIFTY 50,TCS,3800.25,-0.5,800000,...
...
```

### Key Points:
1. **Date Column** - Should be the latest market data date
2. **Index Names** - Must match existing index names (e.g., "NIFTY 50", "NIFTY BANK")
3. **Encoding** - UTF-8 encoding
4. **Delimiter** - Comma (`,`)
5. **File Size** - Similar to current (~6-7 MB for full dataset)

---

## Troubleshooting

### Issue 1: Service Not Reflecting New Data
```bash
# Clear Python cache
ssh root@82.25.105.18
find /var/www/vsfintech -name "__pycache__" -exec rm -rf {} +

# Restart services
pm2 restart all
```

### Issue 2: Permission Denied
```bash
# Fix permissions
chown -R www-data:www-data /var/www/vsfintech/Heatmap/
chown -R www-data:www-data /var/www/vsfintech/Riskometer/backend/
```

### Issue 3: File Format Error
- Ensure CSV is properly formatted
- Check for special characters
- Verify encoding is UTF-8
- Make sure column names match expected format

---

## Best Practices

1. **Always Backup First** - Never overwrite without backup
2. **Test Locally First** - If possible, test with sample data
3. **Update During Off-Peak Hours** - Minimize user disruption
4. **Verify Data Quality** - Check for missing values, correct formats
5. **Monitor After Update** - Check logs for errors
   ```bash
   pm2 logs heatmap
   pm2 logs riskometer
   ```

---

## Check Which Tools Use Data

To find all files that reference the CSV:
```bash
ssh root@82.25.105.18
grep -r "Latest_Indices_rawdata" /var/www/vsfintech/*/main.py
grep -r "data.csv" /var/www/vsfintech/*/backend/main.py
```

---

## Regular Update Schedule

**Recommended:** Update data files:
- **Monthly** - For general market data
- **Weekly** - For high-frequency trading data
- **After Market Events** - Corporate actions, index rebalancing

---

## Support Files

The following supporting files are also in the Heatmap directory:
```
- NIFTY_All_Indices_4_Category_Only.xlsx (7 KB)
- NIFTY_Index_Short_Names.xlsx (8 KB)
- categorized_indices.json (15 KB)
- indices_with_short_names.json (16 KB)
- name_mapping.json (5 KB)
- summary_data.json (14 KB)
```

These may also need updates if index names or categories change.

---

## Next Steps

1. ✅ Review this guide
2. ⬜ Prepare your updated data file
3. ⬜ Run the update script (I'll create it next)
4. ⬜ Verify all tools are working
5. ⬜ Set up a regular update schedule
