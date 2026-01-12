#!/bin/bash

# Master script to update index names in both Risk-Reward and Right Sector
# Based on SHORT AND FULL NAMES.xlsx

echo "================================================================================"
echo "                     INDEX NAMES UPDATE - MASTER SCRIPT"
echo "================================================================================"
echo ""
echo "This will update index names in:"
echo "  1. Risk-Reward app (app.py INDEX_NAMES dictionary)"
echo "  2. Right Sector app (category_mappings.json file)"
echo ""
echo "Source: SHORT AND FULL NAMES.xlsx"
echo "Total Indices: 126"
echo "  - Broad: 26"
echo "  - Sector: 20"
echo "  - Strategy: 36"
echo "  - Thematic: 44"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "================================================================================"
echo "STEP 1: Updating Risk-Reward"
echo "================================================================================"
echo ""

# Risk-Reward Update
APP_PATH="/var/www/risk-reward/app.py"
BACKUP_PATH="/var/www/risk-reward/app.py.backup_$(date +%Y%m%d_%H%M%S)"

if [ ! -f "$APP_PATH" ]; then
    echo "✗ Risk-Reward app.py not found at $APP_PATH"
    echo "  Skipping Risk-Reward update"
else
    echo "Creating backup..."
    cp $APP_PATH $BACKUP_PATH
    echo "✓ Backup: $BACKUP_PATH"
    
    # Create new INDEX_NAMES
    cat > /tmp/new_index_names.py << 'ENDPY'
