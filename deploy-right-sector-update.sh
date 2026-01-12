#!/bin/bash

# Deploy Updated Right Sector with Correct Index Names
# Usage: bash deploy-right-sector-update.sh

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${YELLOW}ℹ $1${NC}"; }

echo "========================================="
echo " Right Sector - Index Names Update"
echo "========================================="
echo ""

# Configuration
VPS_HOST="82.25.105.18"
VPS_USER="root"
APP_PATH="/var/www/vsfintech/Right-Sector"
LOCAL_BACKUP="Right-Sector-backup-$(date +%Y%m%d-%H%M%S)"

# Step 1: Download current app
print_info "Step 1: Downloading current Right Sector app..."
scp -r ${VPS_USER}@${VPS_HOST}:${APP_PATH} ./${LOCAL_BACKUP}
print_success "Downloaded to ./${LOCAL_BACKUP}"

# Step 2: Find JavaScript files
print_info "Step 2: Finding JavaScript files with index names..."
find "./${LOCAL_BACKUP}" -type f \( -name "*.js" -o -name "*.html" \) | while read -r file; do
    if grep -l "N50\|NIFTY" "$file" 2>/dev/null; then
        echo "  Found: $file"
    fi
done

# Step 3: Create updated index names file
print_info "Step 3: Creating updated index names configuration..."
cat > ./right-sector-index-names.js << 'ENDJS'
// Updated Index Names Mapping - Matches Excel Sheet
const INDEX_NAMES = {
    // BROAD CATEGORY
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

    // SECTOR CATEGORY
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

    // STRATEGY CATEGORY
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

    // THEMATIC CATEGORY
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

// Category mappings (from Excel)
const CATEGORY_MAP = {
    // Broad
    "N50": "Broad", "NN50": "Broad", "N100": "Broad", "N200": "Broad",
    "NTOTLM": "Broad", "N500": "Broad", "NMC5025": "Broad", "N500EQ": "Broad",
    "NMC150": "Broad", "NMC50": "Broad", "NMIDSEL": "Broad", "NMC100": "Broad",
    "NSC250": "Broad", "NSC50": "Broad", "NSC100": "Broad", "NMICRO": "Broad",
    "NLMC250": "Broad", "NMSC400": "Broad",
    
    // Sector
    "NAUTO": "Sector", "NBANK": "Sector", "NCHEM": "Sector", "NFINSERV": "Sector",
    "NFINS25": "Sector", "NFINSEXB": "Sector", "NFMCG": "Sector", "NHEALTH": "Sector",
    "NTECH": "Sector", "NMEDIA": "Sector", "NMETAL": "Sector", "NPHARMA": "Sector",
    "NPVTBANK": "Sector", "NPSUBANK": "Sector", "NREALTY": "Sector", "NCONDUR": "Sector",
    "NOILGAS": "Sector", "NMSFINS": "Sector", "NMSHC": "Sector", "NMSITT": "Sector",
    
    // Strategy
    "N100EQWT": "Strategy", "N100LV30": "Strategy", "N5ARB": "Strategy", "N200M30": "Strategy",
    "N200AL30": "Strategy", "N100AL30": "Strategy", "NAL50": "Strategy", "NALV30": "Strategy",
    "NAQLV30": "Strategy", "NAQVLV30": "Strategy", "NDIVOP50": "Strategy", "NGROW15": "Strategy",
    "NHBETA50": "Strategy", "NLV50": "Strategy", "NT10EQWT": "Strategy", "NT15EW": "Strategy",
    "NT20EW": "Strategy", "N100QLT30": "Strategy", "NM150M50": "Strategy", "N5FCQ3": "Strategy",
    "N5LV5": "Strategy", "N500M50": "Strategy", "N500QLT50": "Strategy", "NMQLV": "Strategy",
    "NMC150Q": "Strategy", "NSC250Q": "Strategy", "N5MCMQ5": "Strategy", "NMSCMQ": "Strategy",
    "NSC250MQ": "Strategy", "NQLV30": "Strategy", "N50EQWGT": "Strategy", "N50V20": "Strategy",
    "N200V30": "Strategy", "N500V50": "Strategy", "N500EQWT": "Strategy", "N200Q30": "Strategy",
    
    // Thematic
    "NBIRLA": "Thematic", "NCM": "Thematic", "NCOMM": "Thematic", "NCHOUS": "Thematic",
    "NCPSE": "Thematic", "NENERGY": "Thematic", "NEVNAA": "Thematic", "NHOUSING": "Thematic",
    "N100ESG": "Thematic", "N100ESGE": "Thematic", "N100ESGSL": "Thematic", "NICON": "Thematic",
    "NIDEF": "Thematic", "NIDIGI": "Thematic", "NIFSL": "Thematic", "NIINT": "Thematic",
    "NIMFG": "Thematic", "NTOUR": "Thematic", "NINFRA": "Thematic", "NMAHIN": "Thematic",
    "NIPO": "Thematic", "NMIDLIQ15": "Thematic", "NMSICON": "Thematic", "NMNC": "Thematic",
    "NMOBIL": "Thematic", "NPSE": "Thematic", "NREiT": "Thematic", "NRRL": "Thematic",
    "NNCCON": "Thematic", "NSERVSEC": "Thematic", "NSH25": "Thematic", "NTATA": "Thematic",
    "NTATA25C": "Thematic", "NTRANS": "Thematic", "NLCLIQ15": "Thematic", "N50SH": "Thematic",
    "N500SH": "Thematic", "NMFG532": "Thematic", "NINFRA532": "Thematic", "NSMEE": "Thematic",
    "NRPSU": "Thematic", "NMAATR": "Thematic", "NNACON": "Thematic", "NWVS": "Thematic"
};
ENDJS

print_success "Created right-sector-index-names.js"

echo ""
print_info "Manual steps required:"
echo "  1. Review backup in ./${LOCAL_BACKUP}"
echo "  2. Find the JavaScript file containing INDEX_NAMES or similar"
echo "  3. Replace with content from right-sector-index-names.js"
echo "  4. Upload back to VPS: scp -r ./${LOCAL_BACKUP}/* ${VPS_USER}@${VPS_HOST}:${APP_PATH}/"
echo "  5. Clear browser cache and test: http://82.25.105.18/right-sector/"
echo ""
print_success "Update preparation complete!"
