import pandas as pd
import numpy as np

# The 11 remaining indices
REMAINING_11 = {
    "DSP QUANT": "NQUANT",
    "ICICI PRU SILVER": "NSILVER", 
    "AXIS INNOVATION": "NINNOV",
    "Nifty Capital Markets": "NCM",
    "Nifty EV & New Age Automotive": "NEVNAA",
    "Nifty India Defence": "NIDEF",
    "Nifty India Internet": "NIINT",
    "NIFTY IPO": "NIPO",
    "Nifty REITs & InvITs": "NREiT",
    "Nifty India Railways PSU": "NRPSU",
    "NIFTY SME EMERGE": "NSMEE"
}

print("Loading CSV data...")
df = pd.read_csv('d:/VSFintech-Platform/Latest_Indices_rawdata_14112025.csv', dayfirst=True)
df['DATE'] = pd.to_datetime(df['DATE'], dayfirst=True)
df = df.sort_values('DATE')

print(f"Data loaded: {len(df)} rows from {df['DATE'].min()} to {df['DATE'].max()}")
print(f"\nAll columns in CSV: {len(df.columns)}")

# Check each column carefully
for full_name, short_name in REMAINING_11.items():
    print(f"\n{'='*80}")
    print(f"Checking: {short_name} ({full_name})")
    print(f"{'='*80}")
    
    # Check if column exists
    if full_name not in df.columns:
        # Try to find similar column names
        similar = [col for col in df.columns if full_name.upper() in col.upper() or col.upper() in full_name.upper()]
        print(f"❌ Column '{full_name}' not found")
        if similar:
            print(f"   Similar columns: {similar}")
        else:
            print(f"   No similar columns found")
        continue
    
    # Check data availability
    col_data = df[['DATE', full_name]].copy()
    total_rows = len(col_data)
    non_null = col_data[full_name].notna().sum()
    null_rows = total_rows - non_null
    
    print(f"✓ Column found")
    print(f"  Total rows: {total_rows}")
    print(f"  Non-null values: {non_null}")
    print(f"  Null values: {null_rows}")
    
    if non_null == 0:
        print(f"  ❌ No data available (all null)")
        continue
    
    # Get date range of non-null data
    non_null_data = col_data[col_data[full_name].notna()]
    first_date = non_null_data['DATE'].min()
    last_date = non_null_data['DATE'].max()
    days_span = (last_date - first_date).days
    
    print(f"  First value: {first_date.strftime('%Y-%m-%d')}")
    print(f"  Last value: {last_date.strftime('%Y-%m-%d')}")
    print(f"  Date span: {days_span} days ({days_span/365:.1f} years)")
    
    # Check if we have enough for 5-year calculation
    if days_span < 1825:
        print(f"  ⚠️  Not enough data for 5-year calculation (need 1825 days)")
        print(f"  💡 Can use shorter window: {days_span} days available")
    else:
        print(f"  ✓ Enough data for 5-year calculation")
    
    # Sample some values
    sample = non_null_data.tail(5)
    print(f"  Recent values:")
    for _, row in sample.iterrows():
        print(f"    {row['DATE'].strftime('%Y-%m-%d')}: {row[full_name]:.2f}")

print(f"\n{'='*80}")
print("Summary: Checking all 11 indices for data availability")
print(f"{'='*80}")
