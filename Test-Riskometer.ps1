# Test Riskometer Deployment
# Quick test script to verify Riskometer is working

Write-Host "`n=== RISKOMETER DEPLOYMENT TEST ===`n" -ForegroundColor Cyan

$server = "82.25.105.18"

Write-Host "Testing Riskometer deployment on $server...`n" -ForegroundColor Yellow

$tests = @(
    @{
        name = 'Frontend'
        url = "http://$server/riskometer/"
        expectedCodes = @(200, 304)
    },
    @{
        name = 'Backend API'
        url = "http://$server/api/riskometer/"
        expectedCodes = @(200, 404)  # 404 is ok if no root route
    }
)

$results = @()

foreach($test in $tests) {
    Write-Host "Testing $($test.name)..." -NoNewline
    try {
        $response = Invoke-WebRequest -Uri $test.url -UseBasicParsing -TimeoutSec 15 -ErrorAction Stop
        
        if ($test.expectedCodes -contains $response.StatusCode) {
            Write-Host " ✅ HTTP $($response.StatusCode)" -ForegroundColor Green
            $results += @{name=$test.name; status='PASS'; code=$response.StatusCode}
        } else {
            Write-Host " ⚠️  HTTP $($response.StatusCode) (unexpected)" -ForegroundColor Yellow
            $results += @{name=$test.name; status='WARN'; code=$response.StatusCode}
        }
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -and ($test.expectedCodes -contains $statusCode)) {
            Write-Host " ✅ HTTP $statusCode" -ForegroundColor Green
            $results += @{name=$test.name; status='PASS'; code=$statusCode}
        } else {
            Write-Host " ❌ Failed: $($_.Exception.Message)" -ForegroundColor Red
            $results += @{name=$test.name; status='FAIL'; code='N/A'}
        }
    }
}

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue

# Summary
$passed = ($results | Where-Object { $_.status -eq 'PASS' }).Count
$total = $results.Count

Write-Host "`nTest Results: $passed/$total passed" -ForegroundColor $(if($passed -eq $total){'Green'}else{'Yellow'})

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Blue

# Check backend process
Write-Host "Checking backend process..." -ForegroundColor Yellow
try {
    ssh root@$server "pm2 status | grep riskometer || echo 'No PM2 process found'"
    Write-Host ""
} catch {
    Write-Host "Could not check PM2 status`n" -ForegroundColor Red
}

# Test existing applications
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host "Verifying existing applications..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host ""

$existingApps = @(
    @{name='Main Site'; url='http://82.25.105.18/'},
    @{name='Risk-Reward'; url='http://82.25.105.18/risk-reward/'},
    @{name='Sector Heatmap'; url='http://82.25.105.18/sector-heatmap/'},
    @{name='PMS Screener'; url='http://82.25.105.18/pms-screener/'},
    @{name='Investment Calculator'; url='http://82.25.105.18/investment-calculator/'}
)

$allExistingOk = $true

foreach($app in $existingApps) {
    try {
        $response = Invoke-WebRequest -Uri $app.url -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
        Write-Host "✅ $($app.name): Working (HTTP $($response.StatusCode))" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  $($app.name): Issue detected" -ForegroundColor Yellow
        $allExistingOk = $false
    }
}

Write-Host ""

if ($allExistingOk) {
    Write-Host "✅ All existing applications are working!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Some existing applications may have issues" -ForegroundColor Yellow
}

Write-Host "`n=== TEST COMPLETE ===`n" -ForegroundColor Cyan
