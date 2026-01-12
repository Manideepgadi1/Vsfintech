#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Updates data files across all VSFintech tools
    
.DESCRIPTION
    This script automates the process of updating Excel/CSV data files 
    used by Sector Heatmap, Riskometer, and other tools.
    
.PARAMETER DataFile
    Path to the new data file (CSV or Excel)
    
.PARAMETER BackupFirst
    Create backup before updating (default: true)
    
.PARAMETER RestartServices
    Restart services after update (default: true)
    
.EXAMPLE
    .\Update-DataFiles.ps1 -DataFile "D:\NewMarketData.csv"
    
.EXAMPLE
    .\Update-DataFiles.ps1 -DataFile "D:\NewMarketData.csv" -BackupFirst $true -RestartServices $true
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$DataFile,
    
    [Parameter(Mandatory=$false)]
    [bool]$BackupFirst = $true,
    
    [Parameter(Mandatory=$false)]
    [bool]$RestartServices = $true,
    
    [Parameter(Mandatory=$false)]
    [string]$ServerIP = "82.25.105.18",
    
    [Parameter(Mandatory=$false)]
    [string]$ServerUser = "root"
)

# Colors for output
$Colors = @{
    Success = "Green"
    Error = "Red"
    Warning = "Yellow"
    Info = "Cyan"
}

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )
    Write-Host $Message -ForegroundColor $Colors[$Type]
}

function Test-FileExists {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        Write-ColorOutput "❌ Error: File not found: $FilePath" "Error"
        return $false
    }
    return $true
}

function Get-FileSize {
    param([string]$FilePath)
    
    $size = (Get-Item $FilePath).Length
    $sizeMB = [math]::Round($size / 1MB, 2)
    return "$sizeMB MB"
}

# Main script
Write-ColorOutput "`n╔════════════════════════════════════════════════════════╗" "Info"
Write-ColorOutput "║   VSFintech Platform - Data Update Tool              ║" "Info"
Write-ColorOutput "╚════════════════════════════════════════════════════════╝`n" "Info"

# Step 1: Validate input file
Write-ColorOutput "📋 Step 1: Validating data file..." "Info"

if (-not (Test-FileExists $DataFile)) {
    exit 1
}

$fileSize = Get-FileSize $DataFile
$fileName = Split-Path $DataFile -Leaf
$fileExt = [System.IO.Path]::GetExtension($DataFile)

Write-ColorOutput "✅ File found: $fileName" "Success"
Write-ColorOutput "   Size: $fileSize" "Info"
Write-ColorOutput "   Type: $fileExt`n" "Info"

# Validate file type
if ($fileExt -notin @('.csv', '.xlsx', '.xls')) {
    Write-ColorOutput "❌ Error: Invalid file type. Must be CSV or Excel (.csv, .xlsx, .xls)" "Error"
    exit 1
}

# Warn if file is too small (might be empty or corrupted)
if ((Get-Item $DataFile).Length -lt 1MB) {
    Write-ColorOutput "⚠️  Warning: File size is less than 1 MB. This seems small for market data." "Warning"
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne 'y') {
        Write-ColorOutput "Update cancelled by user." "Warning"
        exit 0
    }
}

# Step 2: Backup existing files (if enabled)
if ($BackupFirst) {
    Write-ColorOutput "`n📦 Step 2: Creating backups..." "Info"
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    
    $backupCommands = @(
        "cp /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv.backup_$timestamp 2>/dev/null || echo 'Heatmap backup skipped'",
        "cp /var/www/vsfintech/Riskometer/backend/data.csv /var/www/vsfintech/Riskometer/backend/data.csv.backup_$timestamp 2>/dev/null || echo 'Riskometer backup skipped'"
    )
    
    foreach ($cmd in $backupCommands) {
        $result = ssh "$ServerUser@$ServerIP" $cmd
        Write-ColorOutput "   $result" "Success"
    }
    
    Write-ColorOutput "✅ Backups created with timestamp: $timestamp`n" "Success"
} else {
    Write-ColorOutput "`n⏭️  Step 2: Backup skipped (disabled)`n" "Warning"
}

# Step 3: Upload new data files
Write-ColorOutput "📤 Step 3: Uploading new data files..." "Info"

