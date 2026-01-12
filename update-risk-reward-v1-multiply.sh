#!/bin/bash

# Update Risk-Reward V1 to multiply by 200
# Usage: bash update-risk-reward-v1-multiply.sh

set -e

APP_FILE="/var/www/risk-reward/app.py"
BACKUP_FILE="/var/www/risk-reward/app.py.backup_v1_multiply_$(date +%Y%m%d_%H%M%S)"

echo "==========================================="
echo " Risk-Reward V1 Update: Multiply by 200"
echo "==========================================="
echo ""

# Create backup
echo "[1/4] Creating backup..."
cp $APP_FILE $BACKUP_FILE
echo "✓ Backup: $BACKUP_FILE"

# Update V1 calculation
echo "[2/4] Updating V1 calculation..."
sed -i "s/result\['V1'\] = round(1 - V1_PERCENTILE_MAP\[index_name\], 2)/result['V1'] = round((1 - V1_PERCENTILE_MAP[index_name]) * 200, 2)/" $APP_FILE

if grep -q "result\['V1'\] = round((1 - V1_PERCENTILE_MAP\[index_name\]) \* 200, 2)" $APP_FILE; then
    echo "✓ V1 calculation updated to multiply by 200"
else
    echo "✗ Update failed, restoring backup..."
    cp $BACKUP_FILE $APP_FILE
    exit 1
fi

# Restart service
echo "[3/4] Restarting risk-reward service..."
systemctl restart risk-reward
sleep 2

if systemctl is-active --quiet risk-reward; then
    echo "✓ Service restarted successfully"
else
    echo "✗ Service failed, restoring backup..."
    cp $BACKUP_FILE $APP_FILE
    systemctl restart risk-reward
    exit 1
fi

# Test API
echo "[4/4] Testing API..."
RESPONSE=$(curl -s http://localhost:8003/api/risk-return | head -c 200)
if [ ! -z "$RESPONSE" ]; then
    echo "✓ API responding"
    echo "Sample response: $RESPONSE"
else
    echo "✗ API not responding"
    exit 1
fi

echo ""
echo "==========================================="
echo "✓ V1 Update Complete!"
echo "==========================================="
echo ""
echo "V1 formula: (1 - v1) * 200"
echo "Test: http://82.25.105.18:8003/api/risk-return"
echo ""
