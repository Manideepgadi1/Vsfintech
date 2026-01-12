import pandas as pd
import numpy as np
import warnings
warnings.filterwarnings('ignore')

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
df = df.sort_values('DATE').reset_index(drop=True)

print(f"Data loaded: {len(df)} rows\n")

results = []

for full_name, short_name in REMAINING_11.items():
    print(f"Processing {short_name:10} ({full_name})...")
    
    # Get column data
    data = df[['DATE', full_name]].copy()
    data = data[data[full_name].notna()].reset_index(drop=True)
    
    if len(data) < 500:  # Minimum data requirement
        print(f"  ✗ Not enough data: {len(data)} rows\n")
        continue
    
    # Use adaptive window based on available data
    max_window = min(1825, len(data) - 100)  # 5 years or less if not available
    
    if max_window < 365:  # Need at least 1 year
        print(f"  ✗ Window too small: {max_window} days\n")
        continue
    
    try:
        # Calculate rolling CAGR
        years = max_window / 365.25
        data['rolling_cagr'] = ((data[full_name] / data[full_name].shift(max_window)) ** (1/years)) - 1
        
        # Remove NaN from CAGR calculation
        data = data.dropna(subset=['rolling_cagr'])
        
        if len(data) < 100:
            print(f"  ✗ Not enough CAGR values\n")
            continue
        
        # Calculate percentile rank
        # For each point, rank it against the previous max_window points
        percentiles = []
        for i in range(len(data)):
            start_idx = max(0, i - max_window)
            window_cagr = data['rolling_cagr'].iloc[start_idx:i+1]
            if len(window_cagr) > 10:  # Need reasonable sample
                percentile = (window_cagr < data['rolling_cagr'].iloc[i]).sum() / len(window_cagr)
                percentiles.append(percentile)
            else:
                percentiles.append(np.nan)
        
        data['percentile'] = percentiles
        
        # Get most recent month average
        latest_date = data['DATE'].max()
        one_month_ago = latest_date - pd.Timedelta(days=30)
        recent_data = data[data['DATE'] >= one_month_ago]
        
        if len(recent_data) == 0:
            recent_data = data.tail(20)  # Use last 20 days
        
        avg_percentile = recent_data['percentile'].mean()
        
        if pd.notna(avg_percentile) and 0 <= avg_percentile <= 1:
            results.append({
                'short': short_name,
                'full': full_name,
                'percentile': round(avg_percentile, 6),
                'window_days': max_window,
                'data_points': len(data)
            })
            print(f"  ✓ Percentile: {avg_percentile:.6f} (using {max_window} day window)\n")
        else:
            print(f"  ✗ Invalid percentile: {avg_percentile}\n")
            
    except Exception as e:
        print(f"  ✗ Error: {str(e)}\n")
        continue

print(f"{'='*80}")
print(f"Successfully calculated: {len(results)} of 11")
print(f"{'='*80}\n")

if results:
    print("Results for updating JSON:")
    for r in results:
        print(f'  "{r["short"]}": {r["percentile"]},  # {r["full"]} ({r["data_points"]} points, {r["window_days"]} day window)')
