import pandas as pd
import numpy as np
import json
from datetime import datetime, timedelta

# Load the new CSV file
print("Loading CSV file...")
df = pd.read_csv('Latest_Indices_rawdata_31.12.2025.csv')
print(f"Loaded {len(df)} rows, {len(df.columns)} columns")
print(f"Date range: {df.iloc[0,0]} to {df.iloc[-1,0]}")

# Convert date column
df['DATE'] = pd.to_datetime(df['DATE'], format='%d/%m/%Y')
df = df.sort_values('DATE')
df.reset_index(drop=True, inplace=True)

# Load current JSON to get all indices to calculate
with open('current_indices.json', 'r') as f:
    current_data = json.load(f)

print(f"\nTotal indices to calculate: {len(current_data)}")

# Map full names to CSV column names (from previous mapping)
FULL_NAME_TO_CSV = {
    "NIFTY 50": "NIFTY 50",
    "NIFTY NEXT 50": "NIFTY NEXT 50",
    "NIFTY 100": "NIFTY 100",
    "NIFTY 200": "NIFTY 200",
    "Nifty Total Market": "Nifty Total Market",
    "NIFTY 500": "NIFTY 500",
    "NIFTY 500 MULTICAP 50:25:25": "NIFTY500 MULTICAP 50:25:25",
    "NIFTY 500 EQUAL WEIGHT": "NIFTY500 EQUAL WEIGHT",
    "NIFTY MIDCAP 150": "NIFTY MIDCAP 150",
    "NIFTY MIDCAP 150 MOMENTUM 50": "NIFTY MIDCAP 150 MOMENTUM 50",
    "NIFTY MIDCAP 150 QUALITY 50": "NIFTY MIDCAP 150 QUALITY 50",
    "NIFTY MIDSMALLCAP 400": "NIFTY MIDSMALLCAP 400",
    "NIFTY SMALLCAP 250": "NIFTY SMALLCAP 250",
    "NIFTY MICROCAP 250": "NIFTY MICROCAP 250",
    "NIFTY LARGEMIDCAP 250": "NIFTY LARGEMIDCAP 250",
    "Nifty LargeMidCap 250 Quality 50": "Nifty LargeMidCap 250 Quality 50",
    "NIFTY MIDCAP SELECT": "NIFTY MIDCAP SELECT",
    "NIFTY MNC": "NIFTY MNC",
    "NIFTY SMALLCAP 50": "NIFTY SMALLCAP 50",
    "NIFTY SMALLCAP 100": "NIFTY SMALLCAP 100",
    "NIFTY AUTO": "NIFTY AUTO",
    "NIFTY BANK": "NIFTY BANK",
    "Nifty Financial Services 25/50": "Nifty Financial Services 25/50",
    "NIFTY FMCG": "NIFTY FMCG",
    "NIFTY IT": "NIFTY IT",
    "NIFTY MEDIA": "NIFTY MEDIA",
    "NIFTY METAL": "NIFTY METAL",
    "NIFTY PHARMA": "NIFTY PHARMA",
    "Nifty Private Bank": "Nifty Private Bank",
    "Nifty PSU Bank": "Nifty PSU Bank",
    "NIFTY REALTY": "NIFTY REALTY",
    "NIFTY HEALTHCARE INDEX": "NIFTY HEALTHCARE INDEX",
    "Nifty Consumer Durables": "Nifty Consumer Durables",
    "Nifty Oil & Gas": "Nifty Oil & Gas",
    "NIFTY COMMODITIES": "NIFTY COMMODITIES",
    "NIFTY ENERGY": "NIFTY ENERGY",
    "NIFTY INDIA CONSUMPTION": "NIFTY INDIA CONSUMPTION",
    "NIFTY CPSE": "NIFTY CPSE",
    "NIFTY INFRASTRUCTURE": "NIFTY INFRASTRUCTURE",
    "Nifty Services Sector": "Nifty Services Sector",
    "Nifty India Manufacturing": "Nifty India Manufacturing",
    "NIFTY100 ALPHA 30": "NIFTY100 ALPHA 30",
    "NIFTY100 EQUAL WEIGHT": "NIFTY100 EQUAL WEIGHT",
    "NIFTY100 QUALITY 30": "NIFTY100 QUALITY 30",
    "NIFTY200 QUALITY 30": "NIFTY200 QUALITY 30",
    "NIFTY ALPHA 50": "NIFTY ALPHA 50",
    "NIFTY50 EQUAL WEIGHT": "NIFTY50 EQUAL WEIGHT",
    "NIFTY100 LOW VOLATILITY 30": "NIFTY100 LOW VOLATILITY 30",
    "NIFTY ALPHA LOW-VOLATILITY 30": "NIFTY ALPHA LOW-VOLATILITY 30",
    "NIFTY200 ALPHA 30": "NIFTY200 ALPHA 30",
    "NIFTY MIDCAP150 QUALITY 50": "NIFTY MIDCAP150 QUALITY 50",
    "NIFTY200 MOMENTUM 30": "NIFTY200 MOMENTUM 30",
    "NIFTY MIDCAP150 MOMENTUM 50": "NIFTY MIDCAP150 MOMENTUM 50",
    "NIFTY500 MOMENTUM 50": "NIFTY500 MOMENTUM 50",
    "NIFTY MIDSMALL FINANCIAL SERVICES": "NIFTY MIDSMALL FINANCIAL SERVICES",
    "NIFTY MIDSMALL HEALTHCARE": "NIFTY MIDSMALL HEALTHCARE",
    "NIFTY MIDSMALL IT & TELECOM": "NIFTY MIDSMALL IT & TELECOM",
    "Nifty MidSmall India Consumption": "Nifty MidSmall India Consumption",
    "Nifty Total Market": "Nifty Total Market",
    "Nifty Microcap250 Quality 50": "Nifty Microcap250 Quality 50",
    "NIFTY500 VALUE 50": "NIFTY500 VALUE 50",
    "NIFTY MIDCAP150 EQUAL WEIGHT": "NIFTY MIDCAP150 EQUAL WEIGHT",
    "NIFTY SMALLCAP250 EQUAL WEIGHT": "NIFTY SMALLCAP250 EQUAL WEIGHT",
    "Nifty500 Multicap India Manufacturing 50:30:20": "Nifty500 Multicap India Manufacturing 50:30:20",
    "Nifty India Defence": "Nifty India Defence",
    "Nifty500 Multicap Infrastructure 50:30:20": "Nifty500 Multicap Infrastructure 50:30:20",
    "Nifty Housing": "Nifty Housing",
    "Nifty Transportation & Logistics": "Nifty Transportation & Logistics",
    "Nifty MidSmall Healthcare": "Nifty MidSmall Healthcare",
    "NIFTY100 ESG": "NIFTY100 ESG",
    "Nifty100 ESG Sector Leaders": "Nifty100 ESG Sector Leaders",
    "NIFTY MIDCAP50": "NIFTY MIDCAP50",
    "NIFTY MIDCAP100": "NIFTY MIDCAP100",
    "Nifty Midcap50 Equal Weight": "Nifty Midcap50 Equal Weight",
    "Nifty Midcap100 Equal Weight": "Nifty Midcap100 Equal Weight",
    "NIFTY DIVIDEND OPPORTUNITIES 50": "NIFTY DIVIDEND OPPORTUNITIES 50",
    "NIFTY50 VALUE 20": "NIFTY50 VALUE 20",
    "NIFTY GROWTH SECTORS 15": "NIFTY GROWTH SECTORS 15",
    "NIFTY INDIA DIGITAL": "NIFTY INDIA DIGITAL",
    "NIFTY TOP 10 EQUAL WEIGHT": "NIFTY TOP 10 EQUAL WEIGHT",
    "Nifty Non-Cyclical Consumer": "Nifty Non-Cyclical Consumer",
    "Nifty India Tourism": "Nifty India Tourism",
    "Nifty Rural": "Nifty Rural",
    "Nifty REITs & InvITs": "Nifty REITs & InvITs",
    "Nifty Mobility": "Nifty Mobility",
    "Nifty EV & New Age Automotive": "Nifty EV & New Age Automotive",
    "Nifty FMCG 25/50": "Nifty FMCG 25/50",
    "Nifty SME EMERGE": "Nifty SME EMERGE",
    "Nifty Financial Services Ex-Bank": "Nifty Financial Services Ex-Bank",
    "NIFTY PSE": "NIFTY PSE",
    "NIFTY50 SHARIAH": "NIFTY50 SHARIAH",
    "Nifty India Corporate Group Index - Tata Group": "NIFTY INDIA CORPORATE GROUP INDEX - TATA GROUP",
    "Nifty India Corporate Group Index - Mahindra Group": "NIFTY INDIA CORPORATE GROUP INDEX - MAHINDRA GROUP",
    "Nifty India Corporate Group Index - Aditya Birla Group": "NIFTY INDIA CORPORATE GROUP INDEX - ADITYA BIRLA GROUP",
    "Nifty50 Div Point": "NIFTY50 DIV POINT",
    "Nifty Conglomerate": "NIFTY CONGLOMERATE",
    "NIFTY CHEMICALS": "NIFTY CHEMICALS",
    "KOTAK GOLD": "KOTAK GOLD",
    "UTI FLEX": "UTI FLEX",
    "DSP QUANT": "DSP QUANT",
    "HSBC CYCLICAL CONSUMPTION": "HSBC Business Cycles Fund - Regular Growth",
    "UTI ELSS": "DSP ELSS",
    "HDFC INNOVATION": "AXIS INNOVATION",
    "UTI CAPITAL MAATR": "NIFTY INDIA SELECT 5 CORPORATE GROUPS (MAATR)",
    "KOTAK SILVER": "ICICI PRU SILVER",
    "KOTAN CONTRA": "KOTAK CONTRA",
    "EVENNAA": "Nifty EV & New Age Automotive",
    "INTERNATIONAL INDEX": "Nifty India Internet",
    "IPO 50": "NIFTY IPO",
    "Consumer Maatr": "Nifty MidSmall India Consumption",
    "INDIA DEFENCE": "Nifty India Defence",
    "REiT AND INViT": "Nifty REITs & InvITs",
    "R-PSU": "Nifty India Railways PSU",
    "SME EMERGE": "NIFTY SME EMERGE",
    "NIFTY SMALLCAP250 EQUAL WEIGHT": "Nifty Smallcap250 Quality 50",
    "NIFTY MIDCAP150 EQUAL WEIGHT": "Nifty Midcap150 Momentum 50",
    "NIFTY ALPHA LOW-VOLATILITY 30": "NIFTY ALPHA LOW VOLATILITY 30",
    "NIFTY200 MOMENTUM 30": "NIFTY200 MOMENTUM 30",
    "NIFTY500 MOMENTUM 50": "NIFTY500 MOMENTUM 50",
    "NIFTY100 LOW VOLATILITY 30": "NIFTY 100 LOW VOLATILITY 30",
    "NIFTY100 EQUAL WEIGHT": "NIFTY 100 EQUAL WEIGHT",
    "NIFTY100 QUALITY 30": "NIFTY100 QUALITY 30",
    "NIFTY200 QUALITY 30": "NIFTY200 Quality 30",
    "NIFTY50 EQUAL WEIGHT": "NIFTY50 EQUAL WEIGHT",
    "NIFTY500 VALUE 50": "NIFTY500 VALUE 50",
    "NIFTY DIVIDEND OPPORTUNITIES 50": "NIFTY DIVIDEND OPPORTUNITIES 50",
    "NIFTY50 VALUE 20": "NIFTY50 VALUE 20",
    "NIFTY GROWTH SECTORS 15": "NIFTY GROWTH SECTORS 15",
    "NIFTY INDIA DIGITAL": "Nifty India Digital",
    "NIFTY TOP 10 EQUAL WEIGHT": "NIFTY TOP 10 EQUAL WEIGHT",
    "Nifty Non-Cyclical Consumer": "Nifty Non-Cyclical Consumer Index",
    "Nifty India Tourism": "NIFTY INDIA TOURISM",
    "Nifty Rural": "Nifty Rural",
    "Nifty REITs & InvITs": "Nifty REITs & InvITs",
    "Nifty Mobility": "Nifty Mobility",
    "Nifty EV & New Age Automotive": "Nifty EV & New Age Automotive",
    "Nifty FMCG 25/50": "NIFTY FINANCIAL SERVICES 25/50",
    "Nifty SME EMERGE": "NIFTY SME EMERGE",
    "Nifty Financial Services Ex-Bank": "Nifty Financial Services Ex Bank",
    "NIFTY PSE": "NIFTY PSE",
    "NIFTY50 SHARIAH": "NIFTY50 SHARIAH",
    "Nifty Private Bank": "NIFTY PRIVATE BANK",
    "Nifty PSU Bank": "NIFTY PSU BANK",
    "Nifty Oil & Gas": "NIFTY OIL AND GAS INDEX",
    "Nifty Services Sector": "NIFTY SERVICES SECTOR",
    "Nifty India Manufacturing": "Nifty India Manufacturing",
    "NIFTY100 ALPHA 30": "NIFTY100 ALPHA 30",
    "NIFTY ALPHA 50": "NIFTY ALPHA 50",
    "NIFTY200 ALPHA 30": "NIFTY200 ALPHA 30",
    "NIFTY MIDCAP150 QUALITY 50": "Nifty Midcap150 Quality 50",
    "NIFTY MIDCAP150 MOMENTUM 50": "Nifty Midcap150 Momentum 50",
    "NIFTY MIDSMALL FINANCIAL SERVICES": "Nifty MidSmall Financial Services",
    "NIFTY MIDSMALL HEALTHCARE": "Nifty MidSmall Healthcare",
    "NIFTY MIDSMALL IT & TELECOM": "Nifty MidSmall IT & Telecom",
    "Nifty MidSmall India Consumption": "Nifty MidSmall India Consumption",
    "Nifty Microcap250 Quality 50": "Nifty Smallcap250 Quality 50",
    "Nifty500 Multicap India Manufacturing 50:30:20": "NIFTY500 MULTICAP INDIA MANUFATURING 50:30:20",
    "Nifty India Defence": "Nifty India Defence",
    "Nifty500 Multicap Infrastructure 50:30:20": "NIFTY500 MULTICAP INFRASTRUCTURE 50:30:20",
    "Nifty Housing": "Nifty Housing",
    "Nifty Transportation & Logistics": "Nifty Transportation & Logistics",
    "Nifty MidSmall Healthcare": "Nifty MidSmall Healthcare",
    "NIFTY100 ESG": "NIFTY100 ESG",
    "Nifty100 ESG Sector Leaders": "Nifty100 ESG Sector Leaders",
    "NIFTY MIDCAP50": "NIFTY MIDCAP 50",
    "NIFTY MIDCAP100": "Nifty Midcap 100",
    "Nifty Midcap50 Equal Weight": "NIFTY MIDCAP 50",
    "Nifty Midcap100 Equal Weight": "Nifty Midcap 100",
    "NIFTY LARGEMIDCAP 250": "NIFTY LargeMidcap 250",
    "Nifty LargeMidCap 250 Quality 50": "NIFTY200 Quality 30",
    "NIFTY MIDCAP SELECT": "Nifty Midcap Select",
    "NIFTY SMALLCAP 50": "NIFTY SMALLCAP 50",
    "NIFTY SMALLCAP 100": "NIFTY SMALLCAP 100",
    "Nifty Financial Services 25/50": "NIFTY FINANCIAL SERVICES 25/50",
    "NIFTY REALTY": "NIFTY REALTY",
    "NIFTY HEALTHCARE INDEX": "Nifty HEALTHCARE",
    "Nifty Consumer Durables": "NIFTY CONSUMER DURABLES",
    "NIFTY COMMODITIES": "NIFTY COMMODITIES",
    "Nifty CoreHousing": "Nifty Core Housing",
    "NIFTY MICROCAP 250": "NIFTY MICROCAP 250",
    "NIFTY MIDSMALLCAP 400": "NIFTY MIDSMALLCAP 400",
    "NIFTY SMALLCAP 250": "NIFTY SMALLCAP 250",
    "NIFTY 500 MULTICAP MOMENTUM QUALITY 50": "NIFTY500 MULTICAP MOMENTUM QUALITY 50",
    "NIFTY EV & NEW AGE AUTOMOTIVE": "Nifty EV & New Age Automotive",
    "NIFTY IPO": "NIFTY IPO",
    "NIFTY CAPITAL MARKETS": "Nifty Capital Markets",
    "NIFTY REITS & INVITS": "Nifty REITs & InvITs",
    "Nifty Waves": "Nifty Waves",
    "DSP ELSS": "DSP ELSS",
    "NIFTY HighBeta 50": "NIFTY HIGH BETA 50",
    "Nifty200 Value 30": "Nifty200 Value 30",
    "NIFTY INDIA INFRASTRUCTURE & LOGISTICS": "NIFTY INDIA INFRASTRUCTURE & LOGISTICS",
    "NIFTY INDIA NEW AGE CONSUMPTION": "NIFTY INDIA NEW AGE CONSUMPTION",
    "Nifty India Internet": "Nifty India Internet",
    "Nifty India Railways PSU": "Nifty India Railways PSU",
    "NIFTY INFRASTRUCTURE": "NIFTY INFRASTRUCTURE",
    "NIFTY MIDCAP LIQUID 15": "NIFTY MIDCAP LIQUID 15",
    "NIFTY100 LIQUID 15": "NIFTY100 LIQUID 15",
    "NIFTY TOP 15 EQUAL WEIGHT": "NIFTY TOP 15 EQUAL WEIGHT",
    "NIFTY TOP 20 EQUAL WEIGHT": "NIFTY TOP 20 EQUAL WEIGHT",
    "NIFTY QUALITY LOW VOLATILITY 30": "NIFTY QUALITY LOW VOLATILITY 30",
    "NIFTY ALPHA QUALITY LOW VOLATILITY 30": "NIFTY ALPHA QUALITY LOW VOLATILITY 30",
    "NIFTY ALPHA QUALITY VALUE LOW-VOLATILITY 30": "NIFTY ALPHA QUALITY VALUE LOW-VOLATILITY 30",
    "NIFTY500 LOW VOLATILITY 50": "NIFTY500 LOW VOLATILITY 50",
    "NIFTY500 QUALITY 50": "NIFTY500 QUALITY 50",
    "NIFTY500 MULTIFACTOR MQVLv 50": "NIFTY500 MULTIFACTOR MQVLv 50",
    "NIFTY500 SHARIAH": "NIFTY500 SHARIAH",
    "Nifty500 Flexicap Quality 30": "Nifty500 Flexicap Quality 30",
    "NIFTY100 Enhanced ESG": "NIFTY100 Enhanced ESG",
    "Nifty MidSmallcap400 Momentum Quality 100": "Nifty MidSmallcap400 Momentum Quality 100",
    "Nifty Smallcap250 Momentum Quality 100": "Nifty Smallcap250 Momentum Quality 100",
    "NIFTY INDIA CORPORATE GROUP INDEX - TATA GROUP 25% CAP": "NIFTY INDIA CORPORATE GROUP INDEX - TATA GROUP 25% CAP",
    "NIFTY CONGLOMERATE": "NIFTY CONGLOMERATE"
}

