#!/usr/bin/env python3
"""
Complete Right Sector fix with ALL 126 indices from user's list
"""

import json

# EXACT mappings from user - ALL 126 INDICES
MAPPINGS = {
    "BROAD": {
        "N50": "NIFTY 50", "NN50": "NIFTY NEXT 50", "N100": "NIFTY 100", "N200": "NIFTY 200",
        "NTOTLM": "NIFTY TOTAL MARKET", "N500": "NIFTY 500", "NMC5025": "NIFTY 500 MULTICAP 50:25:25",
        "N500EQ": "NIFTY 500 EQUAL WEIGHT", "NMC150": "NIFTY MIDCAP 150", "NMC50": "NIFTY MIDCAP 50",
        "NMIDSEL": "NIFTY MIDCAP SELECT", "NMC100": "NIFTY MIDCAP 100", "NSC250": "NIFTY SMALLCAP 250",
        "NSC50": "NIFTY SMALLCAP 50", "NSC100": "NIFTY SMALLCAP 100", "NMICRO": "NIFTY MICROCAP 250",
        "NLMC250": "NIFTY LARGEMIDCAP 250", "NMSC400": "NIFTY MIDSMALLCAP 400", "NQUANT": "DSP QUANT",
        "NELSS": "DSP ELSS", "NSILVER": "ICICI PRU SILVER", 
        "NHSBCYCLE": "HSBC BUSINESS CYCLES FUND - REGULAR GROWTH",
        "NCONTRA": "KOTAK CONTRA", "NGOLD": "KOTAK GOLD", "NFLEXI": "UTI FLEX", "NINNOV": "AXIS INNOVATION"
    },
    "SECTOR": {
        "NAUTO": "NIFTY AUTO", "NBANK": "NIFTY BANK", "NCHEM": "NIFTY CHEMICALS",
        "NFINSERV": "NIFTY FINANCIAL SERVICES", "NFINS25": "NIFTY FINANCIAL SERVICES 25/50",
        "NFINSEXB": "NIFTY FINANCIAL SERVICES EX BANK", "NFMCG": "NIFTY FMCG", 
        "NHEALTH": "NIFTY HEALTHCARE", "NTECH": "NIFTY IT", "NMEDIA": "NIFTY MEDIA", 
        "NMETAL": "NIFTY METAL", "NPHARMA": "NIFTY PHARMA", "NPVTBANK": "NIFTY PRIVATE BANK", 
        "NPSUBANK": "NIFTY PSU BANK", "NREALTY": "NIFTY REALTY", "NCONDUR": "NIFTY CONSUMER DURABLES",
        "NOILGAS": "NIFTY OIL AND GAS INDEX", "NMSFINS": "NIFTY MIDSMALL FINANCIAL SERVICES",
        "NMSHC": "NIFTY MIDSMALL HEALTHCARE", "NMSITT": "NIFTY MIDSMALL IT & TELECOM"
    },
    "STRATEGY": {
        "N100EQWT": "NIFTY 100 EQUAL WEIGHT", "N100LV30": "NIFTY 100 LOW VOLATILITY 30",
        "N5ARB": "NIFTY 10 YR BENCHMARK G-SEC", "N200M30": "NIFTY 200 MOMENTUM 30",
        "N200AL30": "NIFTY 200 ALPHA 30", "N100AL30": "NIFTY 100 ALPHA 30", "NAL50": "NIFTY ALPHA 50",
        "NALV30": "NIFTY ALPHA LOW VOLATILITY 30", "NAQLV30": "NIFTY ALPHA QUALITY LOW VOLATILITY 30",
        "NAQVLV30": "NIFTY ALPHA QUALITY VALUE LOW VOLATILITY 30", 
        "NDIVOP50": "NIFTY DIVIDEND OPPORTUNITIES 50", "NGROW15": "NIFTY GROWTH SECTORS 15",
        "NHBETA50": "NIFTY HIGH BETA 50", "NLV50": "NIFTY LOW VOLATILITY 50",
        "NT10EQWT": "NIFTY TOP 10 EQUAL WEIGHT", "NT15EW": "NIFTY TOP 15 EQUAL WEIGHT",
        "NT20EW": "NIFTY TOP 20 EQUAL WEIGHT", "N100QLT30": "NIFTY 100 QUALITY 30",
        "NM150M50": "NIFTY MIDCAP 150 MOMENTUM 50", "N5FCQ3": "NIFTY 500 FLEXICAP QUALITY 30",
        "N5LV5": "NIFTY 500 LOW VOLATILITY 50", "N500M50": "NIFTY 500 MOMENTUM 50",
        "N500QLT50": "NIFTY 500 QUALITY 50", "NMQLV": "NIFTY 500 MULTIFACTOR MQVLV 50",
        "NMC150Q": "NIFTY MIDCAP 150 QUALITY 50", "NSC250Q": "NIFTY SMALLCAP 250 QUALITY 50",
        "N5MCMQ5": "NIFTY 500 MULTICAP MOMENTUM QUALITY 50", 
        "NMSCMQ": "NIFTY MIDSMALLCAP 400 MOMENTUM QUALITY 100",
        "NSC250MQ": "NIFTY SMALLCAP 250 MOMENTUM QUALITY 100", 
        "NQLV30": "NIFTY QUALITY LOW VOLATILITY 30", "N50EQWGT": "NIFTY 50 EQUAL WEIGHT",
        "N50V20": "NIFTY 50 VALUE 20", "N200V30": "NIFTY 200 VALUE 30", 
        "N500V50": "NIFTY 500 VALUE 50", "N500EQWT": "NIFTY 500 EQUAL WEIGHT", 
        "N200Q30": "NIFTY 200 QUALITY 30"
    },
    "THEMATIC": {
        "NBIRLA": "NIFTY INDIA CORPORATE GROUP INDEX - ADITYA BIRLA GROUP", 
        "NCM": "NIFTY CAPITAL MARKETS", "NCOMM": "NIFTY COMMODITIES", "NCHOUS": "NIFTY CORE HOUSING",
        "NCPSE": "NIFTY CPSE", "NENERGY": "NIFTY ENERGY", "NEVNAA": "NIFTY EV & NEW AGE AUTOMOTIVE",
        "NHOUSING": "NIFTY HOUSING", "N100ESG": "NIFTY 100 ESG", "N100ESGE": "NIFTY 100 ENHANCED ESG",
        "N100ESGSL": "NIFTY 100 ESG SECTOR LEADERS", "NICON": "NIFTY INDIA CONSUMPTION",
        "NIDEF": "NIFTY INDIA DEFENCE", "NIDIGI": "NIFTY INDIA DIGITAL",
        "NIFSL": "NIFTY INDIA INFRASTRUCTURE & LOGISTICS", "NIINT": "NIFTY INDIA INTERNET",
        "NIMFG": "NIFTY INDIA MANUFACTURING", "NTOUR": "NIFTY INDIA TOURISM",
        "NINFRA": "NIFTY INFRASTRUCTURE", 
        "NMAHIN": "NIFTY INDIA CORPORATE GROUP INDEX - MAHINDRA GROUP",
        "NIPO": "NIFTY IPO", "NMIDLIQ15": "NIFTY MIDCAP LIQUID 15",
        "NMSICON": "NIFTY MIDSMALL INDIA CONSUMPTION", "NMNC": "NIFTY MNC", 
        "NMOBIL": "NIFTY MOBILITY", "NPSE": "NIFTY PSE", "NREiT": "NIFTY REITS & INVITS",
        "NRRL": "NIFTY RURAL", "NNCCON": "NIFTY NON-CYCLICAL CONSUMER",
        "NSERVSEC": "NIFTY SERVICES SECTOR", "NSH25": "NIFTY SHARIAH 25",
        "NTATA": "NIFTY INDIA CORPORATE GROUP INDEX - TATA GROUP",
        "NTATA25C": "NIFTY INDIA CORPORATE GROUP INDEX - TATA GROUP 25% CAP",
        "NTRANS": "NIFTY TRANSPORTATION & LOGISTICS", "NLCLIQ15": "NIFTY 100 LIQUID 15",
        "N50SH": "NIFTY 50 SHARIAH", "N500SH": "NIFTY 500 SHARIAH",
        "NMFG532": "NIFTY 500 MULTICAP INDIA MANUFACTURING 50:30:20",
        "NINFRA532": "NIFTY 500 MULTICAP INFRASTRUCTURE 50:30:20", "NSMEE": "NIFTY SME EMERGE",
        "NRPSU": "NIFTY INDIA RAILWAYS PSU", 
        "NMAATR": "NIFTY INDIA SELECT 5 CORPORATE GROUPS (MAATR)",
        "NNACON": "NIFTY INDIA NEW AGE CONSUMPTION", "NWVS": "NIFTY WAVES"
    }
}

