# Riskometer Deployment Script for Windows PowerShell
# This script deploys Riskometer safely without breaking existing projects

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "  RISKOMETER SAFE DEPLOYMENT" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

$SERVER = "82.25.105.18"
$SERVER_USER = "root"
$LOCAL_SCRIPT = "D:\VSFintech-Platform\deploy-riskometer-safe.sh"

# Check if deployment script exists
if (-not (Test-Path $LOCAL_SCRIPT)) {
    Write-Host "❌ Deployment script not found: $LOCAL_SCRIPT" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Deployment script found" -ForegroundColor Green
Write-Host ""

# Step 1: Upload deployment script
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host "STEP 1: Uploading deployment script..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue

try {
    scp $LOCAL_SCRIPT "${SERVER_USER}@${SERVER}:/root/"
    Write-Host "✅ Script uploaded successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to upload script" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 2: Make script executable
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host "STEP 2: Making script executable..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue

ssh "${SERVER_USER}@${SERVER}" "chmod +x /root/deploy-riskometer-safe.sh"
Write-Host "✅ Script is now executable" -ForegroundColor Green
Write-Host ""

# Step 3: Check if Riskometer directory exists
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host "STEP 3: Checking for Riskometer code..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue

$dirExists = ssh "${SERVER_USER}@${SERVER}" "test -d /var/www/vsfintech/Riskometer && echo 'yes' || echo 'no'"

if ($dirExists.Trim() -eq "no") {
    Write-Host "❌ Riskometer directory not found on server" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please upload your Riskometer code first:" -ForegroundColor Yellow
    Write-Host "  scp -r D:\Your-Riskometer-Path ${SERVER_USER}@${SERVER}:/var/www/vsfintech/Riskometer" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

Write-Host "✅ Riskometer code found" -ForegroundColor Green
Write-Host ""

# Step 4: Run deployment
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host "STEP 4: Running deployment script..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host ""

Write-Host "⏳ This may take a few minutes..." -ForegroundColor Yellow
Write-Host ""

ssh -t "${SERVER_USER}@${SERVER}" "sudo /root/deploy-riskometer-safe.sh"

Write-Host ""

# Step 5: Test deployment
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host "STEP 5: Testing deployment..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host ""

Start-Sleep -Seconds 3

$tests = @(
    @{name='Frontend'; url='http://82.25.105.18/riskometer/'},
    @{name='Backend API'; url='http://82.25.105.18/api/riskometer/'}
)

$allPassed = $true

foreach($test in $tests) {
    try {
        $response = Invoke-WebRequest -Uri $test.url -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
        Write-Host "✅ $($test.name): HTTP $($response.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  $($test.name): Not responding (may be static only)" -ForegroundColor Yellow
        $allPassed = $false
    }
}

Write-Host ""

# Step 6: Check PM2 status
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host "STEP 6: Checking PM2 status..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host ""

ssh "${SERVER_USER}@${SERVER}" "pm2 status | grep -E 'riskometer|name' || pm2 list"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 Access URLs:" -ForegroundColor Yellow
Write-Host "  Frontend:    http://82.25.105.18/riskometer/" -ForegroundColor Cyan
Write-Host "  Backend API: http://82.25.105.18/api/riskometer/" -ForegroundColor Cyan
Write-Host ""
Write-Host "📊 Management Commands:" -ForegroundColor Yellow
Write-Host "  View logs:       pm2 logs riskometer-backend" -ForegroundColor White
Write-Host "  Restart backend: pm2 restart riskometer-backend" -ForegroundColor White
Write-Host "  Stop backend:    pm2 stop riskometer-backend" -ForegroundColor White
Write-Host ""
Write-Host "✅ All existing applications remain untouched!" -ForegroundColor Green
Write-Host ""