def calculate_percentile(series, window_days=1825):
    """Calculate 5-year rolling CAGR percentile"""
    series = series.dropna()
    
    if len(series) < 365:
        return None
    
    # Adaptive window
    actual_window = min(window_days, len(series) - 1)
    if actual_window < 1338:
        actual_window = min(1338, len(series) - 1)
    
    if actual_window < 365:
        return None
    
    # Calculate rolling CAGR
    cagrs = []
    for i in range(actual_window, len(series)):
        current = series.iloc[i]
        past = series.iloc[i - actual_window]
        if past > 0 and current > 0:
            years = actual_window / 365.25
            cagr = (current / past) ** (1 / years) - 1
            cagrs.append(cagr)
    
    if len(cagrs) < 100:
        return None
    
    # Current CAGR
    current_cagr = cagrs[-1]
    
    # Percentile rank
    percentile = sum(1 for c in cagrs if c <= current_cagr) / len(cagrs)
    
    # Average last 30 days
    if len(cagrs) >= 30:
        recent_percentiles = []
        for j in range(30):
            idx = len(cagrs) - 1 - j
            if idx >= 0:
                cagr_at_idx = cagrs[idx]
                pct = sum(1 for c in cagrs[:idx+1] if c <= cagr_at_idx) / (idx + 1)
                recent_percentiles.append(pct)
        percentile = np.mean(recent_percentiles)
    
    return round(percentile, 6)

