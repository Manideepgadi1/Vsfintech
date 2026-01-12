# Task Manager - Safe Deployment Guide

## Overview
Deploy Task Manager app to Hostinger VPS without affecting existing VS Fintech tools.

## Prerequisites Check & Installation

### Check What's Already Installed
```bash
# Check PostgreSQL
which psql
psql --version

# Check Node.js
node --version
npm --version

# Check PM2
pm2 --version

# Check Nginx
nginx -v
```

### Install PostgreSQL (if not installed)
```bash
# Update package list
apt-get update

# Install PostgreSQL
apt-get install postgresql postgresql-contrib -y

# Start PostgreSQL service
systemctl start postgresql
systemctl enable postgresql

# Verify installation
sudo -u postgres psql --version

# Set postgres user password (optional but recommended)
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'your_strong_postgres_password';"
```

### Install Node.js (if not installed or old version)
```bash
# Install Node.js 18.x LTS
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Verify
node --version
npm --version
```

### Install PM2 (if not installed)
```bash
npm install -g pm2

# Verify
pm2 --version
```

### Install Nginx (if not installed)
```bash
apt-get install nginx -y

# Start and enable
systemctl start nginx
systemctl enable nginx

# Verify
nginx -v
```

## Configuration Details

### Domain & Port
- **Subdomain**: `taskmanager.vsfintech.com` (or `tasks.vsfintech.com`)
- **Backend Port**: `5001` (free port, different from other apps)
- **Frontend**: Static files served by nginx
- **API Endpoint**: `/api` → proxied to `localhost:5001`

### Database Setup
```bash
# Create dedicated database and user
sudo -u postgres psql

CREATE DATABASE taskmanager;
CREATE USER taskmgr_user WITH ENCRYPTED PASSWORD 'YOUR_STRONG_PASSWORD_HERE';
GRANT ALL PRIVILEGES ON DATABASE taskmanager TO taskmgr_user;
\q
```

### Environment Variables
Create `.env` file in task manager backend directory:

```env
# Database
DATABASE_URL=postgresql://taskmgr_user:YOUR_STRONG_PASSWORD_HERE@localhost:5432/taskmanager

# Server
PORT=5001
NODE_ENV=production

# JWT
JWT_SECRET=YOUR_UNIQUE_JWT_SECRET_HERE_MIN_32_CHARS
JWT_EXPIRES_IN=7d

# Frontend
FRONTEND_URL=https://taskmanager.vsfintech.com
CORS_ORIGIN=https://taskmanager.vsfintech.com

# SMTP (App-specific)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=taskmanager@vsfintech.com
SMTP_PASS=YOUR_APP_SPECIFIC_PASSWORD
SMTP_FROM=taskmanager@vsfintech.com
```

## Deployment Steps

### 1. Upload Application Files
```bash
# Connect to VPS
ssh root@82.25.105.18

# Create app directory
mkdir -p /var/www/taskmanager
cd /var/www/taskmanager

# Upload files (from local machine)
# scp -r taskmanager-backend/* root@82.25.105.18:/var/www/taskmanager/backend/
# scp -r taskmanager-frontend/dist/* root@82.25.105.18:/var/www/taskmanager/frontend/
```

### 2. Backend Setup
```bash
cd /var/www/taskmanager/backend

# Install dependencies
npm install --production

# Create .env file with configuration above
nano .env

# Run database migrations
npm run migrate
# or
npx prisma migrate deploy
# or
node migrate.js
```

### 3. Frontend Build & Deploy
```bash
# On local machine, build frontend
cd taskmanager-frontend
npm run build

# Upload dist folder to VPS
scp -r dist/* root@82.25.105.18:/var/www/taskmanager/frontend/
```

### 4. Nginx Configuration
```bash
# Create nginx config
nano /etc/nginx/sites-available/taskmanager.conf
```

Add this configuration:

```nginx
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
```

Enable site and test:
```bash
# Enable site
ln -s /etc/nginx/sites-available/taskmanager.conf /etc/nginx/sites-enabled/

# Test nginx config
nginx -t

# Reload nginx (SAFE - won't affect other sites)
nginx -s reload
```

### 5. SSL Certificate (Let's Encrypt)
```bash
# Install certbot if not already installed
apt-get update
apt-get install certbot python3-certbot-nginx -y

# Issue certificate for task manager subdomain
certbot --nginx -d taskmanager.vsfintech.com -d tasks.vsfintech.com

# Auto-renewal is configured by certbot
```

### 6. PM2 Process Management
```bash
cd /var/www/taskmanager/backend

# Start with PM2
pm2 start server.js --name taskmanager --env production

# Configure startup script (if not already done)
pm2 startup
pm2 save

# View logs
pm2 logs taskmanager

# Monitor
pm2 monit
```

### 7. Firewall Configuration
```bash
# Check current firewall rules
ufw status

# Ensure only 80/443 are public (should already be configured)
# Backend port 5001 should NOT be publicly accessible
ufw allow 80/tcp
ufw allow 443/tcp
ufw deny 5001/tcp
```

## Database Backup