# Additional direct mappings from user for JSON variants
DIRECT_MAPPINGS = {
    "NIFTY 50 SHARIAH": ("N50SH", "THEMATIC"),
    "NIFTY TOP 10 EQUAL WEIGHT": ("NT10EQWT", "STRATEGY"),
    "NIFTY CONSUMER DURABLES": ("NCONDUR", "SECTOR"),
    "NIFTY CONSR DURBL": ("NCONDUR", "SECTOR"),
    "NIFTY 500 FLEXICAP": ("N5FCQ3", "STRATEGY"),
    "NIFTY 50 VALUE 20": ("N50V20", "STRATEGY"),
    "NIFTY INDIA SELECT 5 CORPORATE GROUPS (MAATR)": ("NMAATR", "THEMATIC"),
    "NIFTY CORP MAATR": ("NMAATR", "THEMATIC"),
    "NIFTY 500 SHARIAH": ("N500SH", "THEMATIC"),
    "NIFTY 50 FUTURES TR INDEX": ("N50FTR", "STRATEGY"),
    "NIFTY MIDSMALL HEALTHCARE": ("NMSHC", "SECTOR"),
    "NIFTY MIDSML HLTH": ("NMSHC", "SECTOR"),
    "NIFTY MIDCAP 150 QUALITY 50": ("NMC150Q", "STRATEGY"),
    "NIFTY M150 QLTY50": ("NMC150Q", "STRATEGY"),
    "NIFTY 200 QUALITY 30": ("N200Q30", "STRATEGY"),
    "NIFTY 100 ESG SECTOR LEADERS": ("N100ESGSL", "THEMATIC"),
    "NIFTY100ESGSECLDR": ("N100ESGSL", "THEMATIC"),
    "NIFTY SERVICES SECTOR": ("NSERVSEC", "THEMATIC"),
    "NIFTY SERV SECTOR": ("NSERVSEC", "THEMATIC"),
    "NIFTY 100 ALPHA 30": ("N100AL30", "STRATEGY"),
    "NIFTY 100 ESG": ("N100ESG", "THEMATIC"),
    "NIFTY MIDSMALL IT & TELECOM": ("NMSITT", "SECTOR"),
    "NIFTY MS IT TELCM": ("NMSITT", "SECTOR"),
    "NIFTY 100 ENHANCED ESG": ("N100ESGE", "THEMATIC"),
    "NIFTY CORE HOUSING": ("NCHOUS", "THEMATIC"),
    "NIFTY TOTAL MARKET MULTIFACTOR 50": ("NTMF50", "STRATEGY"),
    "NIFTY 200 MOMENTUM 30": ("N200M30", "STRATEGY"),
    "NIFTY200MOMENTM30": ("N200M30", "STRATEGY"),
    "NIFTY NON-CYCLICAL CONSUMER": ("NNCCON", "THEMATIC"),
    "NIFTY NONCYC CONS": ("NNCCON", "THEMATIC"),
    "NIFTY CONGLOMERATE 50": ("NCONG50", "THEMATIC"),
    "NIFTY INDIA CORPORATE GROUP INDEX - TATA GROUP 25% CAP": ("NTATA25C", "THEMATIC"),
    "NIFTY TATA 25 CAP": ("NTATA25C", "THEMATIC"),
    "NIFTY 500 MULTIFACTOR MQVLV 50": ("NMQLV", "STRATEGY"),
    "NIFTY MULTI MQ 50": ("NMQLV", "STRATEGY"),
    "NIFTY500 MQVLV50": ("NMQLV", "STRATEGY"),
    "NIFTY QUALITY LOW VOLATILITY 30": ("NQLV30", "STRATEGY"),
    "NIFTY ALPHA LOW VOLATILITY 30": ("NALV30", "STRATEGY"),
    "NIFTY ALPHALOWVOL": ("NALV30", "STRATEGY"),
    "NIFTY SMALLCAP 250 MOMENTUM QUALITY 100": ("NSC250MQ", "STRATEGY"),
    "NIFTYSML250MQ 100": ("NSC250MQ", "STRATEGY"),
    "NIFTY ALPHA QUALITY LOW VOLATILITY 30": ("NAQLV30", "STRATEGY"),
    "NIFTY INDIA DIGITAL": ("NIDIGI", "THEMATIC"),
    "NIFTY 200 ALPHA 30": ("N200AL30", "STRATEGY"),
    "NIFTY TOP 20 EQUAL WEIGHT": ("NT20EW", "STRATEGY"),
    "NIFTY OIL AND GAS": ("NOILGAS", "SECTOR"),
    "NIFTY LOW VOLATILITY 50": ("NLV50", "STRATEGY"),
    "NIFTY LOW VOL 50": ("NLV50", "STRATEGY"),
    "NIFTY MIDSMALLCAP 400 MOMENTUM QUALITY 100": ("NMSCMQ", "STRATEGY"),
    "NIFTYMS400 MQ 100": ("NMSCMQ", "STRATEGY"),
    "NIFTY 100 LOW VOLATILITY 30": ("N100LV30", "STRATEGY"),
    "NIFTY100 LOWVOL30": ("N100LV30", "STRATEGY"),
    "NIFTY 100 QUALITY 30": ("N100QLT30", "STRATEGY"),
    "NIFTY100 QUALTY30": ("N100QLT30", "STRATEGY"),
    "NIFTY 500 MOMENTUM 50": ("N500M50", "STRATEGY"),
    "NIFTY500MOMENTM50": ("N500M50", "STRATEGY"),
    "NIFTY FINANCIAL SERVICES": ("NFINSERV", "SECTOR"),
    "NIFTY FIN SERVICE": ("NFINSERV", "SECTOR"),
    "NIFTY MIDSMALL INDIA CONSUMPTION": ("NMSICON", "THEMATIC"),
    "NIFTY MS IND CONS": ("NMSICON", "THEMATIC"),
    "NIFTY 500 HEALTHCARE": ("N500HLTH", "SECTOR"),
    "NIFTY500 HEALTH": ("N500HLTH", "SECTOR"),
    "NIFTY TOTAL MARKET": ("NTOTLM", "BROAD"),
    "NIFTY TOTAL MKT": ("NTOTLM", "BROAD"),
    "NIFTY 500 QUALITY 50": ("N500QLT50", "STRATEGY"),
    "NIFTY500 QLTY50": ("N500QLT50", "STRATEGY"),
    "NIFTY SMALLCAP 250 QUALITY 50": ("NSC250Q", "STRATEGY"),
    "NIFTY SML250 Q50": ("NSC250Q", "STRATEGY"),
    "NIFTY MIDCAP 150 MOMENTUM 50": ("NM150M50", "STRATEGY"),
    "NIFTYM150MOMNTM50": ("NM150M50", "STRATEGY"),
    "NIFTY 500 MULTICAP": ("N500", "BROAD"),
    "NIFTY 500 LOW VOLATILITY 50": ("N5LV5", "STRATEGY"),
    "NIFTY500 LOWVOL50": ("N5LV5", "STRATEGY"),
    "NIFTY LARGEMIDCAP 250": ("NLMC250", "BROAD"),
    "NIFTY LARGEMID250": ("NLMC250", "BROAD"),
    "NIFTY PRIVATE BANK": ("NPVTBANK", "SECTOR"),
    "NIFTY PVT BANK": ("NPVTBANK", "SECTOR"),
    "NIFTY SMALLCAP 250": ("NSC250", "BROAD"),
    "NIFTY 500 EQUAL WEIGHT": ("N500EQWT", "STRATEGY"),
    "NIFTY500 EW": ("N500EQWT", "STRATEGY"),
    "NIFTY 500 LARGEMIDSMALL EQUAL WEIGHT": ("N500LMS", "STRATEGY"),
    "NIFTY500 LMS EQL": ("N500LMS", "STRATEGY"),
    "NIFTY MIDSMALLCAP 400": ("NMSC400", "BROAD"),
    "NIFTY INDIA TOURISM": ("NTOUR", "THEMATIC"),
    "NIFTY INDIA INFRASTRUCTURE & LOGISTICS": ("NIFSL", "THEMATIC"),
    "NIFTY INFRALOG": ("NIFSL", "THEMATIC"),
    "NIFTY 100 EQUAL WEIGHT": ("N100EQWT", "STRATEGY"),
    "NIFTY100 EQL WGT": ("N100EQWT", "STRATEGY"),
    "NIFTY FINANCIAL SERVICES 25/50": ("NFINS25", "SECTOR"),
    "NIFTY FINSRV25 50": ("NFINS25", "SECTOR"),
    "NIFTY 500 MULTICAP INDIA MANUFACTURING 50:30:20": ("NMFG532", "THEMATIC"),
    "NIFTY MULTI MFG": ("NMFG532", "THEMATIC"),
    "NIFTY SMALLCAP 100": ("NSC100", "BROAD"),
    "NIFTY DIVIDEND OPPORTUNITIES 50": ("NDIVOP50", "STRATEGY"),
    "NIFTY DIV OPPS 50": ("NDIVOP50", "STRATEGY"),
    "NIFTY 500 MULTICAP INFRASTRUCTURE 50:30:20": ("NINFRA532", "THEMATIC"),
    "NIFTY MULTI INFRA": ("NINFRA532", "THEMATIC"),
    "NIFTY SMALLCAP 50": ("NSC50", "BROAD"),
    "NIFTY INDIA CONSUMPTION": ("NICON", "THEMATIC"),
    "NIFTY CONSUMPTION": ("NICON", "THEMATIC"),
    "NIFTY MICROCAP 250": ("NMICRO", "BROAD"),
    "NIFTY 50 EQUAL WEIGHT": ("N50EQWGT", "STRATEGY"),
    "NIFTY50 EQL WGT": ("N50EQWGT", "STRATEGY"),
    "NIFTY INDIA MANUFACTURING": ("NIMFG", "THEMATIC"),
    "NIFTY INFRASTRUCTURE": ("NINFRA", "THEMATIC"),
    "NIFTY INFRA": ("NINFRA", "THEMATIC"),
    "NIFTY MIDCAP SELECT": ("NMIDSEL", "BROAD"),
    "NIFTY MID SELECT": ("NMIDSEL", "BROAD"),
    "NIFTY INDIA NEW AGE CONSUMPTION": ("NNACON", "THEMATIC"),
    "NIFTY NEW CONSUMP": ("NNACON", "THEMATIC"),
    "NIFTY GROWTH SECTORS 15": ("NGROW15", "STRATEGY"),
    "NIFTY TOP 15 EQUAL WEIGHT": ("NT15EW", "STRATEGY"),
    "NIFTY TRANSPORTATION & LOGISTICS": ("NTRANS", "THEMATIC"),
    "NIFTY HIGH BETA 50": ("NHBETA50", "STRATEGY"),
    "NIFTY MIDCAP LIQUID 15": ("NMIDLIQ15", "THEMATIC"),
    "NIFTY MID LIQ 15": ("NMIDLIQ15", "THEMATIC"),
    "NIFTY 500 VALUE 50": ("N500V50", "STRATEGY"),
    "NIFTY FINANCIAL SERVICES EX BANK": ("NFINSEXB", "SECTOR"),
    "NIFTY 200 VALUE 30": ("N200V30", "STRATEGY"),
    "NIFTY 10 YR BENCHMARK G-SEC": ("N5ARB", "STRATEGY"),
    "NIFTY 100 LIQUID 15": ("NLCLIQ15", "THEMATIC"),
    "NIFTY100 LIQ 15": ("NLCLIQ15", "THEMATIC"),
    "NIFTY MIDSMALL FINANCIAL SERVICES": ("NMSFINS", "SECTOR"),
    "NIFTY MS FIN SERV": ("NMSFINS", "SECTOR"),
}

