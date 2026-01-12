# Update V1 calculation in Risk-Reward app to multiply by 200

Write-Host "Updating Risk-Reward V1 calculation..." -ForegroundColor Cyan
Write-Host ""

$vps = "root@82.25.105.18"

# Step 1: Backup
Write-Host "[1/4] Creating backup..."
ssh $vps "cp /var/www/risk-reward/app.py /var/www/risk-reward/app.py.backup_v1_200"
Write-Host "OK" -ForegroundColor Green

# Step 2: Update V1 formula
Write-Host "[2/4] Updating V1 to multiply by 200..."
ssh $vps 'python3 -c "import re; content = open(''/var/www/risk-reward/app.py'').read(); content = re.sub(r\"result\[.V1.\] = round\(1 - V1_PERCENTILE_MAP\[index_name\], 2\)\", \"result['\''V1'\''] = round((1 - V1_PERCENTILE_MAP[index_name]) * 200, 2)\", content); open(''/var/www/risk-reward/app.py'', ''w'').write(content)"'
Write-Host "OK" -ForegroundColor Green

# Step 3: Restart
Write-Host "[3/4] Restarting service..."
ssh $vps "systemctl restart risk-reward"
Start-Sleep -Seconds 3
Write-Host "OK" -ForegroundColor Green

# Step 4: Test
Write-Host "[4/4] Testing API..."
$test = ssh $vps "curl -s http://localhost:8003/api/risk-return | head -c 200"
if ($test) {
    Write-Host "OK" -ForegroundColor Green
}

Write-Host ""
Write-Host "Complete! V1 now calculates as: (1 - v1) * 200" -ForegroundColor Green
Write-Host "Test: http://82.25.105.18:8003/api/risk-return"
