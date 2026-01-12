#!/bin/bash

# Update Risk-Reward app with correct index names from Excel
# This script updates the INDEX_NAMES dictionary in app.py

APP_PATH="/var/www/risk-reward/app.py"
BACKUP_PATH="/var/www/risk-reward/app.py.backup_$(date +%Y%m%d_%H%M%S)"

echo "=================================================="
echo "  UPDATING RISK-REWARD INDEX NAMES"
echo "=================================================="

# Backup current file
echo "Creating backup..."
cp $APP_PATH $BACKUP_PATH
echo "✓ Backup created: $BACKUP_PATH"

# Create new INDEX_NAMES dictionary
cat > /tmp/new_index_names.py << 'EOF'
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
EOF

# Use Python to update the file
python3 << 'PYTHON_SCRIPT'
import re

# Read current app.py
with open('/var/www/risk-reward/app.py', 'r') as f:
    content = f.read()

# Read new INDEX_NAMES
with open('/tmp/new_index_names.py', 'r') as f:
    new_index_names = f.read()

# Replace INDEX_NAMES dictionary
# Pattern to match: INDEX_NAMES = { ... }
pattern = r'INDEX_NAMES\s*=\s*\{[^}]*\}'

if re.search(pattern, content, re.DOTALL):
    content = re.sub(pattern, new_index_names.strip(), content, flags=re.DOTALL)
    print("✓ INDEX_NAMES dictionary updated")
else:
    print("✗ Could not find INDEX_NAMES in app.py")
    print("  Manual update required")
    exit(1)

# Write updated content
with open('/var/www/risk-reward/app.py', 'w') as f:
    f.write(content)

print("✓ File updated successfully")
PYTHON_SCRIPT

# Restart service
echo ""
echo "Restarting risk-reward service..."
systemctl restart risk-reward
sleep 2

if systemctl is-active --quiet risk-reward; then
    echo "✓ Service restarted successfully"
else
    echo "✗ Service failed to restart"
    echo "  Restoring backup..."
    cp $BACKUP_PATH $APP_PATH
    systemctl restart risk-reward
    echo "  Backup restored"
    exit 1
fi

# Test API
echo ""
echo "Testing API..."
response=$(curl -s http://localhost:8003/api/risk-return | head -c 200)
if [ -n "$response" ]; then
    echo "✓ API is responding"
    echo "  Sample response: $response..."
else
    echo "✗ API not responding"
fi

echo ""
echo "=================================================="
echo "  UPDATE COMPLETE"
echo "=================================================="
echo ""
echo "Changes:"
echo "  - Updated INDEX_NAMES with 126 indices from Excel"
echo "  - Backup saved: $BACKUP_PATH"
echo "  - Service restarted"
echo ""
echo "Test the changes:"
echo "  curl http://82.25.105.18:8003/api/risk-return"
echo "  Or visit: http://82.25.105.18/risk-reward/"
echo ""
