#!/bin/bash

# VPS Cleanup and Deployment Script for VSFintech Platform
# Run this script on your VPS after connecting via SSH

echo "================================================"
echo "VSFintech Platform - VPS Deployment Script"
echo "================================================"

# Step 1: Check and kill suspicious processes
echo "Step 1: Checking for suspicious processes..."
ps aux --sort=-%cpu | head -20
echo ""
read -p "Do you see any suspicious processes? (y/n): " suspicious

if [ "$suspicious" = "y" ]; then
    echo "Killing high CPU processes..."
    # Kill processes using more than 50% CPU (adjust as needed)
    for pid in $(ps aux --sort=-%cpu | awk 'NR>1 && $3>50 {print $2}'); do
        echo "Killing process $pid"
        kill -9 $pid
    done
fi

# Step 2: Update system and install security tools
echo ""
echo "Step 2: Updating system and installing security tools..."
apt update
apt upgrade -y
apt install -y fail2ban ufw clamav clamav-daemon

# Step 3: Run antivirus scan
echo ""
echo "Step 3: Running ClamAV antivirus scan..."
freshclam
clamscan -r --remove /tmp /var/tmp /home || true

# Step 4: Configure firewall
echo ""
echo "Step 4: Configuring firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8000/tcp
ufw allow 5173/tcp
ufw --force enable

# Step 5: Clean up system
echo ""
echo "Step 5: Cleaning up system..."
apt autoremove -y
apt autoclean -y
rm -rf /tmp/*
rm -rf /var/tmp/*

# Step 6: Install Node.js and npm
echo ""
echo "Step 6: Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Step 7: Install Python and pip
echo ""
echo "Step 7: Installing Python and pip..."
apt install -y python3 python3-pip python3-venv

# Step 8: Install PM2 for process management
echo ""
echo "Step 8: Installing PM2..."
npm install -g pm2

# Step 9: Install Nginx
echo ""
echo "Step 9: Installing Nginx..."
apt install -y nginx

# Step 10: Create deployment directory
echo ""
echo "Step 10: Creating deployment directory..."
mkdir -p /var/www/vsfintech
cd /var/www/vsfintech

# Step 11: Clone main repository
echo ""
echo "Step 11: Cloning VSFintech Platform from GitHub..."
if [ -d "VSFintech-Platform" ]; then
    rm -rf VSFintech-Platform
fi
git clone https://github.com/Manideepgadi1/Vsfintech.git VSFintech-Platform

# Step 12: Setup Backend
echo ""
echo "Step 12: Setting up Backend..."
cd /var/www/vsfintech/VSFintech-Platform/backend
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Step 13: Setup Frontend
echo ""
echo "Step 13: Setting up Frontend..."
cd /var/www/vsfintech/VSFintech-Platform/frontend
npm install
npm run build

# Step 14: Create PM2 ecosystem file
echo ""
echo "Step 14: Creating PM2 ecosystem configuration..."
cat > /var/www/vsfintech/ecosystem.config.js <<'EOF'
module.exports = {
  apps: [
    {
      name: 'vsfintech-backend',
      script: '/var/www/vsfintech/VSFintech-Platform/backend/venv/bin/uvicorn',
      args: 'main:app --host 0.0.0.0 --port 8000',
      cwd: '/var/www/vsfintech/VSFintech-Platform/backend',
      interpreter: 'none',
      env: {
        PYTHONPATH: '/var/www/vsfintech/VSFintech-Platform/backend'
      }
    },
    {
      name: 'vsfintech-frontend',
      script: 'npx',
      args: 'vite preview --host 0.0.0.0 --port 5173',
      cwd: '/var/www/vsfintech/VSFintech-Platform/frontend'
    }
  ]
};
EOF

# Step 15: Configure Nginx
echo ""
echo "Step 15: Configuring Nginx..."
cat > /etc/nginx/sites-available/vsfintech <<'EOF'
server {
    listen 80;
    server_name 82.25.105.18;

    # Frontend
    location / {
        proxy_pass http://localhost:5173;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # Backend API
    location /api/ {
        proxy_pass http://localhost:8000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # AlphaNifty
    location /alphanifty {
        alias /var/www/vsfintech/apps/alphanifty;
        try_files $uri $uri/ /alphanifty/index.html;
    }

    # Riskometer
    location /riskometer {
        alias /var/www/vsfintech/apps/riskometer;
        try_files $uri $uri/ /riskometer/index.html;
    }

    # Heatmap
    location /heatmap {
        alias /var/www/vsfintech/apps/heatmap;
        try_files $uri $uri/ /heatmap/index.html;
    }

    # PMS
    location /pms {
        alias /var/www/vsfintech/apps/pms;
        try_files $uri $uri/ /pms/index.html;
    }

    # Barline
    location /barline {
        alias /var/www/vsfintech/apps/barline;
        try_files $uri $uri/ /barline/index.html;
    }

    # RightSector
    location /rightsector {
        alias /var/www/vsfintech/apps/rightsector;
        try_files $uri $uri/ /rightsector/index.html;
    }

    # Risk-Reward
    location /risk-reward {
        alias /var/www/vsfintech/apps/risk-reward;
        try_files $uri $uri/ /risk-reward/index.html;
    }

    # Multichart
    location /multichart {
        alias /var/www/vsfintech/apps/multichart;
        try_files $uri $uri/ /multichart/index.html;
    }
}
EOF

# Enable the site
ln -sf /etc/nginx/sites-available/vsfintech /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
nginx -t

# Step 16: Start services
echo ""
echo "Step 16: Starting services..."
pm2 delete all || true
pm2 start /var/www/vsfintech/ecosystem.config.js
pm2 save
pm2 startup

# Restart Nginx
systemctl restart nginx

# Step 17: Final system check
echo ""
echo "================================================"
echo "Deployment Complete!"
echo "================================================"
echo ""
echo "System Status:"
echo "--------------"
pm2 status
echo ""
echo "Nginx Status:"
systemctl status nginx --no-pager
echo ""
echo "CPU Usage:"
top -bn1 | head -20
echo ""
echo "================================================"
echo "Access your application at: http://82.25.105.18"
echo "================================================"
