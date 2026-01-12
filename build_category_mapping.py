import json

# Load Right Sector data
with open('current_indices.json', 'r') as f:
    right_sector_data = json.load(f)

# Build comprehensive mappings
fullname_to_category = {}
fullname_to_shortname = {}
shortname_to_fullname = {}
shortname_to_category = {}

for item in right_sector_data:
    full_name = item['fullName']
    short_name = item['displayName']
    category = item['category']
    
    fullname_to_category[full_name] = category
    fullname_to_shortname[full_name] = short_name
    shortname_to_fullname[short_name] = full_name
    shortname_to_category[short_name] = category

# Print statistics
print(f"Total indices: {len(right_sector_data)}")
print(f"\nCategory breakdown:")
categories = {}
for item in right_sector_data:
    cat = item['category']
    categories[cat] = categories.get(cat, 0) + 1

for cat, count in sorted(categories.items()):
    print(f"  {cat}: {count}")

# Save mappings to Python file
with open('category_mappings.py', 'w', encoding='utf-8') as f:
    f.write("# Auto-generated category mappings from Right Sector\n\n")
    
    f.write("FULLNAME_TO_CATEGORY = {\n")
    for full_name, category in sorted(fullname_to_category.items()):
        f.write(f"    {repr(full_name)}: {repr(category)},\n")
    f.write("}\n\n")
    
    f.write("FULLNAME_TO_SHORTNAME = {\n")
    for full_name, short_name in sorted(fullname_to_shortname.items()):
        f.write(f"    {repr(full_name)}: {repr(short_name)},\n")
    f.write("}\n\n")
    
    f.write("SHORTNAME_TO_FULLNAME = {\n")
    for short_name, full_name in sorted(shortname_to_fullname.items()):
        f.write(f"    {repr(short_name)}: {repr(full_name)},\n")
    f.write("}\n\n")
    
    f.write("SHORTNAME_TO_CATEGORY = {\n")
    for short_name, category in sorted(shortname_to_category.items()):
        f.write(f"    {repr(short_name)}: {repr(category)},\n")
    f.write("}\n")

print("\n✓ Mappings saved to category_mappings.py")
