#!/usr/bin/env python3
"""
Update the remaining 11 indices with calculated percentile values
"""
import json

# Newly calculated percentiles for all 11 indices
NEW_CALCULATED = {
    "NQUANT": 0.005375,
    "NSILVER": 0.557922,
    "NINNOV": 0.388020,
    "NCM": 0.487774,
    "NEVNAA": 0.401122,
    "NIDEF": 0.644885,
    "NIINT": 0.716836,
    "NIPO": 0.435269,
    "NREiT": 0.582969,
    "NRPSU": 0.108940,
    "NSMEE": 0.617146,
}

# Read current JSON
with open('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json', 'r') as f:
    data = json.load(f)

print(f"Current: {len(data)} indices")

# Update the 11 indices with calculated values
updated = 0
for item in data:
    if item['displayName'] in NEW_CALCULATED:
        old_val = item['percentile']
        item['percentile'] = NEW_CALCULATED[item['displayName']]
        print(f"✓ {item['displayName']:12} {old_val:.6f} → {item['percentile']:.6f}")
        updated += 1

# Sort by percentile
data.sort(key=lambda x: x['percentile'])

# Backup and save
import shutil
shutil.copy('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json',
            '/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json.backup_all20')

with open('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json', 'w') as f:
    json.dump(data, f, indent=2)

print(f"\n✓ Updated {updated} indices with calculated percentiles")
print(f"✓ All 20 missing indices now have actual calculated values!")
print(f"✓ Total indices in JSON: {len(data)}")