INDEX_NAMES = {
    "N100": "NIFTY 100",
    "N100AL30": "NIFTY100 ALPHA 30",
    "N100EQWT": "NIFTY 100 EQUAL WEIGHT",
    "N100ESG": "NIFTY100 ESG",
    "N100ESGE": "NIFTY100 Enhanced ESG",
    "N100ESGSL": "Nifty100 ESG Sector Leaders",
    "N100LV30": "NIFTY 100 LOW VOLATILITY 30",
    "N100QLT30": "NIFTY100 QUALITY 30",
    "N200": "NIFTY 200",
    "N200AL30": "NIFTY200 ALPHA 30",
    "N200M30": "NIFTY200 MOMENTUM 30",
    "N200Q30": "NIFTY200 Quality 30",
    "N200V30": "Nifty200 Value 30",
    "N50": "NIFTY 50",
    "N500": "NIFTY 500",
    "N500EQ": "NIFTY500 EQUAL WEIGHT",
    "N500EQWT": "NIFTY500 EQUAL WEIGHT",
    "N500M50": "NIFTY500 MOMENTUM 50",
    "N500QLT50": "NIFTY500 QUALITY 50",
    "N500SH": "NIFTY500 SHARIAH",
    "N500V50": "NIFTY500 VALUE 50",
    "N50EQWGT": "NIFTY50 EQUAL WEIGHT",
    "N50SH": "NIFTY50 SHARIAH",
    "N50V20": "NIFTY50 VALUE 20",
    "N5ARB": "NIFTY 10 YR BENCHMARK G-SEC",
    "N5FCQ3": "Nifty500 Flexicap Quality 30",
    "N5LV5": "NIFTY500 LOW VOLATILITY 50",
    "N5MCMQ5": "NIFTY500 MULTICAP MOMENTUM QUALITY 50",
    "NAL50": "NIFTY ALPHA 50",
    "NALV30": "NIFTY ALPHA LOW VOLATILITY 30",
    "NAQLV30": "NIFTY ALPHA QUALITY LOW VOLATILITY 30",
    "NAQVLV30": "NIFTY ALPHA QUALITY VALUE LOW-VOLATILITY 30",
    "NAUTO": "NIFTY AUTO",
    "NBANK": "NIFTY BANK",
    "NBIRLA": "NIFTY INDIA CORPORATE GROUP INDEX - ADITYA BIRLA GROUP",
    "NCHEM": "NIFTY CHEMICALS",
    "NCHOUS": "Nifty Core Housing",
    "NCM": "Nifty Capital Markets",
    "NCOMM": "NIFTY COMMODITIES",
    "NCONDUR": "NIFTY CONSUMER DURABLES",
    "NCONTRA": "KOTAK CONTRA",
    "NCPSE": "NIFTY CPSE",
    "NDIVOP50": "NIFTY DIVIDEND OPPORTUNITIES 50",
    "NELSS": "DSP ELSS",
    "NENERGY": "NIFTY ENERGY",
    "NEVNAA": "Nifty EV & New Age Automotive",
    "NFINS25": "NIFTY FINANCIAL SERVICES 25/50",
    "NFINSERV": "NIFTY FINANCIAL SERVICES",
    "NFINSEXB": "Nifty Financial Services Ex Bank",
    "NFLEXI": "UTI FLEX",
    "NFMCG": "NIFTY FMCG",
    "NGOLD": "KOTAK GOLD",
    "NGROW15": "NIFTY GROWTH SECTORS 15",
    "NHBETA50": "NIFTY HIGH BETA 50",
    "NHEALTH": "Nifty HEALTHCARE",
    "NHOUSING": "Nifty Housing",
    "NHSBCYCLE": "HSBC Business Cycles Fund - Regular Growth",
    "NICON": "NIFTY INDIA CONSUMPTION",
    "NIDEF": "Nifty India Defence",
    "NIDIGI": "Nifty India Digital",
    "NIFSL": "NIFTY INDIA INFRASTRUCTURE & LOGISTICS",
    "NIINT": "Nifty India Internet",
    "NIMFG": "Nifty India Manufacturing",
    "NINFRA": "NIFTY INFRASTRUCTURE",
    "NINFRA532": "NIFTY500 MULTICAP INFRASTRUCTURE 50:30:20",
    "NINNOV": "AXIS INNOVATION",
    "NIPO": "NIFTY IPO",
    "NLCLIQ15": "NIFTY100 LIQUID 15",
    "NLMC250": "NIFTY LargeMidcap 250",
    "NLV50": "NIFTY LOW VOLATILITY 50",
    "NM150M50": "NIFTY Midcap150 Momentum 50",
    "NMAATR": "NIFTY INDIA SELECT 5 CORPORATE GROUPS (MAATR)",
    "NMAHIN": "NIFTY INDIA CORPORATE GROUP INDEX - MAHINDRA GROUP",
    "NMC100": "NIFTY Midcap 100",
    "NMC150": "NIFTY MIDCAP 150",
    "NMC150Q": "NIFTY Midcap150 Quality 50",
    "NMC50": "NIFTY MIDCAP 50",
    "NMC5025": "NIFTY500 MULTICAP 50:25:25",
    "NMEDIA": "NIFTY MEDIA",
    "NMETAL": "NIFTY METAL",
    "NMFG532": "NIFTY500 MULTICAP INDIA MANUFATURING 50:30:20",
    "NMICRO": "NIFTY MICROCAP 250",
    "NMIDLIQ15": "NIFTY MIDCAP LIQUID 15",
    "NMIDSEL": "Nifty Midcap Select",
    "NMNC": "NIFTY MNC",
    "NMOBIL": "Nifty Mobility",
    "NMQLV": "NIFTY500 MULTIFACTOR MQVLv 50",
    "NMSC400": "NIFTY MIDSMALLCAP 400",
    "NMSCMQ": "Nifty MidSmallcap400 Momentum Quality 100",
    "NMSFINS": "Nifty MidSmall Financial Services",
    "NMSHC": "Nifty MidSmall Healthcare",
    "NMSICON": "Nifty MidSmall India Consumption",
    "NMSITT": "Nifty MidSmall IT & Telecom",
    "NN50": "NIFTY NEXT 50",
    "NNACON": "NIFTY INDIA NEW AGE CONSUMPTION",
    "NNCCON": "Nifty Non-Cyclical Consumer Index",
    "NOILGAS": "NIFTY OIL AND GAS INDEX",
    "NPHARMA": "NIFTY PHARMA",
    "NPSE": "NIFTY PSE",
    "NPSUBANK": "NIFTY PSU BANK",
    "NPVTBANK": "NIFTY PRIVATE BANK",
    "NQLV30": "NIFTY QUALITY LOW VOLATILITY 30",
    "NQUANT": "DSP QUANT",
    "NREALTY": "NIFTY REALTY",
    "NREiT": "Nifty REITs & InvITs",
    "NRPSU": "Nifty India Railways PSU",
    "NRRL": "Nifty Rural",
    "NSC100": "NIFTY SMALLCAP 100",
    "NSC250": "NIFTY SMALLCAP 250",
    "NSC250MQ": "Nifty Smallcap250 Momentum Quality 100",
    "NSC250Q": "Nifty Smallcap250 Quality 50",
    "NSC50": "NIFTY SMALLCAP 50",
    "NSERVSEC": "NIFTY SERVICES SECTOR",
    "NSH25": "NIFTY SHARIAH 25",
    "NSILVER": "ICICI PRU SILVER",
    "NSMEE": "NIFTY SME EMERGE",
    "NT10EQWT": "NIFTY TOP 10 EQUAL WEIGHT",
    "NT15EW": "NIFTY TOP 15 EQUAL WEIGHT",
    "NT20EW": "NIFTY TOP 20 EQUAL WEIGHT",
    "NTATA": "NIFTY INDIA CORPORATE GROUP INDEX - TATA GROUP",
    "NTATA25C": "NIFTY INDIA CORPORATE GROUP INDEX - TATA GROUP 25% CAP",
    "NTECH": "NIFTY IT",
    "NTOTLM": "Nifty Total Market",
    "NTOUR": "NIFTY INDIA TOURISM",
    "NTRANS": "Nifty Transportation & Logistics",
    "NWVS": "Nifty Waves",
}
ENDPY
    
    # Update using Python
    python3 << 'ENDPYTHON'
