#!/bin/bash

# Deploy Ironman to Raspberry Pi 5
# This script transfers files and sets up the system on the Pi

PI_USER="raspberrypi"
PI_HOST="192.168.1.132"
PI_PATH="~/Ironman"

echo "🚀 Deploying CivicHero Ironman to Raspberry Pi 5"
echo "=================================================="
echo ""
echo "Target: ${PI_USER}@${PI_HOST}"
echo "Destination: ${PI_PATH}"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if we're in the Ironman directory
if [ ! -f "${SCRIPT_DIR}/src/main.py" ]; then
    echo "❌ Error: Please run this script from the Ironman directory"
    exit 1
fi

echo "📦 Step 1: Transferring files to Raspberry Pi..."
echo "   This may take a few minutes..."
echo ""

# Transfer files (excluding venv, __pycache__, etc.)
rsync -avz --progress \
    --exclude 'venv/' \
    --exclude '__pycache__/' \
    --exclude '*.pyc' \
    --exclude '.git/' \
    --exclude '.DS_Store' \
    --exclude 'samples/temp_captures/' \
    "${SCRIPT_DIR}/" "${PI_USER}@${PI_HOST}:${PI_PATH}/"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Files transferred successfully!"
    echo ""
    echo "📋 Step 2: Setting up on Raspberry Pi..."
    echo ""
    
    # Run setup on Pi
    ssh "${PI_USER}@${PI_HOST}" << 'ENDSSH'
cd ~/Ironman
echo "Running setup script..."
chmod +x setup_pi.sh
./setup_pi.sh
echo ""
echo "✅ Setup complete!"
echo ""
echo "To run the system:"
echo "  cd ~/Ironman/src"
echo "  python3 main.py"
ENDSSH

    echo ""
    echo "🎉 Deployment complete!"
    echo ""
    echo "Next steps:"
    echo "  1. SSH into Pi: ssh ${PI_USER}@${PI_HOST}"
    echo "  2. Run: cd ~/Ironman/src && python3 main.py"
    echo ""
else
    echo ""
    echo "❌ File transfer failed!"
    echo "   Please check:"
    echo "   - SSH connection works: ssh ${PI_USER}@${PI_HOST}"
    echo "   - Pi is on the network"
    echo "   - Username is correct (default: pi)"
    exit 1
fi