# Calculate for all indices
results = []
success_count = 0
fail_count = 0

print("\nCalculating percentiles for all 134 indices...\n")

for idx, item in enumerate(current_data, 1):
    full_name = item['fullName']
    display_name = item['displayName']
    category = item['category']
    
    # Try to find matching column
    csv_col = None
    
    # Direct match
    if full_name in FULL_NAME_TO_CSV:
        csv_col = FULL_NAME_TO_CSV[full_name]
    elif full_name in df.columns:
        csv_col = full_name
    else:
        # Fuzzy match
        for col in df.columns:
            if col.lower().replace(' ', '') == full_name.lower().replace(' ', ''):
                csv_col = col
                break
    
    if csv_col and csv_col in df.columns:
        percentile = calculate_percentile(df[csv_col])
        if percentile is not None:
            results.append({
                'fullName': full_name,
                'displayName': display_name,
                'percentile': percentile,
                'category': category
            })
            print(f"{idx:3d}. ✓ {display_name:12} = {percentile:.6f}  ({full_name})")
            success_count += 1
        else:
            # Keep old value if calculation fails
            results.append(item)
            print(f"{idx:3d}. ⚠ {display_name:12} = {item['percentile']:.6f}  (kept old - insufficient data)")
            fail_count += 1
    else:
        # Keep old value if column not found
        results.append(item)
        print(f"{idx:3d}. ⚠ {display_name:12} = {item['percentile']:.6f}  (kept old - column not found)")
        fail_count += 1

print(f"\n{'='*70}")
print(f"SUMMARY:")
print(f"  Successfully calculated: {success_count}")
print(f"  Kept old values: {fail_count}")
print(f"  Total: {len(results)}")

# Save results
output_file = 'indices_with_short_names_NEW.json'
with open(output_file, 'w') as f:
    json.dump(results, f, indent=2)

print(f"\n✓ New JSON saved to: {output_file}")
print(f"✓ Ready to upload to server!")
