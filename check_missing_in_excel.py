import pandas as pd

df = pd.read_excel('d:/VSFintech-Platform/251229_Final_summary.xlsx')

print(f"Total indices in Excel: {len(df)}\n")

# Missing indices
missing = [
    "NIFTY 500 EQUAL WEIGHT", "KOTAK CONTRA", "DSP ELSS", "UTI FLEX", "KOTAK GOLD",
    "HSBC BUSINESS CYCLES", "AXIS INNOVATION", "NIFTY 500 MULTICAP 50:25:25",
    "DSP QUANT", "ICICI PRU SILVER", "NIFTY 500 MULTICAP MOMENTUM QUALITY 50",
    "NIFTY ALPHA QUALITY VALUE LOW-VOLATILITY 30", "NIFTY CAPITAL MARKETS",
    "NIFTY EV & NEW AGE AUTOMOTIVE", "NIFTY INDIA DEFENCE", "NIFTY INDIA INTERNET",
    "NIFTY IPO", "NIFTY REITS & INVITS", "NIFTY INDIA RAILWAYS PSU", "NIFTY SME EMERGE"
]

found = []
for m in missing:
    matches = df[df['SYMBOL'].str.contains(m, case=False, na=False)]
    if len(matches) > 0:
        for _, row in matches.iterrows():
            found.append((m, row['SYMBOL'], row['final_pct_value']))
            print(f"✓ {m}: {row['final_pct_value']:.6f}")
    else:
        print(f"✗ {m}: NOT FOUND")

print(f"\nFound: {len(found)} of {len(missing)}")