# Create reverse lookup with flexible matching
REVERSE_LOOKUP = {}

# Add direct mappings first
for full, (short, cat) in DIRECT_MAPPINGS.items():
    REVERSE_LOOKUP[full.upper().strip()] = (short, cat)

# Add original mappings
for category, indices in MAPPINGS.items():
    for short, full in indices.items():
        full_normalized = full.upper().strip()
        if full_normalized not in REVERSE_LOOKUP:
            REVERSE_LOOKUP[full_normalized] = (short, category)
        
        # Also store without special chars for better matching
        clean = full_normalized.replace('-', ' ').replace('&', 'AND').replace('  ', ' ')
        if clean not in REVERSE_LOOKUP:
            REVERSE_LOOKUP[clean] = (short, category)

# Read current JSON
with open('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json', 'r') as f:
    current_data = json.load(f)

# Update with short names and correct categories
updated_data = []
matched = 0
unmatched = []

for item in current_data:
    full_name = item['fullName']
    full_normalized = full_name.upper().strip()
    
    # Try direct match first
    if full_normalized in REVERSE_LOOKUP:
        short, category = REVERSE_LOOKUP[full_normalized]
    else:
        # Try cleaned version
        clean = full_normalized.replace('-', ' ').replace('&', 'AND').replace('  ', ' ')
        if clean in REVERSE_LOOKUP:
            short, category = REVERSE_LOOKUP[clean]
        else:
            # Try common abbreviations
            abbrev = (full_normalized
                     .replace('NIFTY50 ', 'NIFTY 50 ')
                     .replace('NIFTY500 ', 'NIFTY 500 ')
                     .replace('NIFTY100 ', 'NIFTY 100 ')
                     .replace('NIFTY200 ', 'NIFTY 200 ')
                     .replace('NIFTYSML', 'NIFTY SMALLCAP')
                     .replace('NIFTYMS', 'NIFTY MIDSMALL')
                     .replace(' EW', ' EQUAL WEIGHT')
                     .replace(' CONSR ', ' CONSUMER ')
                     .replace(' FIN ', ' FINANCIAL ')
                     .replace(' SERV', ' SERVICE')
                     .replace(' FINSRV', ' FINANCIAL SERVICES')
                     .replace(' QLTY', ' QUALITY')
                     .replace(' MOMENTM', ' MOMENTUM')
                     .replace(' LOWVOL', ' LOW VOLATILITY')
                     .replace(' QUALTY', ' QUALITY')
                     .replace(' INFRALOG', ' INFRASTRUCTURE & LOGISTICS')
                     .replace(' OPPS ', ' OPPORTUNITIES ')
                     .replace(' MFG', ' MANUFACTURING')
                     .replace(' CONSUMP', ' CONSUMPTION')
                     .replace(' MICROCAP', ' MICROCAP ')
                     .replace(' SMLCAP ', ' SMALLCAP ')
                     .replace(' MIDSML ', ' MIDSMALLCAP ')
                     .replace(' LARGEMID', ' LARGEMIDCAP')
                     .replace(' IND ', ' INDIA ')
                     .replace(' CORP ', ' CORPORATE ')
                     .replace(' LV ', ' LOW VOLATILITY ')
                     .replace(' MQ ', ' MOMENTUM QUALITY ')
                     .replace(' AQL ', ' ALPHA QUALITY LOW VOLATILITY ')
                     .replace(' AQLV ', ' ALPHA QUALITY LOW VOLATILITY ')
                     .replace(' TMMQ ', ' TOTAL MARKET MULTIFACTOR ')
                     .replace(' MQVLV', ' MULTIFACTOR MQVLV')
                     .replace(' LMS ', ' LARGEMIDSMALL ')
                     .replace('NONCYC ', 'NON-CYCLICAL ')
                     .replace('CONGLOMERATE', 'CONGLOMERATE ')
                     .replace(' EQL ', ' EQUAL ')
                     .replace('GROWSECT', 'GROWTH SECTORS')
                     .replace('TRANS LOGIS', 'TRANSPORTATION & LOGISTICS')
                     .replace('HIGHBETA', 'HIGH BETA')
                     .replace('FINSEREXBNK', 'FINANCIAL SERVICES EX BANK')
                     .replace('GS 10YR CLN', '10 YR BENCHMARK G-SEC')
                     .replace('ALPHALOWVOL', 'ALPHA LOW VOLATILITY')
                     .replace('ESGSECLDR', 'ESG SECTOR LEADERS')
                     .replace('ENH ESG', 'ENHANCED ESG')
                     .replace('COREHOUSING', 'CORE HOUSING')
                     .replace('MULTI ', 'MULTICAP ')
                     .replace('  ', ' '))
            
            if abbrev in REVERSE_LOOKUP:
                short, category = REVERSE_LOOKUP[abbrev]
            else:
                unmatched.append(full_name)
                continue
    
    updated_data.append({
        "fullName": full_name,
        "displayName": short,  # SHORT NAME for display
        "percentile": item['percentile'],
        "category": category  # EXACT: BROAD, SECTOR, STRATEGY, THEMATIC
    })
    matched += 1

# Backup and save
import shutil
shutil.copy('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json',
            '/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json.backup2')

with open('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json', 'w') as f:
    json.dump(updated_data, f, indent=2)

print(f"✓ Updated {matched} indices")
print(f"✓ Categories: BROAD, SECTOR, STRATEGY, THEMATIC")
if unmatched:
    print(f"\n⚠ {len(unmatched)} not matched:")
    for name in unmatched:
        print(f"  - {name}")
