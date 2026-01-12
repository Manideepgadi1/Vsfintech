#!/usr/bin/env python3
"""
Update the 20 missing indices with actual calculated percentile values
"""
import json

# Calculated percentiles for 9 indices
CALCULATED_VALUES = {
    "N500EQWT": 0.638524,
    "NCONTRA": 0.923615,
    "NELSS": 0.678294,
    "NFLEXI": 0.044817,
    "NGOLD": 0.998498,
    "NHSBCYCLE": 0.759806,
    "NMC5025": 0.633345,
    "N5MCMQ5": 0.390641,
    "NAQVLV30": 0.615899,
}

# Read current JSON
with open('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json', 'r') as f:
    data = json.load(f)

print(f"Current: {len(data)} indices")

# Update the 9 indices with calculated values
updated = 0
for item in data:
    if item['displayName'] in CALCULATED_VALUES:
        old_val = item['percentile']
        item['percentile'] = CALCULATED_VALUES[item['displayName']]
        print(f"✓ {item['displayName']:12} {old_val:.6f} → {item['percentile']:.6f}")
        updated += 1

# Sort by percentile
data.sort(key=lambda x: x['percentile'])

# Backup and save
import shutil
shutil.copy('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json',
            '/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json.backup_before_calc')

with open('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json', 'w') as f:
    json.dump(data, f, indent=2)

print(f"\n✓ Updated {updated} indices with calculated percentiles")
print(f"✓ Remaining 11 indices still have placeholder (0.5) - not enough data")
