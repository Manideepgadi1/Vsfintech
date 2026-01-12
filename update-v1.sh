#!/bin/bash
# Update V1 to multiply by 200
cp /var/www/risk-reward/app.py /var/www/risk-reward/app.py.backup_v1_200
sed -i "s/result\['V1'\] = round(1 - V1_PERCENTILE_MAP\[index_name\], 2)/result['V1'] = round((1 - V1_PERCENTILE_MAP[index_name]) * 200, 2)/" /var/www/risk-reward/app.py
systemctl restart risk-reward
echo "V1 updated to multiply by 200"