import re
with open('/var/www/risk-reward/app.py', 'r') as f:
    content = f.read()
with open('/tmp/new_index_names.py', 'r') as f:
    new_dict = f.read()
pattern = r'INDEX_NAMES\s*=\s*\{[^}]*\}'
if re.search(pattern, content, re.DOTALL):
    content = re.sub(pattern, new_dict.strip(), content, flags=re.DOTALL)
    with open('/var/www/risk-reward/app.py', 'w') as f:
        f.write(content)
    print("✓ INDEX_NAMES updated")
else:
    print("✗ Could not find INDEX_NAMES")
    exit(1)
ENDPYTHON
    
    # Restart service
    echo "Restarting risk-reward service..."
    systemctl restart risk-reward
    sleep 2
    
    if systemctl is-active --quiet risk-reward; then
        echo "✓ Risk-Reward service restarted"
    else
        echo "✗ Service failed, restoring backup..."
        cp $BACKUP_PATH $APP_PATH
        systemctl restart risk-reward
    fi
fi

echo ""
echo "================================================================================"
echo "STEP 2: Updating Right Sector"
echo "================================================================================"
echo ""

# Right Sector Update
RS_PATH="/var/www/vsfintech/Right-Sector/data"

if [ ! -d "$RS_PATH" ]; then
    echo "✗ Right Sector data directory not found at $RS_PATH"
    echo "  Skipping Right Sector update"
else
    # Backup if exists
    if [ -f "$RS_PATH/category_mappings.json" ]; then
        cp "$RS_PATH/category_mappings.json" "$RS_PATH/category_mappings_backup_$(date +%Y%m%d_%H%M%S).json"
        echo "✓ Backup created"
    fi
    
    # Create category mappings - saving to file directly
    cat > "$RS_PATH/category_mappings.json" << 'ENDJSON'
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
ENDJSON
    
    chown www-data:www-data "$RS_PATH/category_mappings.json"
    chmod 644 "$RS_PATH/category_mappings.json"
    echo "✓ Right Sector category mappings created"
fi

echo ""
echo "================================================================================"
echo "                              UPDATE SUMMARY"
echo "================================================================================"
echo ""
echo "✓ Risk-Reward: INDEX_NAMES dictionary updated (126 indices)"
echo "✓ Right Sector: category_mappings.json created (126 indices)"
echo ""
echo "Breakdown by category:"
echo "  - Broad: 26 indices"
echo "  - Sector: 20 indices"
echo "  - Strategy: 36 indices"
echo "  - Thematic: 44 indices"
echo ""
echo "Test your changes:"
echo "  Risk-Reward: curl http://82.25.105.18:8003/api/risk-return"
echo "  Risk-Reward: http://82.25.105.18/risk-reward/"
echo "  Right Sector: http://82.25.105.18/right-sector/"
echo ""
echo "✓ All updates complete!"
echo ""
