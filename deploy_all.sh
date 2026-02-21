#!/bin/bash
# Complete deployment script for Ironman to Raspberry Pi

PI_USER="raspberrypi"
PI_HOST="192.168.1.132"
PI_PATH="~/Ironman"

echo "🚀 Complete Ironman Deployment to Raspberry Pi 5"
echo "================================================"
echo ""
echo "Target: ${PI_USER}@${PI_HOST}"
echo ""

# Step 1: Transfer files
echo "📦 Step 1: Transferring files..."
echo "   This will take 1-2 minutes..."
echo "   You'll be asked for password: kavin@2006"
echo ""

rsync -avz --progress \
    --exclude 'venv/' \
    --exclude '__pycache__/' \
    --exclude '*.pyc' \
    --exclude '.git/' \
    --exclude '.DS_Store' \
    --exclude 'samples/temp_captures/' \
    ./ ${PI_USER}@${PI_HOST}:${PI_PATH}/

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Files transferred successfully!"
    echo ""
    echo "📋 Step 2: Setting up on Raspberry Pi..."
    echo ""
    
    # Step 2: Run setup on Pi
    ssh ${PI_USER}@${PI_HOST} << 'ENDSSH'
cd ~/Ironman
echo "Running setup script..."
chmod +x setup_pi.sh
./setup_pi.sh
echo ""
echo "✅ Setup complete!"
echo ""
echo "To run the system:"
echo "  cd ~/Ironman/src"
echo "  source ../venv/bin/activate"
echo "  python3 main.py"
ENDSSH

    echo ""
    echo "🎉 Deployment complete!"
else
    echo ""
    echo "❌ File transfer failed!"
    echo "   Please check your connection and try again."
    exit 1
fi

