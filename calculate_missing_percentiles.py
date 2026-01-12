import pandas as pd
import numpy as np

# Column names for the 20 missing indices
MISSING_COLUMNS = [
    "NIFTY500 EQUAL WEIGHT",
    "KOTAK CONTRA",
    "DSP ELSS",
    "UTI FLEX",
    "KOTAK GOLD",
    "HSBC Business Cycles Fund - Regular Growth",
    "AXIS INNOVATION",
    "NIFTY500 MULTICAP 50:25:25",
    "DSP QUANT",
    "ICICI PRU SILVER",
    "NIFTY500 MULTICAP MOMENTUM QUALITY 50",
    "NIFTY ALPHA QUALITY VALUE LOW-VOLATILITY 30",
    "Nifty Capital Markets",
    "Nifty EV & New Age Automotive",
    "Nifty India Defence",
    "Nifty India Internet",
    "NIFTY IPO",
    "Nifty REITs & InvITs",
    "Nifty India Railways PSU",
    "NIFTY SME EMERGE"
]

# Short names mapping
SHORT_NAMES = {
    "NIFTY500 EQUAL WEIGHT": "N500EQWT",
    "KOTAK CONTRA": "NCONTRA",
    "DSP ELSS": "NELSS",
    "UTI FLEX": "NFLEXI",
    "KOTAK GOLD": "NGOLD",
    "HSBC Business Cycles Fund - Regular Growth": "NHSBCYCLE",
    "AXIS INNOVATION": "NINNOV",
    "NIFTY500 MULTICAP 50:25:25": "NMC5025",
    "DSP QUANT": "NQUANT",
    "ICICI PRU SILVER": "NSILVER",
    "NIFTY500 MULTICAP MOMENTUM QUALITY 50": "N5MCMQ5",
    "NIFTY ALPHA QUALITY VALUE LOW-VOLATILITY 30": "NAQVLV30",
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
df = pd.read_csv('d:/VSFintech-Platform/Latest_Indices_rawdata_14112025.csv')
df['DATE'] = pd.to_datetime(df['DATE'])
df = df.sort_values('DATE')

print(f"Data loaded: {len(df)} rows from {df['DATE'].min()} to {df['DATE'].max()}")

# Calculate percentiles for each missing index
results = []

for col in MISSING_COLUMNS:
    if col not in df.columns:
        print(f"✗ {col}: Column not found in CSV")
        continue
    
    # Remove rows with NaN values for this column
    data = df[['DATE', col]].dropna()
    
    if len(data) < 1825:  # Need at least 5 years of data
        print(f"✗ {col}: Not enough data ({len(data)} days)")
        continue
    
    # Calculate 5-year rolling CAGR
    window = 1825  # 5 years
    data['rolling_cagr'] = (data[col] / data[col].shift(window)) ** (1/5) - 1
    
    # Calculate percentile rank (compare current CAGR to 5-year history)
    data['percentile'] = data['rolling_cagr'].rolling(window).apply(
        lambda x: pd.Series(x).rank(pct=True).iloc[-1] if len(x) > 0 else np.nan
    )
    
    # Get most recent month
    latest_date = data['DATE'].max()
    one_month_ago = latest_date - pd.Timedelta(days=30)
    recent_data = data[data['DATE'] >= one_month_ago]
    
    # Average percentile for the month
    avg_percentile = recent_data['percentile'].mean()
    
    if pd.notna(avg_percentile):
        results.append({
            'short': SHORT_NAMES[col],
            'full': col,
            'percentile': round(avg_percentile, 6)
        })
        print(f"✓ {SHORT_NAMES[col]:12} ({col[:40]}...): {avg_percentile:.6f}")
    else:
        print(f"✗ {col}: Could not calculate percentile")

print(f"\n{'='*80}")
print(f"Successfully calculated: {len(results)} of {len(MISSING_COLUMNS)}")
print(f"{'='*80}\n")

# Output results
print("\nResults for updating JSON:")
for r in results:
    print(f'  "{r["short"]}": {r["percentile"]},')
