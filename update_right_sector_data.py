#!/usr/bin/env python3
"""
Update Right Sector JSON with SHORT names and correct categories
"""

import json
import csv

# Category mappings from Excel
MAPPINGS = {
    "BROAD": {
        "N50": "NIFTY 50", "NN50": "NIFTY NEXT 50", "N100": "NIFTY 100", "N200": "NIFTY 200",
        "NTOTLM": "Nifty Total Market", "N500": "NIFTY 500", "NMC5025": "NIFTY500 MULTICAP 50:25:25",
        "N500EQ": "NIFTY500 EQUAL WEIGHT", "NMC150": "NIFTY MIDCAP 150", "NMC50": "NIFTY MIDCAP 50",
        "NMIDSEL": "Nifty Midcap Select", "NMC100": "NIFTY Midcap 100", "NSC250": "NIFTY SMALLCAP 250",
        "NSC50": "NIFTY SMALLCAP 50", "NSC100": "NIFTY SMALLCAP 100", "NMICRO": "NIFTY MICROCAP 250",
        "NLMC250": "NIFTY LargeMidcap 250", "NMSC400": "NIFTY MIDSMALLCAP 400", "NQUANT": "DSP QUANT",
        "NELSS": "DSP ELSS", "NSILVER": "ICICI PRU SILVER", "NHSBCYCLE": "HSBC Business Cycles Fund - Regular Growth",
        "NCONTRA": "KOTAK CONTRA", "NGOLD": "KOTAK GOLD", "NFLEXI": "UTI FLEX", "NINNOV": "AXIS INNOVATION"
    },
    "SECTOR": {
        "NAUTO": "NIFTY AUTO", "NBANK": "NIFTY BANK", "NCHEM": "NIFTY CHEMICALS",
        "NFINSERV": "NIFTY FINANCIAL SERVICES", "NFINS25": "NIFTY FINANCIAL SERVICES 25/50",
        "NFINSEXB": "Nifty Financial Services Ex Bank", "NFMCG": "NIFTY FMCG", "NHEALTH": "Nifty HEALTHCARE",
        "NTECH": "NIFTY IT", "NMEDIA": "NIFTY MEDIA", "NMETAL": "NIFTY METAL", "NPHARMA": "NIFTY PHARMA",
        "NPVTBANK": "NIFTY PRIVATE BANK", "NPSUBANK": "NIFTY PSU BANK", "NREALTY": "NIFTY REALTY",
        "NCONDUR": "NIFTY CONSUMER DURABLES", "NOILGAS": "NIFTY OIL AND GAS INDEX",
        "NMSFINS": "Nifty MidSmall Financial Services", "NMSHC": "Nifty MidSmall Healthcare",
        "NMSITT": "Nifty MidSmall IT & Telecom"
    },
    "STRATEGY": {
        "N100EQWT": "NIFTY 100 EQUAL WEIGHT", "N100LV30": "NIFTY 100 LOW VOLATILITY 30",
        "N5ARB": "NIFTY 10 YR BENCHMARK G-SEC", "N200M30": "NIFTY200 MOMENTUM 30",
        "N200AL30": "NIFTY200 ALPHA 30", "N100AL30": "NIFTY100 ALPHA 30", "NAL50": "NIFTY ALPHA 50",
        "NALV30": "NIFTY ALPHA LOW VOLATILITY 30", "NAQLV30": "NIFTY ALPHA QUALITY LOW VOLATILITY 30",
        "NAQVLV30": "NIFTY ALPHA QUALITY VALUE LOW-VOLATILITY 30", "NDIVOP50": "NIFTY DIVIDEND OPPORTUNITIES 50",
        "NGROW15": "NIFTY GROWTH SECTORS 15", "NHBETA50": "NIFTY HIGH BETA 50", "NLV50": "NIFTY LOW VOLATILITY 50",
        "NT10EQWT": "NIFTY TOP 10 EQUAL WEIGHT", "NT15EW": "NIFTY TOP 15 EQUAL WEIGHT",
        "NT20EW": "NIFTY TOP 20 EQUAL WEIGHT", "N100QLT30": "NIFTY100 QUALITY 30",
        "NM150M50": "NIFTY Midcap150 Momentum 50", "N5FCQ3": "Nifty500 Flexicap Quality 30",
        "N5LV5": "NIFTY500 LOW VOLATILITY 50", "N500M50": "NIFTY500 MOMENTUM 50",
        "N500QLT50": "NIFTY500 QUALITY 50", "NMQLV": "NIFTY500 MULTIFACTOR MQVLv 50",
        "NMC150Q": "NIFTY Midcap150 Quality 50", "NSC250Q": "Nifty Smallcap250 Quality 50",
        "N5MCMQ5": "NIFTY500 MULTICAP MOMENTUM QUALITY 50", "NMSCMQ": "Nifty MidSmallcap400 Momentum Quality 100",
        "NSC250MQ": "Nifty Smallcap250 Momentum Quality 100", "NQLV30": "NIFTY QUALITY LOW VOLATILITY 30",
        "N50EQWGT": "NIFTY50 EQUAL WEIGHT", "N50V20": "NIFTY50 VALUE 20", "N200V30": "Nifty200 Value 30",
        "N500V50": "NIFTY500 VALUE 50", "N500EQWT": "NIFTY500 EQUAL WEIGHT", "N200Q30": "NIFTY200 Quality 30"
    },
    "THEMATIC": {
        "NBIRLA": "NIFTY INDIA CORPORATE GROUP INDEX - ADITYA BIRLA GROUP", "NCM": "Nifty Capital Markets",
        "NCOMM": "NIFTY COMMODITIES", "NCHOUS": "Nifty Core Housing", "NCPSE": "NIFTY CPSE",
        "NENERGY": "NIFTY ENERGY", "NEVNAA": "Nifty EV & New Age Automotive", "NHOUSING": "Nifty Housing",
        "N100ESG": "NIFTY100 ESG", "N100ESGE": "NIFTY100 Enhanced ESG", "N100ESGSL": "Nifty100 ESG Sector Leaders",
        "NICON": "NIFTY INDIA CONSUMPTION", "NIDEF": "Nifty India Defence", "NIDIGI": "Nifty India Digital",
        "NIFSL": "NIFTY INDIA INFRASTRUCTURE & LOGISTICS", "NIINT": "Nifty India Internet",
        "NIMFG": "Nifty India Manufacturing", "NTOUR": "NIFTY INDIA TOURISM", "NINFRA": "NIFTY INFRASTRUCTURE",
        "NMAHIN": "NIFTY INDIA CORPORATE GROUP INDEX - MAHINDRA GROUP", "NIPO": "NIFTY IPO",
        "NMIDLIQ15": "NIFTY MIDCAP LIQUID 15", "NMSICON": "Nifty MidSmall India Consumption",
        "NMNC": "NIFTY MNC", "NMOBIL": "Nifty Mobility", "NPSE": "NIFTY PSE", "NREiT": "Nifty REITs & InvITs",
        "NRRL": "Nifty Rural", "NNCCON": "Nifty Non-Cyclical Consumer Index", "NSERVSEC": "NIFTY SERVICES SECTOR",
        "NSH25": "NIFTY SHARIAH 25", "NTATA": "NIFTY INDIA CORPORATE GROUP INDEX - TATA GROUP",
        "NTATA25C": "NIFTY INDIA CORPORATE GROUP INDEX - TATA GROUP 25% CAP", "NTRANS": "Nifty Transportation & Logistics",
        "NLCLIQ15": "NIFTY100 LIQUID 15", "N50SH": "NIFTY50 SHARIAH", "N500SH": "NIFTY500 SHARIAH",
        "NMFG532": "NIFTY500 MULTICAP INDIA MANUFATURING 50:30:20", "NINFRA532": "NIFTY500 MULTICAP INFRASTRUCTURE 50:30:20",
        "NSMEE": "NIFTY SME EMERGE", "NRPSU": "Nifty India Railways PSU",
        "NMAATR": "NIFTY INDIA SELECT 5 CORPORATE GROUPS (MAATR)", "NNACON": "NIFTY INDIA NEW AGE CONSUMPTION",
        "NWVS": "Nifty Waves"
    }
}

