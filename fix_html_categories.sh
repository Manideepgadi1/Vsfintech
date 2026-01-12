#!/bin/bash
# Fix Right Sector HTML categories

cd /var/www/vsfintech/Right-Sector/

# Backup
cp index.html index.html.backup3

# Replace categories
sed -i "s/'Broad Market'/'BROAD'/g" index.html
sed -i "s/'Sectoral'/'SECTOR'/g" index.html
sed -i "s/'Strategy'/'STRATEGY'/g" index.html
sed -i "s/'Thematic'/'THEMATIC'/g" index.html

echo "✓ Categories updated to: BROAD, SECTOR, STRATEGY, THEMATIC"
