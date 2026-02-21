#!/bin/bash
# Quick deployment script - requires password input

echo "🚀 Deploying Ironman to Raspberry Pi..."
echo ""
echo "This will transfer files to raspberrypi@192.168.1.132"
echo "You'll be asked for password: kavin@2006"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."

cd /Users/kavin/Development/projects/1/Ironman

echo ""
echo "📦 Transferring files..."
scp -r . raspberrypi@192.168.1.132:~/Ironman

echo ""
echo "✅ Files transferred!"
echo ""
echo "Next steps:"
echo "1. SSH into Pi: ssh raspberrypi@192.168.1.132"
echo "2. Run setup: cd ~/Ironman && chmod +x setup_pi.sh && ./setup_pi.sh"
echo "3. Test: cd ~/Ironman/src && source ../venv/bin/activate && python3 main.py"