# Create reverse lookup: full name -> (short name, category)
REVERSE_LOOKUP = {}
for category, indices in MAPPINGS.items():
    for short, full in indices.items():
        # Normalize for matching
        full_normalized = full.upper().strip().replace('-', ' ')
        REVERSE_LOOKUP[full_normalized] = (short, category)

# Additional fuzzy mappings
FUZZY_MAP = {
    "NIFTY TOP 10 EW": "NT10EQWT",
    "NIFTY CONSR DURBL": "NCONDUR",
    "NIFTY500 FLEXICAP": "N5FCQ3",
    "NIFTY CORP MAATR": "NMAATR",
    "NIFTY M150 QLTY50": "NMC150Q",
    "NIFTY100ESGSECLDR": "N100ESGSL",
    "NIFTY SERV SECTOR": "NSERVSEC",
    "NIFTY MS IT TELCM": "NMSITT"
}

# Read current JSON
with open('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json', 'r') as f:
    current_data = json.load(f)

# Update with short names and correct categories
updated_data = []
matched = 0
unmatched = []

for item in current_data:
    full_name = item['fullName']
    full_normalized = full_name.upper().strip().replace('-', ' ')
    
    # Try direct match first
    if full_normalized in REVERSE_LOOKUP:
        short, category = REVERSE_LOOKUP[full_normalized]
    # Try fuzzy map
    elif full_normalized in FUZZY_MAP:
        short = FUZZY_MAP[full_normalized]
        # Find category from short name
        category = None
        for cat, indices in MAPPINGS.items():
            if short in indices:
                category = cat
                break
        if not category:
            category = "Thematic"  # default
    else:
        # Keep original if no match
        unmatched.append(full_name)
        updated_data.append(item)
        continue
    
    # Map category to display format
    if category == "BROAD":
        cat_display = "Broad Market"
    elif category == "SECTOR":
        cat_display = "Sectoral"
    elif category == "STRATEGY":
        cat_display = "Strategy"
    else:
        cat_display = "Thematic"
    
    updated_data.append({
        "fullName": full_name,
        "displayName": short,  # SHORT NAME
        "percentile": item['percentile'],
        "category": cat_display
    })
    matched += 1

# Save updated JSON
with open('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json', 'w') as f:
    json.dump(updated_data, f, indent=2)

print(f"✓ Updated {matched} indices with short names")
if unmatched:
    print(f"⚠ {len(unmatched)} indices not matched:")
    for name in unmatched[:10]:
        print(f"  - {name}")

print(f"✓ Total indices in file: {len(updated_data)}")
