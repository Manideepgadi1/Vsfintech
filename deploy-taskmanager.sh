#!/bin/bash

# Task Manager Deployment Script
# Safely deploy Task Manager without affecting other VS Fintech apps
# Usage: bash deploy-taskmanager.sh

set -e  # Exit on error

echo "=================================================="
echo "   VS FINTECH - TASK MANAGER DEPLOYMENT"
echo "=================================================="
echo ""

# Check prerequisites
echo "Checking prerequisites..."

# Check PostgreSQL
if ! command -v psql &> /dev/null; then
    print_error "PostgreSQL is not installed!"
    echo ""
    echo "Install PostgreSQL first:"
    echo "  apt-get update"
    echo "  apt-get install postgresql postgresql-contrib -y"
    echo "  systemctl start postgresql"
    echo "  systemctl enable postgresql"
    echo ""
    exit 1
fi
print_success "PostgreSQL is installed"

# Check Node.js
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed!"
    echo ""
    echo "Install Node.js first:"
    echo "  curl -fsSL https://deb.nodesource.com/setup_18.x | bash -"
    echo "  apt-get install -y nodejs"
    echo ""
    exit 1
fi
NODE_VERSION=$(node --version)
print_success "Node.js $NODE_VERSION is installed"

# Check PM2
if ! command -v pm2 &> /dev/null; then
    print_error "PM2 is not installed!"
    echo ""
    echo "Install PM2 first:"
    echo "  npm install -g pm2"
    echo ""
    exit 1
fi
print_success "PM2 is installed"

# Check Nginx
if ! command -v nginx &> /dev/null; then
    print_error "Nginx is not installed!"
    echo ""
    echo "Install Nginx first:"
    echo "  apt-get install nginx -y"
    echo "  systemctl start nginx"
    echo "  systemctl enable nginx"
    echo ""
    exit 1
fi
print_success "Nginx is installed"

echo ""

# Configuration
APP_NAME="taskmanager"
BACKEND_PORT=5001
DOMAIN="taskmanager.vsfintech.com"
BACKEND_DIR="/var/www/taskmanager/backend"
FRONTEND_DIR="/var/www/taskmanager/frontend"
DB_NAME="taskmanager"
DB_USER="taskmgr_user"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run as root"
    exit 1
fi

echo "Step 1: Creating Application Directories"
mkdir -p $BACKEND_DIR
mkdir -p $FRONTEND_DIR
mkdir -p /backups/taskmanager
print_success "Directories created"

echo ""
echo "Step 2: Database Setup"
echo "Creating database and user..."

# Check if database exists
DB_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")

if [ "$DB_EXISTS" = "1" ]; then
    print_warning "Database '$DB_NAME' already exists. Skipping creation."
else
    sudo -u postgres psql << EOF
CREATE DATABASE $DB_NAME;
CREATE USER $DB_USER WITH ENCRYPTED PASSWORD '$(openssl rand -base64 32)';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
EOF
    print_success "Database and user created"
    print_warning "IMPORTANT: Save the database password from above!"
fi

echo ""
echo "Step 3: Backend Setup"
if [ -d "$BACKEND_DIR/node_modules" ]; then
    print_warning "Backend already installed. Updating..."
    cd $BACKEND_DIR
    npm install --production
else
    print_warning "Please upload backend files to $BACKEND_DIR"
    print_warning "Then run: cd $BACKEND_DIR && npm install --production"
fi

echo ""
echo "Step 4: Creating .env file"
if [ ! -f "$BACKEND_DIR/.env" ]; then
    JWT_SECRET=$(openssl rand -base64 32)
    cat > $BACKEND_DIR/.env << EOF
# Database
DATABASE_URL=postgresql://$DB_USER:YOUR_DB_PASSWORD_HERE@localhost:5432/$DB_NAME

# Server
PORT=$BACKEND_PORT
NODE_ENV=production

# JWT
JWT_SECRET=$JWT_SECRET
JWT_EXPIRES_IN=7d

# Frontend
FRONTEND_URL=https://$DOMAIN
CORS_ORIGIN=https://$DOMAIN

