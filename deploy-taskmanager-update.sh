#!/bin/bash

# Task Manager Team Members & Email Update Deployment
echo "🚀 Deploying Task Manager updates..."

# Pull latest changes
cd /root/Vsfintech
git pull origin main

# Run database migration
echo "📊 Running database migration..."
cd TASK/backend
node run-migration.js

# Restart the backend
echo "♻️ Restarting Task Manager backend..."
pm2 restart task-manager-backend

# Copy frontend build
echo "📦 Deploying frontend..."
cd /root/Vsfintech/TASK/frontend
rm -rf /var/www/html/taskmanager/*
cp -r dist/* /var/www/html/taskmanager/

echo "✅ Deployment complete!"
echo "📧 New features:"
echo "   - Welcome emails sent when creating users"
echo "   - Team members field for collaborative tasks"
echo ""
echo "🔍 Check status: pm2 status"
