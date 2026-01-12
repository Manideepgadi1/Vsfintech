#!/bin/bash

# Install Prerequisites for Task Manager on Ubuntu/Debian VPS
# Run this FIRST if PostgreSQL, Node.js, PM2, or Nginx are not installed

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run as root"
    exit 1
fi

echo "=================================================="
echo "   INSTALLING PREREQUISITES FOR TASK MANAGER"
echo "=================================================="
echo ""

# Update system
print_info "Updating system packages..."
apt-get update
print_success "System updated"

echo ""
echo "1. Installing PostgreSQL..."
if command -v psql &> /dev/null; then
    print_info "PostgreSQL is already installed: $(psql --version)"
else
    apt-get install postgresql postgresql-contrib -y
    systemctl start postgresql
    systemctl enable postgresql
    print_success "PostgreSQL installed and started"
    
    # Set postgres password
    POSTGRES_PASS=$(openssl rand -base64 16)
    sudo -u postgres psql -c "ALTER USER postgres PASSWORD '$POSTGRES_PASS';"
    print_success "PostgreSQL password set"
    print_info "Save this password: $POSTGRES_PASS"
fi

echo ""
echo "2. Installing Node.js 18.x LTS..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_info "Node.js is already installed: $NODE_VERSION"
    
    # Check if version is old
    MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$MAJOR_VERSION" -lt 16 ]; then
        print_info "Node.js version is old. Installing newer version..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
        apt-get install -y nodejs
        print_success "Node.js updated to $(node --version)"
    fi
else
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
    print_success "Node.js installed: $(node --version)"
fi

echo ""
echo "3. Installing PM2..."
if command -v pm2 &> /dev/null; then
    print_info "PM2 is already installed: $(pm2 --version)"
else
    npm install -g pm2
    print_success "PM2 installed: $(pm2 --version)"
    
    # Setup PM2 startup
    pm2 startup
    print_success "PM2 startup configured"
fi

echo ""
echo "4. Installing Nginx..."
if command -v nginx &> /dev/null; then
    print_info "Nginx is already installed: $(nginx -v 2>&1)"
else
    apt-get install nginx -y
    systemctl start nginx
    systemctl enable nginx
    print_success "Nginx installed and started"
fi

echo ""
echo "5. Installing Certbot (for SSL)..."
if command -v certbot &> /dev/null; then
    print_info "Certbot is already installed"
else
    apt-get install certbot python3-certbot-nginx -y
    print_success "Certbot installed"
fi

echo ""
echo "6. Installing additional tools..."
apt-get install git curl wget unzip -y
print_success "Additional tools installed"

echo ""
echo "7. Configuring firewall..."
if command -v ufw &> /dev/null; then
    # Allow SSH
    ufw allow OpenSSH || ufw allow 22/tcp
    # Allow HTTP and HTTPS
    ufw allow 80/tcp
    ufw allow 443/tcp
    # Enable firewall if not already enabled
    echo "y" | ufw enable 2>/dev/null || true
    print_success "Firewall configured"
else
    print_info "UFW firewall not found, skipping"
fi

echo ""
echo "=================================================="
echo "   PREREQUISITES INSTALLATION COMPLETE"
echo "=================================================="
echo ""
echo "Installed versions:"
echo "  PostgreSQL: $(psql --version)"
echo "  Node.js: $(node --version)"
echo "  npm: $(npm --version)"
echo "  PM2: $(pm2 --version)"
echo "  Nginx: $(nginx -v 2>&1)"
echo "  Certbot: $(certbot --version 2>&1 | head -1)"
echo ""
echo "Next steps:"
echo "  1. Run: bash deploy-taskmanager.sh"
echo "  2. Follow the deployment steps in TASKMANAGER-DEPLOYMENT-GUIDE.md"
echo ""
print_success "System is ready for Task Manager deployment!"