# Define target paths
$targets = @(
    @{
        Path = "/var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv"
        Service = "Sector Heatmap (Port 8002)"
        Owner = "root:root"
        Permissions = "644"
    },
    @{
        Path = "/var/www/vsfintech/Riskometer/backend/data.csv"
        Service = "Riskometer (Port 5002)"
        Owner = "www-data:www-data"
        Permissions = "755"
    },
    @{
        Path = "/var/www/vsfintech/Right-Sector/data/Latest_Indices_rawdata_14112025.csv"
        Service = "Right Sector (Port 5000)"
        Owner = "www-data:www-data"
        Permissions = "755"
    },
    @{
        Path = "/var/www/vsfintech/Risk-Reward/data.csv"
        Service = "Risk-Reward (Port 5001)"
        Owner = "root:root"
        Permissions = "644"
    },
    @{
        Path = "/var/www/vsfintech/MultiChart/Latest_Indices_rawdata_14112025.csv"
        Service = "Multi Chart (Port 9006)"
        Owner = "www-data:www-data"
        Permissions = "755"
    }
)

$uploadSuccess = $true

foreach ($target in $targets) {
    Write-ColorOutput "   Uploading to: $($target.Service)..." "Info"
    
    try {
        # Upload file
        $uploadResult = scp $DataFile "${ServerUser}@${ServerIP}:$($target.Path)" 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "   ✅ Upload successful: $($target.Service)" "Success"
            
            # Set permissions
            $chownCmd = "chown $($target.Owner) $($target.Path)"
            $chmodCmd = "chmod $($target.Permissions) $($target.Path)"
            
            ssh "$ServerUser@$ServerIP" "$chownCmd && $chmodCmd"
            Write-ColorOutput "   ✅ Permissions set: $($target.Owner) ($($target.Permissions))" "Success"
        } else {
            Write-ColorOutput "   ❌ Upload failed: $($target.Service)" "Error"
            $uploadSuccess = $false
        }
    } catch {
        Write-ColorOutput "   ❌ Error uploading to $($target.Service): $_" "Error"
        $uploadSuccess = $false
    }
}

if (-not $uploadSuccess) {
    Write-ColorOutput "`n❌ Some uploads failed. Please check the errors above." "Error"
    exit 1
}

Write-ColorOutput "`n✅ All files uploaded successfully!`n" "Success"

# Step 4: Verify uploads
Write-ColorOutput "🔍 Step 4: Verifying uploads..." "Info"

$verifyCmd = @"
echo '=== HEATMAP ===' && ls -lh /var/www/vsfintech/Heatmap/Latest_Indices_rawdata_14112025.csv 2>/dev/null || echo 'Not found' && \
echo '' && \
echo '=== RISKOMETER ===' && ls -lh /var/www/vsfintech/Riskometer/backend/data.csv 2>/dev/null || echo 'Not found'
"@

$verifyResult = ssh "$ServerUser@$ServerIP" $verifyCmd
Write-ColorOutput $verifyResult "Info"

# Step 5: Clear Python cache
Write-ColorOutput "`n🗑️  Step 5: Clearing Python cache..." "Info"

$clearCacheCmd = "find /var/www/vsfintech -type d -name '__pycache__' -exec rm -rf {} + 2>/dev/null; echo 'Cache cleared'"
$cacheResult = ssh "$ServerUser@$ServerIP" $clearCacheCmd
Write-ColorOutput "   $cacheResult" "Success"

