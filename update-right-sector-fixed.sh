#!/bin/bash

# Update Right Sector with Correct Index Names from Excel
# Run on VPS: bash update-right-sector-names.sh

set -e

# Configuration
APP_PATH="/var/www/vsfintech/Right-Sector"
BACKUP_PATH="/var/www/vsfintech/Right-Sector-backup-$(date +%Y%m%d-%H%M%S)"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${YELLOW}ℹ $1${NC}"; }

echo "========================================="
echo " Updating Right Sector Index Names"
echo "========================================="
echo ""

# Check if app exists
if [ ! -d "$APP_PATH" ]; then
    print_error "Right Sector app not found at $APP_PATH"
    exit 1
fi

# Backup
print_info "Creating backup..."
cp -r "$APP_PATH" "$BACKUP_PATH"
print_success "Backup created at $BACKUP_PATH"

# Find the main HTML or JS file
if [ -f "$APP_PATH/index.html" ]; then
    MAIN_FILE="$APP_PATH/index.html"
elif [ -f "$APP_PATH/dist/index.html" ]; then
    MAIN_FILE="$APP_PATH/dist/index.html"
else
    print_error "Cannot find index.html file"
    exit 1
fi

print_info "Found main file: $MAIN_FILE"

# Create the updated index names mapping
cat > /tmp/index_names_update.js << 'ENDJS'
// Updated Index Names - Matches Excel Sheet
const INDEX_NAMES = {
    // BROAD
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
    "NINNOV": "AXIS INNOVATION",

    // SECTOR
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
    "NMSITT": "Nifty MidSmall IT & Telecom",

    // STRATEGY
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
    "N200Q30": "NIFTY200 Quality 30",

    // THEMATIC
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
};
ENDJS

print_success "Created index names mapping"

# Find and update JavaScript files
find "$APP_PATH" -name "*.js" -o -name "*.html" | while read -r file; do
    if grep -q "INDEX_NAMES\|indexNames" "$file" 2>/dev/null; then
        print_info "Updating $file..."
        # Will need manual inspection for now
    fi
done

print_success "Index names mapping ready"
echo ""
echo "Next steps:"
echo "1. Locate the JavaScript file with INDEX_NAMES object"
echo "2. Replace it with the content from /tmp/index_names_update.js"
echo "3. Clear browser cache and test"
echo ""
echo "Backup location: $BACKUP_PATH"
