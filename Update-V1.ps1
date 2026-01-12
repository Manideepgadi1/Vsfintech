# Update V1 calculation in Risk-Reward app
# V1 should be multiplied by 200

$vpsHost = "82.25.105.18"
$vpsUser = "root"

Write-Host "==========================================="
Write-Host " Risk-Reward V1 Update: Multiply by 200"
Write-Host "==========================================="
Write-Host ""

# Commands
$backupCmd = 'cp /var/www/risk-reward/app.py /var/www/risk-reward/app.py.backup_v1_200'
$updateCmd = 'sed -i "s/result\['"'"'V1'"'"'\] = round(1 - V1_PERCENTILE_MAP\[index_name\], 2)/result['"'"'V1'"'"'\] = round((1 - V1_PERCENTILE_MAP[index_name]) * 200, 2)/" /var/www/risk-reward/app.py'
$restartCmd = 'systemctl restart risk-reward'
$testCmd = 'curl -s http://localhost:8003/api/risk-return | head -c 300'

Write-Host "[1/4] Creating backup..."
ssh ${vpsUser}@${vpsHost} $backupCmd
Write-Host "OK Backup created" -ForegroundColor Green

Write-Host ""
Write-Host "[2/4] Updating V1 calculation to multiply by 200..."
ssh ${vpsUser}@${vpsHost} $updateCmd
Write-Host "OK V1 formula updated" -ForegroundColor Green

Write-Host ""
Write-Host "[3/4] Restarting risk-reward service..."
ssh ${vpsUser}@${vpsHost} $restartCmd
Start-Sleep -Seconds 3
Write-Host "OK Service restarted" -ForegroundColor Green

Write-Host ""
Write-Host "[4/4] Testing API..."
$response = ssh ${vpsUser}@${vpsHost} $testCmd
if ($response) {
    Write-Host "OK API responding" -ForegroundColor Green
}

Write-Host ""
Write-Host "==========================================="
Write-Host "OK V1 Update Complete!" -ForegroundColor Green
Write-Host "==========================================="
Write-Host ""
Write-Host 'Formula: V1 = (1 - original_v1) * 200'
Write-Host 'Test at: http://82.25.105.18:8003/api/risk-return'
