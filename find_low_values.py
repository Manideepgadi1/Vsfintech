import json

# Load the JSON data
with open('current_indices.json', 'r') as f:
    data = json.load(f)

# Find indices with percentile < 0.1
low = [d for d in data if d['percentile'] < 0.1]
low.sort(key=lambda x: x['percentile'])

print(f"Indices with percentile < 0.1 (very low): {len(low)} total\n")
print(f"{'SHORT NAME':<15} {'VALUE':<10} {'FULL NAME'}")
print("=" * 70)

for d in low:
    print(f"{d['displayName']:<15} {d['percentile']:<10.6f} {d['fullName']}")