# Step 6: Restart services (if enabled)
if ($RestartServices) {
    Write-ColorOutput "`n🔄 Step 6: Restarting backend services..." "Info"
    
    $services = @(
        @{ Name = "heatmap"; Display = "Sector Heatmap (Port 8002)" },
        @{ Name = "riskometer"; Display = "Riskometer (Port 5002)" },
        @{ Name = "right-sector"; Display = "Right Sector (Port 5000)" },
        @{ Name = "risk-reward"; Display = "Risk-Reward (Port 5001)" },
        @{ Name = "multi-chart"; Display = "Multi Chart (Port 9006)" }
    )
    
    foreach ($service in $services) {
        Write-ColorOutput "   Restarting $($service.Display)..." "Info"
        $restartResult = ssh "$ServerUser@$ServerIP" "pm2 restart $($service.Name) 2>&1"
        
        if ($restartResult -match "restart|success") {
            Write-ColorOutput "   ✅ $($service.Display) restarted" "Success"
        } else {
            Write-ColorOutput "   ⚠️  $($service.Display) restart status unknown" "Warning"
        }
        Start-Sleep -Seconds 2
    }
    
    Write-ColorOutput "`n✅ Services restarted!`n" "Success"
} else {
    Write-ColorOutput "`n⏭️  Step 6: Service restart skipped (disabled)`n" "Warning"
    Write-ColorOutput "⚠️  Remember to restart services manually:" "Warning"
    Write-ColorOutput "   ssh $ServerUser@$ServerIP 'pm2 restart heatmap riskometer'`n" "Info"
}

# Step 7: Test endpoints
Write-ColorOutput "🧪 Step 7: Testing API endpoints..." "Info"

$testCommands = @(
    @{
        Name = "Sector Heatmap"
        Command = "curl -s http://localhost:8002/api/indices | head -c 200"
    },
    @{
        Name = "Riskometer"
        Command = "curl -s http://localhost:5002/api/indices | head -c 200"
    },
    @{
        Name = "Right Sector"
        Command = "curl -s http://localhost:5000/ | head -c 200"
    },
    @{
        Name = "Risk-Reward"
        Command = "curl -s http://localhost:5001/ | head -c 200"
    }
)

foreach ($test in $testCommands) {
    Write-ColorOutput "   Testing $($test.Name)..." "Info"
    
    $testResult = ssh "$ServerUser@$ServerIP" $test.Command
    
    if ($testResult -match "indices|NIFTY") {
        Write-ColorOutput "   ✅ $($test.Name) responding correctly" "Success"
    } else {
        Write-ColorOutput "   ⚠️  $($test.Name) response unclear" "Warning"
    }
}

# Summary
Write-ColorOutput "`n╔════════════════════════════════════════════════════════╗" "Success"
Write-ColorOutput "║             ✅ DATA UPDATE COMPLETED!                  ║" "Success"
Write-ColorOutput "╚════════════════════════════════════════════════════════╝`n" "Success"

Write-ColorOutput "📊 Summary:" "Info"
Write-ColorOutput "   • Source file: $fileName ($fileSize)" "Info"
Write-ColorOutput "   • Updated services: 5 tools (Heatmap, Riskometer, Right Sector, Risk-Reward, Multi Chart)" "Info"
Write-ColorOutput "   • Backup created: $(if($BackupFirst){'Yes'}else{'No'})" "Info"
Write-ColorOutput "   • Services restarted: $(if($RestartServices){'Yes'}else{'No'})`n" "Info"

Write-ColorOutput "🌐 Test in browser:" "Info"
Write-ColorOutput "   • Sector Heatmap: http://82.25.105.18/sector-heatmap/" "Cyan"
Write-ColorOutput "   • Riskometer: http://82.25.105.18/riskometer/" "Cyan"
Write-ColorOutput "   • Right Sector: http://82.25.105.18/right-sector/" "Cyan"
Write-ColorOutput "   • Risk-Reward: http://82.25.105.18/risk-reward/" "Cyan"
Write-ColorOutput "   • Multi Chart: http://82.25.105.18/multi-chart/`n" "Cyan"

Write-ColorOutput "📝 Next steps:" "Info"
Write-ColorOutput "   1. Open the tools in your browser" "Info"
Write-ColorOutput "   2. Select an index and verify data is loading" "Info"
Write-ColorOutput "   3. Check the date range in the data" "Info"
Write-ColorOutput "   4. If issues occur, check logs: ssh $ServerUser@$ServerIP 'pm2 logs heatmap'`n" "Info"

# Optional: Open browser
$openBrowser = Read-Host "Would you like to open the tools in your browser? (y/n)"
if ($openBrowser -eq 'y') {
    Start-Process "http://82.25.105.18/sector-heatmap/"
    Start-Sleep -Seconds 2
    Start-Process "http://82.25.105.18/riskometer/"
}

Write-ColorOutput "`n✨ Done! Data files updated successfully.`n" "Success"
