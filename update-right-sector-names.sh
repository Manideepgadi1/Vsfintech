#!/bin/bash

# Update Right Sector with category mappings from Excel
# This creates/updates a category mapping file

APP_PATH="/var/www/vsfintech/Right-Sector"
DATA_PATH="$APP_PATH/data"
BACKUP_PATH="$APP_PATH/category_mappings_backup_$(date +%Y%m%d_%H%M%S).json"

echo "=================================================="
echo "  UPDATING RIGHT SECTOR CATEGORY MAPPINGS"
echo "=================================================="

# Create mappings JSON
cat > /tmp/category_mappings.json << 'EOF'
{
  "categories": {
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
}
EOF

echo "Creating category mappings file..."

# Backup if exists
if [ -f "$DATA_PATH/category_mappings.json" ]; then
    cp "$DATA_PATH/category_mappings.json" "$BACKUP_PATH"
    echo "✓ Backup created: $BACKUP_PATH"
fi

# Copy new mappings
cp /tmp/category_mappings.json "$DATA_PATH/category_mappings.json"
echo "✓ Category mappings file created"

# Set permissions
chown www-data:www-data "$DATA_PATH/category_mappings.json"
chmod 644 "$DATA_PATH/category_mappings.json"
echo "✓ Permissions set"

# Verify file
if [ -f "$DATA_PATH/category_mappings.json" ]; then
    size=$(stat -f%z "$DATA_PATH/category_mappings.json" 2>/dev/null || stat -c%s "$DATA_PATH/category_mappings.json")
    echo "✓ File created successfully ($size bytes)"
    
    # Show category counts
    echo ""
    echo "Category Summary:"
    echo "  - Broad: 26 indices"
    echo "  - Sector: 20 indices"
    echo "  - Strategy: 36 indices"
    echo "  - Thematic: 44 indices"
    echo "  - Total: 126 indices"
else
    echo "✗ Failed to create category mappings file"
    exit 1
fi

echo ""
echo "=================================================="
echo "  UPDATE COMPLETE"
echo "=================================================="
echo ""
echo "Created:"
echo "  $DATA_PATH/category_mappings.json"
echo ""
echo "This file contains the mapping of short names to full names"
echo "organized by category (Broad, Sector, Strategy, Thematic)"
echo ""
echo "Right Sector app can now use this file to display correct names"
echo ""
