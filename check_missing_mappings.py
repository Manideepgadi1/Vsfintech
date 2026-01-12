import pandas as pd
import json

# Load CSV and current JSON
df = pd.read_csv('Latest_Indices_rawdata_31.12.2025.csv')
with open('current_indices.json', 'r') as f:
    current_data = json.load(f)

# Get all column names (excluding DATE)
csv_columns = set(df.columns[1:])

print("Checking which indices still need column mapping:\n")

missing = []
for item in current_data:
    full_name = item['fullName']
    display_name = item['displayName']
    
    # Check if we can find it
    found = False
    for col in csv_columns:
        if col.lower() == full_name.lower() or col.lower().replace(' ', '') == full_name.lower().replace(' ', ''):
            found = True
            break
    
    if not found:
        missing.append((display_name, full_name))
        # Try fuzzy search
        matches = []
        for col in csv_columns:
            if any(word.lower() in col.lower() for word in full_name.split() if len(word) > 3):
                matches.append(col)
        
        print(f"{display_name:15} | {full_name:50} | Possible: {', '.join(matches[:3]) if matches else 'NONE'}")

print(f"\nTotal missing mappings: {len(missing)}")
