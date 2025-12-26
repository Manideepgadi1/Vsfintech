#!/bin/bash
# Comprehensive deployment script for all VS Fintech applications

set -e

echo "================================================"
echo "VS Fintech Multi-App Deployment Script"
echo "================================================"

# Port assignments
RIGHT_SECTOR_PORT=3001
BAR_LINE_BACKEND_PORT=8001
HEATMAP_BACKEND_PORT=8002
RISK_REWARD_PORT=5000
RISK_RETURN_PORT=5001
RISKOMETER_PORT=5002
MULTICHART_PORT=3002
FUNDSCREENER_PORT=3003
ALPHANIFTY_BACKEND_PORT=8003

BASE_DIR="/var/www/vsfintech"

# Function to setup Node.js frontend app
setup_node_frontend() {
    local app_name=$1
    local app_dir=$2
    local port=$3
    
    echo "Setting up $app_name frontend..."
    cd "$app_dir"
    
    if [ -f "package.json" ]; then
        npm install
        npm run build || echo "Build command not found, using vite build"
        npx vite build --base=/$app_name/ || echo "Could not build with vite"
    fi
}

# Function to setup Python Flask/FastAPI backend
setup_python_backend() {
    local app_name=$1
    local app_dir=$2
    local port=$3
    
    echo "Setting up $app_name Python backend..."
    cd "$app_dir"
    
    # Create virtual environment if it doesn't exist
    if [ ! -d "venv" ]; then
        python3 -m venv venv
    fi
    
    source venv/bin/activate
    
    if [ -f "requirements.txt" ]; then
        pip install --upgrade pip
        pip install -r requirements.txt
        pip install gunicorn
    fi
    
    deactivate
}

# 1. Right Sector (HTML dashboard)
echo "1/9 Setting up Right Sector..."
cd "$BASE_DIR/Right-Sector"
mkdir -p dist
cp dashboard.html dist/index.html
cp -r data dist/ 2>/dev/null || true
cp *.json dist/ 2>/dev/null || true

# 2. Bar-Line (React + FastAPI)
echo "2/9 Setting up Bar-Line (Right Amount)..."
setup_node_frontend "bar-line" "$BASE_DIR/Bar-Line" $RIGHT_SECTOR_PORT
if [ -d "$BASE_DIR/Bar-Line/backend" ]; then
    setup_python_backend "bar-line-backend" "$BASE_DIR/Bar-Line/backend" $BAR_LINE_BACKEND_PORT
fi

# 3. Heatmap (React + FastAPI)
echo "3/9 Setting up Heatmap (Sector Heatmap)..."
if [ -d "$BASE_DIR/Heatmap/frontend" ]; then
    setup_node_frontend "heatmap" "$BASE_DIR/Heatmap/frontend" $HEATMAP_BACKEND_PORT
fi
if [ -d "$BASE_DIR/Heatmap/backend" ]; then
    setup_python_backend "heatmap-backend" "$BASE_DIR/Heatmap/backend" $HEATMAP_BACKEND_PORT
fi

# 4. Risk-Reward (Flask)
echo "4/9 Setting up Risk-Reward..."
setup_python_backend "risk-reward" "$BASE_DIR/Risk-Reward" $RISK_REWARD_PORT

# 5. Risk-Return
echo "5/9 Setting up Risk-Return..."
cd "$BASE_DIR/Risk-Return"
if [ -f "package.json" ]; then
    setup_node_frontend "risk-return" "$BASE_DIR/Risk-Return" $RISK_RETURN_PORT
else
    setup_python_backend "risk-return" "$BASE_DIR/Risk-Return" $RISK_RETURN_PORT
fi

# 6. Riskometer
echo "6/9 Setting up Riskometer..."
cd "$BASE_DIR/Riskometer"
if [ -f "package.json" ]; then
    setup_node_frontend "riskometer" "$BASE_DIR/Riskometer" $RISKOMETER_PORT
else
    setup_python_backend "riskometer" "$BASE_DIR/Riskometer" $RISKOMETER_PORT
fi

# 7. Multichart
echo "7/9 Setting up Multichart..."
cd "$BASE_DIR/Multichart"
if [ -f "package.json" ]; then
    setup_node_frontend "multichart" "$BASE_DIR/Multichart" $MULTICHART_PORT
else
    setup_python_backend "multichart" "$BASE_DIR/Multichart" $MULTICHART_PORT
fi

# 8. Fundscreener (PMS Screener)
echo "8/9 Setting up Fundscreener (PMS Screener)..."
cd "$BASE_DIR/fundscreener"
if [ -f "package.json" ]; then
    setup_node_frontend "fundscreener" "$BASE_DIR/fundscreener" $FUNDSCREENER_PORT
else
    setup_python_backend "fundscreener" "$BASE_DIR/fundscreener" $FUNDSCREENER_PORT
fi

# 9. ALPHANIFTYY
echo "9/9 Setting up ALPHANIFTYY..."
setup_node_frontend "alphanifty" "$BASE_DIR/ALPHANIFTYY" $ALPHANIFTY_BACKEND_PORT
if [ -d "$BASE_DIR/ALPHANIFTYY/backend" ]; then
    setup_python_backend "alphanifty-backend" "$BASE_DIR/ALPHANIFTYY/backend" $ALPHANIFTY_BACKEND_PORT
fi

echo "================================================"
echo "All applications setup complete!"
echo "================================================"
echo ""
echo "Port assignments:"
echo "- Right Sector: Static HTML at /right-sector"
echo "- Bar-Line Backend: $BAR_LINE_BACKEND_PORT"
echo "- Heatmap Backend: $HEATMAP_BACKEND_PORT"
echo "- Risk-Reward: $RISK_REWARD_PORT"
echo "- Risk-Return: $RISK_RETURN_PORT"
echo "- Riskometer: $RISKOMETER_PORT"
echo "- Multichart: $MULTICHART_PORT"
echo "- Fundscreener: $FUNDSCREENER_PORT"
echo "- AlphaNifty Backend: $ALPHANIFTY_BACKEND_PORT"
