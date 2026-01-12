#!/usr/bin/env python3
"""
Add missing 20 indices to Right Sector JSON
"""
import json

# Missing indices with full names
MISSING_INDICES = [
    # BROAD (10)
    {"shortName": "N500EQ", "fullName": "NIFTY 500 EQUAL WEIGHT", "category": "BROAD", "percentile": 0.5},
    {"shortName": "NCONTRA", "fullName": "KOTAK CONTRA", "category": "BROAD", "percentile": 0.5},
    {"shortName": "NELSS", "fullName": "DSP ELSS", "category": "BROAD", "percentile": 0.5},
    {"shortName": "NFLEXI", "fullName": "UTI FLEX", "category": "BROAD", "percentile": 0.5},
    {"shortName": "NGOLD", "fullName": "KOTAK GOLD", "category": "BROAD", "percentile": 0.5},
    {"shortName": "NHSBCYCLE", "fullName": "HSBC BUSINESS CYCLES FUND - REGULAR GROWTH", "category": "BROAD", "percentile": 0.5},
    {"shortName": "NINNOV", "fullName": "AXIS INNOVATION", "category": "BROAD", "percentile": 0.5},
    {"shortName": "NMC5025", "fullName": "NIFTY 500 MULTICAP 50:25:25", "category": "BROAD", "percentile": 0.5},
    {"shortName": "NQUANT", "fullName": "DSP QUANT", "category": "BROAD", "percentile": 0.5},
    {"shortName": "NSILVER", "fullName": "ICICI PRU SILVER", "category": "BROAD", "percentile": 0.5},
    
    # STRATEGY (2)
    {"shortName": "N5MCMQ5", "fullName": "NIFTY 500 MULTICAP MOMENTUM QUALITY 50", "category": "STRATEGY", "percentile": 0.5},
    {"shortName": "NAQVLV30", "fullName": "NIFTY ALPHA QUALITY VALUE LOW VOLATILITY 30", "category": "STRATEGY", "percentile": 0.5},
    
    # THEMATIC (8)
    {"shortName": "NCM", "fullName": "NIFTY CAPITAL MARKETS", "category": "THEMATIC", "percentile": 0.5},
    {"shortName": "NEVNAA", "fullName": "NIFTY EV & NEW AGE AUTOMOTIVE", "category": "THEMATIC", "percentile": 0.5},
    {"shortName": "NIDEF", "fullName": "NIFTY INDIA DEFENCE", "category": "THEMATIC", "percentile": 0.5},
    {"shortName": "NIINT", "fullName": "NIFTY INDIA INTERNET", "category": "THEMATIC", "percentile": 0.5},
    {"shortName": "NIPO", "fullName": "NIFTY IPO", "category": "THEMATIC", "percentile": 0.5},
    {"shortName": "NREiT", "fullName": "NIFTY REITS & INVITS", "category": "THEMATIC", "percentile": 0.5},
    {"shortName": "NRPSU", "fullName": "NIFTY INDIA RAILWAYS PSU", "category": "THEMATIC", "percentile": 0.5},
    {"shortName": "NSMEE", "fullName": "NIFTY SME EMERGE", "category": "THEMATIC", "percentile": 0.5},
]

# Read current JSON
with open('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json', 'r') as f:
    current_data = json.load(f)

print(f"Current: {len(current_data)} indices")

# Add missing indices
for missing in MISSING_INDICES:
    new_entry = {
        "fullName": missing["fullName"],
        "displayName": missing["shortName"],
        "percentile": missing["percentile"],
        "category": missing["category"]
    }
    current_data.append(new_entry)

# Sort by percentile
current_data.sort(key=lambda x: x['percentile'])

# Save
import shutil
shutil.copy('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json',
            '/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json.backup_before_add')

with open('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json', 'w') as f:
    json.dump(current_data, f, indent=2)

print(f"After: {len(current_data)} indices")
print(f"Added: {len(MISSING_INDICES)} indices")
print("\nNote: All new indices have percentile=0.5 (placeholder)")
print("You need to update with actual percentile values!")