### Manual Backup
```bash
# Create backup
pg_dump -U taskmgr_user -Fc taskmanager > /backups/taskmanager-$(date +%Y%m%d-%H%M%S).dump

# Restore if needed
pg_restore -U taskmgr_user -d taskmanager /backups/taskmanager-YYYYMMDD-HHMMSS.dump
```

### Automated Backup Script
```bash
# Create backup script
nano /usr/local/bin/backup-taskmanager.sh
```

```bash
#!/bin/bash
BACKUP_DIR="/backups/taskmanager"
DATE=$(date +%Y%m%d-%H%M%S)
mkdir -p $BACKUP_DIR

# Backup database
pg_dump -U taskmgr_user -Fc taskmanager > $BACKUP_DIR/taskmanager-$DATE.dump

# Keep only last 7 days
find $BACKUP_DIR -name "taskmanager-*.dump" -mtime +7 -delete

echo "Backup completed: taskmanager-$DATE.dump"
```

```bash
# Make executable
chmod +x /usr/local/bin/backup-taskmanager.sh

# Add to crontab (daily at 2 AM)
crontab -e
# Add: 0 2 * * * /usr/local/bin/backup-taskmanager.sh
```

## Testing & Verification

### 1. DNS Configuration
Before going live, add DNS A record:
- **Type**: A
- **Name**: taskmanager (or tasks)
- **Value**: 82.25.105.18
- **TTL**: 3600

### 2. Staging Test
```bash
# Test on staging subdomain first
# Add staging.taskmanager.vsfintech.com to nginx config
# Test all functionality before pointing production DNS
```

### 3. Health Checks
```bash
# Check backend is running
curl http://localhost:5001/api/health

# Check frontend is served
curl https://taskmanager.vsfintech.com

# Check API through nginx
curl https://taskmanager.vsfintech.com/api/health

# Check PM2 status
pm2 status taskmanager

# Check logs
pm2 logs taskmanager --lines 50
tail -f /var/log/nginx/taskmanager-error.log
```

## Monitoring & Maintenance

### PM2 Commands
```bash
# Status
pm2 status taskmanager

# Restart
pm2 restart taskmanager

# Stop (use carefully)
pm2 stop taskmanager

# View logs
pm2 logs taskmanager

# Real-time monitoring
pm2 monit
```

### Log Management
```bash
# View nginx logs
tail -f /var/log/nginx/taskmanager-access.log
tail -f /var/log/nginx/taskmanager-error.log

# PM2 logs
pm2 logs taskmanager --lines 100

# Clear old logs
pm2 flush taskmanager
```

## Rollback Plan

If something goes wrong:

### 1. Stop Task Manager (keeps other apps running)
```bash
pm2 stop taskmanager
```

### 2. Disable Nginx Site
```bash
rm /etc/nginx/sites-enabled/taskmanager.conf
nginx -s reload
```

### 3. Restore Database (if needed)
```bash
pg_restore -U taskmgr_user -d taskmanager /backups/taskmanager-BACKUP_FILE.dump
```

## Security Checklist

- [ ] Database uses strong password
- [ ] JWT secret is unique and strong (min 32 chars)
- [ ] SMTP credentials are app-specific
- [ ] Port 5001 is NOT publicly accessible
- [ ] SSL certificate is installed and working
- [ ] CORS is configured for correct origin
- [ ] Environment variables are not committed to git
- [ ] Regular backups are scheduled
- [ ] Logs are being rotated
- [ ] PM2 process is monitored

## Quick Commands Reference

```bash
# Start application
pm2 start taskmanager

# Restart application
pm2 restart taskmanager

# View logs
pm2 logs taskmanager

# Database backup
pg_dump -U taskmgr_user -Fc taskmanager > backup.dump

# Nginx reload (safe)
nginx -s reload

# Check PM2 status
pm2 status

# Monitor all processes
pm2 monit
```

## Troubleshooting

### Backend not starting
```bash
# Check logs
pm2 logs taskmanager --err

# Check environment variables
cat /var/www/taskmanager/backend/.env

# Check database connection
psql -U taskmgr_user -d taskmanager -c "SELECT 1;"
```

### Frontend not loading
```bash
# Check nginx error log
tail -f /var/log/nginx/taskmanager-error.log

# Check file permissions
ls -la /var/www/taskmanager/frontend/

# Test nginx config
nginx -t
```

### API requests failing
```bash
# Check backend is running
pm2 status taskmanager

# Test backend directly
curl http://localhost:5001/api/health

# Check nginx proxy
curl -I https://taskmanager.vsfintech.com/api/health
```

## Contact & Support

For issues specific to Task Manager deployment:
- Check PM2 logs: `pm2 logs taskmanager`
- Check Nginx logs: `/var/log/nginx/taskmanager-error.log`
- Verify database: `psql -U taskmgr_user -d taskmanager`

## Notes

- This deployment is completely isolated from other VS Fintech apps
- Uses separate port (5001), database, and PM2 process
- Can be stopped/restarted without affecting other services
- Has its own nginx configuration and logs
- DNS points to same VPS but uses subdomain routing
