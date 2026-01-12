#!/bin/bash
# Update Right Sector with correct categories and short/full names from Excel

set -e

echo "================================================"
echo " Right Sector: Categories & Names Update"
echo "================================================"
echo ""

# Upload Excel to VPS
echo "[1/5] Uploading Excel file to VPS..."
scp "D:/VSFintech-Platform/SHORT AND FULL NAMES.xlsx" root@82.25.105.18:/var/www/vsfintech/Right-Sector/data/
echo "✓ Excel uploaded"

# Create category mapping JSON
echo "[2/5] Creating category mappings..."
cat > /tmp/category_index_mappings.json << 'ENDJSON'
{
  "Broad": {
    "N50": "NIFTY 50",
    "NN50": "NIFTY NEXT 50",
    "N100": "NIFTY 100",
    "N200": "NIFTY 200",
    "NTOTLM": "Nifty Total Market",
    "N500": "NIFTY 500",
    "NMC5025": "NIFTY500 MULTICAP 50:25:25",
    "N500EQ": "NIFTY500 EQUAL WEIGHT",
    "NMC150": "NIFTY MIDCAP 150",
    "NMC50": "NIFTY MIDCAP 50",
    "NMIDSEL": "Nifty Midcap Select",
    "NMC100": "NIFTY Midcap 100",
    "NSC250": "NIFTY SMALLCAP 250",
    "NSC50": "NIFTY SMALLCAP 50",
    "NSC100": "NIFTY SMALLCAP 100",
    "NMICRO": "NIFTY MICROCAP 250",
    "NLMC250": "NIFTY LargeMidcap 250",
    "NMSC400": "NIFTY MIDSMALLCAP 400",
    "NQUANT": "DSP QUANT",
    "NELSS": "DSP ELSS",
    "NSILVER": "ICICI PRU SILVER",
    "NHSBCYCLE": "HSBC Business Cycles Fund - Regular Growth",
    "NCONTRA": "KOTAK CONTRA",
    "NGOLD": "KOTAK GOLD",
    "NFLEXI": "UTI FLEX",
    "NINNOV": "AXIS INNOVATION"
  },
  "Sector": {
    "NAUTO": "NIFTY AUTO",
    "NBANK": "NIFTY BANK",
    "NCHEM": "NIFTY CHEMICALS",
    "NFINSERV": "NIFTY FINANCIAL SERVICES",
    "NFINS25": "NIFTY FINANCIAL SERVICES 25/50",
    "NFINSEXB": "Nifty Financial Services Ex Bank",
    "NFMCG": "NIFTY FMCG",
    "NHEALTH": "Nifty HEALTHCARE",
    "NTECH": "NIFTY IT",
    "NMEDIA": "NIFTY MEDIA",
    "NMETAL": "NIFTY METAL",
    "NPHARMA": "NIFTY PHARMA",
    "NPVTBANK": "NIFTY PRIVATE BANK",
    "NPSUBANK": "NIFTY PSU BANK",
    "NREALTY": "NIFTY REALTY",
    "NCONDUR": "NIFTY CONSUMER DURABLES",
    "NOILGAS": "NIFTY OIL AND GAS INDEX",
    "NMSFINS": "Nifty MidSmall Financial Services",
    "NMSHC": "Nifty MidSmall Healthcare",
    "NMSITT": "Nifty MidSmall IT & Telecom"
  },
  "Strategy": {
    "N100EQWT": "NIFTY 100 EQUAL WEIGHT",
    "N100LV30": "NIFTY 100 LOW VOLATILITY 30",
    "N5ARB": "NIFTY 10 YR BENCHMARK G-SEC",
    "N200M30": "NIFTY200 MOMENTUM 30",
    "N200AL30": "NIFTY200 ALPHA 30",
    "N100AL30": "NIFTY100 ALPHA 30",
    "NAL50": "NIFTY ALPHA 50",
    "NALV30": "NIFTY ALPHA LOW VOLATILITY 30",
    "NAQLV30": "NIFTY ALPHA QUALITY LOW VOLATILITY 30",
    "NAQVLV30": "NIFTY ALPHA QUALITY VALUE LOW-VOLATILITY 30",
    "NDIVOP50": "NIFTY DIVIDEND OPPORTUNITIES 50",
    "NGROW15": "NIFTY GROWTH SECTORS 15",
    "NHBETA50": "NIFTY HIGH BETA 50",
    "NLV50": "NIFTY LOW VOLATILITY 50",
    "NT10EQWT": "NIFTY TOP 10 EQUAL WEIGHT",
    "NT15EW": "NIFTY TOP 15 EQUAL WEIGHT",
    "NT20EW": "NIFTY TOP 20 EQUAL WEIGHT",
    "N100QLT30": "NIFTY100 QUALITY 30",
    "NM150M50": "NIFTY Midcap150 Momentum 50",
    "N5FCQ3": "Nifty500 Flexicap Quality 30",
    "N5LV5": "NIFTY500 LOW VOLATILITY 50",
    "N500M50": "NIFTY500 MOMENTUM 50",
    "N500QLT50": "NIFTY500 QUALITY 50",
    "NMQLV": "NIFTY500 MULTIFACTOR MQVLv 50",
    "NMC150Q": "NIFTY Midcap150 Quality 50",
    "NSC250Q": "Nifty Smallcap250 Quality 50",
    "N5MCMQ5": "NIFTY500 MULTICAP MOMENTUM QUALITY 50",
    "NMSCMQ": "Nifty MidSmallcap400 Momentum Quality 100",
    "NSC250MQ": "Nifty Smallcap250 Momentum Quality 100",
    "NQLV30": "NIFTY QUALITY LOW VOLATILITY 30",
    "N50EQWGT": "NIFTY50 EQUAL WEIGHT",
    "N50V20": "NIFTY50 VALUE 20",
    "N200V30": "Nifty200 Value 30",
    "N500V50": "NIFTY500 VALUE 50",
    "N500EQWT": "NIFTY500 EQUAL WEIGHT",
    "N200Q30": "NIFTY200 Quality 30"
  },
  "Thematic": {
    "NBIRLA": "NIFTY INDIA CORPORATE GROUP INDEX - ADITYA BIRLA GROUP",
    "NCM": "Nifty Capital Markets",
    "NCOMM": "NIFTY COMMODITIES",
    "NCHOUS": "Nifty Core Housing",
    "NCPSE": "NIFTY CPSE",
    "NENERGY": "NIFTY ENERGY",
    "NEVNAA": "Nifty EV & New Age Automotive",
    "NHOUSING": "Nifty Housing",
    "N100ESG": "NIFTY100 ESG",
    "N100ESGE": "NIFTY100 Enhanced ESG",
    "N100ESGSL": "Nifty100 ESG Sector Leaders",
    "NICON": "NIFTY INDIA CONSUMPTION",
    "NIDEF": "Nifty India Defence",
    "NIDIGI": "Nifty India Digital",
    "NIFSL": "NIFTY INDIA INFRASTRUCTURE & LOGISTICS",
    "NIINT": "Nifty India Internet",
    "NIMFG": "Nifty India Manufacturing",
    "NTOUR": "NIFTY INDIA TOURISM",
    "NINFRA": "NIFTY INFRASTRUCTURE",
    "NMAHIN": "NIFTY INDIA CORPORATE GROUP INDEX - MAHINDRA GROUP",
    "NIPO": "NIFTY IPO",
    "NMIDLIQ15": "NIFTY MIDCAP LIQUID 15",
    "NMSICON": "Nifty MidSmall India Consumption",
    "NMNC": "NIFTY MNC",
    "NMOBIL": "Nifty Mobility",
    "NPSE": "NIFTY PSE",
    "NREiT": "Nifty REITs & InvITs",
    "NRRL": "Nifty Rural",
    "NNCCON": "Nifty Non-Cyclical Consumer Index",
    "NSERVSEC": "NIFTY SERVICES SECTOR",
    "NSH25": "NIFTY SHARIAH 25",
    "NTATA": "NIFTY INDIA CORPORATE GROUP INDEX - TATA GROUP",
    "NTATA25C": "NIFTY INDIA CORPORATE GROUP INDEX - TATA GROUP 25% CAP",
    "NTRANS": "Nifty Transportation & Logistics",
    "NLCLIQ15": "NIFTY100 LIQUID 15",
    "N50SH": "NIFTY50 SHARIAH",
    "N500SH": "NIFTY500 SHARIAH",
    "NMFG532": "NIFTY500 MULTICAP INDIA MANUFATURING 50:30:20",
    "NINFRA532": "NIFTY500 MULTICAP INFRASTRUCTURE 50:30:20",
    "NSMEE": "NIFTY SME EMERGE",
    "NRPSU": "Nifty India Railways PSU",
    "NMAATR": "NIFTY INDIA SELECT 5 CORPORATE GROUPS (MAATR)",
    "NNACON": "NIFTY INDIA NEW AGE CONSUMPTION",
    "NWVS": "Nifty Waves"
  }
}
ENDJSON

scp /tmp/category_index_mappings.json root@82.25.105.18:/var/www/vsfintech/Right-Sector/data/
echo "✓ Category mappings created"

echo ""
echo "[3/5] Backup Right Sector..."
ssh root@82.25.105.18 "cp -r /var/www/vsfintech/Right-Sector /var/www/vsfintech/Right-Sector-backup-$(date +%Y%m%d-%H%M%S)"
echo "✓ Backup created"

echo ""
echo "[4/5] Finding Right Sector files..."
ssh root@82.25.105.18 "find /var/www/vsfintech/Right-Sector -name '*.html' -o -name '*.js' | head -10"

echo ""
echo "[5/5] Summary"
echo "================================================"
echo "✓ Excel uploaded to VPS"
echo "✓ Category mappings created: 126 indices"
echo "  - Broad: 26"
echo "  - Sector: 20"
echo "  - Strategy: 36"
echo "  - Thematic: 44"
echo ""
echo "Manual step required:"
echo "Update Right Sector JavaScript to:"
echo "1. Load category_index_mappings.json"
echo "2. Display SHORT names (e.g., N50, NAUTO)"
echo "3. Show FULL names on hover (tooltip)"
echo "4. Group by categories (Broad, Sector, Strategy, Thematic)"
echo ""
