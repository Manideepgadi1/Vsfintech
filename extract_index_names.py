#!/usr/bin/env python3
"""
Extract index mappings from Excel and generate Python/JavaScript configs
"""
import pandas as pd
import json

# Read Excel file
df = pd.read_excel('SHORT AND FULL NAMES.xlsx')

# Extract each category
categories = {
    'Broad': {
        'short_col': 'Broad ↕',
        'full_col': 'Full Names',
        'data': {}
    },
    'Sector': {
        'short_col': 'Sector ↕',
        'full_col': 'Full Names.1',
        'data': {}
    },
    'Strategy': {
        'short_col': 'Strategy ↕',
        'full_col': 'Full Names.2',
        'data': {}
    },
    'Thematic': {
        'short_col': 'Thematic ↕',
        'full_col': 'Full Names.3',
        'data': {}
    }
}

# Extract data for each category
for cat_name, cat_info in categories.items():
    short_col = cat_info['short_col']
    full_col = cat_info['full_col']
    
    # Get rows where both columns have values
    mask = df[short_col].notna() & df[full_col].notna()
    data = df.loc[mask, [short_col, full_col]]
    
    # Create mapping dict
    for _, row in data.iterrows():
        short = str(row[short_col]).strip()
        full = str(row[full_col]).strip()
        cat_info['data'][short] = full

print("=" * 80)
print("INDEX NAME MAPPINGS FROM EXCEL")
print("=" * 80)

for cat_name, cat_info in categories.items():
    print(f"\n{cat_name.upper()} INDICES ({len(cat_info['data'])} indices)")
    print("-" * 80)
    for short, full in sorted(cat_info['data'].items()):
        print(f"  {short:15} -> {full}")

# Generate Python dictionary format for Risk-Reward
print("\n\n" + "=" * 80)
print("PYTHON DICT FOR RISK-REWARD (app.py)")
print("=" * 80)

# Combine all categories for risk-reward
all_indices = {}
for cat_name, cat_info in categories.items():
    all_indices.update(cat_info['data'])

print("\nINDEX_NAMES = {")
for short, full in sorted(all_indices.items()):
    print(f'    "{short}": "{full}",')
print("}")

# Generate JavaScript/CSV format for Right Sector
print("\n\n" + "=" * 80)
print("CSV DATA FOR RIGHT SECTOR")
print("=" * 80)
print("\nBroad,Sector,Strategy,Thematic")

max_len = max(len(cat_info['data']) for cat_info in categories.values())
for i in range(max_len):
    row_data = []
    for cat_name in ['Broad', 'Sector', 'Strategy', 'Thematic']:
        items = list(categories[cat_name]['data'].items())
        if i < len(items):
            short, full = items[i]
            row_data.append(f'{short}|{full}')
        else:
            row_data.append('')
    print(','.join(row_data))

# Save to JSON for programmatic use
output = {
    'categories': {
        cat_name: {
            'indices': cat_info['data'],
            'count': len(cat_info['data'])
        }
        for cat_name, cat_info in categories.items()
    },
    'all_indices': all_indices,
    'total_count': len(all_indices)
}

with open('index_mappings.json', 'w', encoding='utf-8') as f:
    json.dump(output, f, indent=2, ensure_ascii=False)

print("\n\n✓ Saved to index_mappings.json")
print(f"✓ Total indices: {len(all_indices)}")
print(f"  - Broad: {len(categories['Broad']['data'])}")
print(f"  - Sector: {len(categories['Sector']['data'])}")
print(f"  - Strategy: {len(categories['Strategy']['data'])}")
print(f"  - Thematic: {len(categories['Thematic']['data'])}")
