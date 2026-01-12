#!/bin/bash

# Quick Deploy Riskometer - Windows Compatible Commands
# Run these commands from PowerShell on Windows

echo "=============================================="
echo "  RISKOMETER DEPLOYMENT - QUICK START"
echo "=============================================="
echo ""
echo "📋 Prerequisites:"
echo "1. Riskometer code uploaded to /var/www/vsfintech/Riskometer"
echo "2. SSH access to server (82.25.105.18)"
echo ""
echo "🚀 Deployment Steps:"
echo ""

# Step 1
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 1: Upload Deployment Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Run this in PowerShell:"
echo ""
echo 'scp D:\VSFintech-Platform\deploy-riskometer-safe.sh root@82.25.105.18:/root/'
echo ""

# Step 2
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 2: Run Deployment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Run these in PowerShell:"
echo ""
echo 'ssh root@82.25.105.18 "chmod +x /root/deploy-riskometer-safe.sh"'
echo 'ssh root@82.25.105.18 "sudo /root/deploy-riskometer-safe.sh"'
echo ""

# Step 3
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 3: Test Deployment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Run this in PowerShell to test:"
echo ""
cat << 'PSEOF'
# Test Riskometer deployment
Write-Host "`n=== Testing Riskometer Deployment ===`n" -ForegroundColor Cyan

$urls = @(
    @{name='Frontend'; url='/riskometer/'},
    @{name='Backend API'; url='/api/riskometer/'}
)

foreach($test in $urls) {
    try {
        $response = Invoke-WebRequest -Uri "http://82.25.105.18$($test.url)" -UseBasicParsing -TimeoutSec 10
        Write-Host "✅ $($test.name): HTTP $($response.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "❌ $($test.name): Failed" -ForegroundColor Red
    }
}

Write-Host "`n✅ Deployment test complete!`n" -ForegroundColor Green
PSEOF
echo ""

echo "=============================================="
echo "📚 For detailed information, see:"
echo "   RISKOMETER-DEPLOYMENT-GUIDE.md"
echo "=============================================="