# SMTP (Update with your credentials)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=taskmanager@vsfintech.com
SMTP_PASS=YOUR_SMTP_PASSWORD_HERE
SMTP_FROM=taskmanager@vsfintech.com
EOF
    print_success ".env file created"
    print_warning "IMPORTANT: Edit $BACKEND_DIR/.env with correct DATABASE_URL password and SMTP credentials"
else
    print_warning ".env file already exists. Skipping."
fi

echo ""
echo "Step 5: Nginx Configuration"
cat > /etc/nginx/sites-available/taskmanager.conf << 'EOF'
# Task Manager - taskmanager.vsfintech.com
server {
    listen 80;
    server_name taskmanager.vsfintech.com tasks.vsfintech.com;

    # Frontend - serve static files
    location / {
        root /var/www/taskmanager/frontend;
        try_files $uri $uri/ /index.html;
        
        # Security headers
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
    }

    # Backend API - proxy to Node.js
    location /api {
        proxy_pass http://localhost:5001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # Static assets caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        root /var/www/taskmanager/frontend;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Logs
    access_log /var/log/nginx/taskmanager-access.log;
    error_log /var/log/nginx/taskmanager-error.log;
}
EOF

# Enable site
if [ ! -L /etc/nginx/sites-enabled/taskmanager.conf ]; then
    ln -s /etc/nginx/sites-available/taskmanager.conf /etc/nginx/sites-enabled/
    print_success "Nginx site enabled"
fi

# Test nginx config
if nginx -t; then
    print_success "Nginx configuration is valid"
    nginx -s reload
    print_success "Nginx reloaded"
else
    print_error "Nginx configuration test failed"
    exit 1
fi

echo ""
echo "Step 6: Firewall Configuration"
# Ensure backend port is not publicly accessible
ufw deny $BACKEND_PORT/tcp 2>/dev/null || true
print_success "Firewall configured (port $BACKEND_PORT blocked from public)"

echo ""
echo "Step 7: Backup Script Setup"
cat > /usr/local/bin/backup-taskmanager.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/backups/taskmanager"
DATE=$(date +%Y%m%d-%H%M%S)
mkdir -p $BACKUP_DIR

# Backup database
pg_dump -U taskmgr_user -Fc taskmanager > $BACKUP_DIR/taskmanager-$DATE.dump

# Keep only last 7 days
find $BACKUP_DIR -name "taskmanager-*.dump" -mtime +7 -delete

echo "Backup completed: taskmanager-$DATE.dump"
EOF

chmod +x /usr/local/bin/backup-taskmanager.sh
print_success "Backup script created"

echo ""
echo "Step 8: SSL Certificate"
print_warning "To enable HTTPS, run: certbot --nginx -d $DOMAIN"

echo ""
echo "=================================================="
echo "   DEPLOYMENT PREPARATION COMPLETE"
echo "=================================================="
echo ""
echo "NEXT STEPS:"
echo ""
echo "1. Update database password in: $BACKEND_DIR/.env"
echo "2. Update SMTP credentials in: $BACKEND_DIR/.env"
echo "3. Upload backend code to: $BACKEND_DIR"
echo "4. Upload frontend build to: $FRONTEND_DIR"
echo "5. Run database migrations:"
echo "   cd $BACKEND_DIR && npm run migrate"
echo ""
echo "6. Start with PM2:"
echo "   cd $BACKEND_DIR"
echo "   pm2 start server.js --name $APP_NAME --env production"
echo "   pm2 save"
echo ""
echo "7. Setup SSL:"
echo "   certbot --nginx -d $DOMAIN"
echo ""
echo "8. Configure DNS:"
echo "   Add A record: $DOMAIN → 82.25.105.18"
echo ""
echo "9. Test deployment:"
echo "   curl https://$DOMAIN"
echo "   curl https://$DOMAIN/api/health"
echo ""
echo "10. Setup automated backups (optional):"
echo "    crontab -e"
echo "    Add: 0 2 * * * /usr/local/bin/backup-taskmanager.sh"
echo ""
print_success "Deployment script completed successfully!"
echo ""
