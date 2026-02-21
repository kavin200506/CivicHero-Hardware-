#!/bin/bash

# CivicHero Ironman - Raspberry Pi 5 Setup Script
# This script automates the setup process for deploying on Raspberry Pi 5

set -e  # Exit on error

echo "🚀 CivicHero Ironman - Raspberry Pi 5 Setup"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running on Raspberry Pi
if [ ! -f /proc/device-tree/model ] || ! grep -q "Raspberry Pi" /proc/device-tree/model; then
    echo -e "${YELLOW}⚠️  Warning: This doesn't appear to be a Raspberry Pi${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Update system
echo -e "${GREEN}📦 Updating system packages...${NC}"
sudo apt update
sudo apt upgrade -y

# Install essential packages
echo -e "${GREEN}📦 Installing essential packages...${NC}"
sudo apt install -y \
    python3-pip \
    python3-venv \
    git \
    build-essential \
    libopencv-dev \
    python3-opencv \
    libatlas-base-dev \
    v4l-utils \
    ffmpeg

# Install camera libraries (for Pi Camera Module)
echo -e "${GREEN}📦 Installing camera libraries...${NC}"
sudo apt install -y python3-picamera2 || echo -e "${YELLOW}⚠️  picamera2 not available, skipping...${NC}"

# Create virtual environment
echo -e "${GREEN}🐍 Creating Python virtual environment...${NC}"
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo -e "${GREEN}✅ Virtual environment created${NC}"
else
    echo -e "${YELLOW}⚠️  Virtual environment already exists${NC}"
fi

# Activate virtual environment
echo -e "${GREEN}🔌 Activating virtual environment...${NC}"
source venv/bin/activate

# Upgrade pip
echo -e "${GREEN}⬆️  Upgrading pip...${NC}"
pip install --upgrade pip

# Install Python dependencies
echo -e "${GREEN}📚 Installing Python dependencies...${NC}"
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
elif [ -f "reeq.txt" ]; then
    pip install -r reeq.txt
    # Install picamera2 separately if needed
    pip install picamera2 || echo -e "${YELLOW}⚠️  picamera2 installation failed (may not be needed)${NC}"
else
    echo -e "${RED}❌ No requirements file found!${NC}"
    exit 1
fi

# Check for service account key
echo -e "${GREEN}🔑 Checking Firebase credentials...${NC}"
if [ ! -f "serviceAccountKey.json" ]; then
    echo -e "${RED}❌ serviceAccountKey.json not found!${NC}"
    echo -e "${YELLOW}⚠️  Please add your Firebase service account key to continue${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Firebase credentials found${NC}"
    # Set secure permissions
    chmod 600 serviceAccountKey.json
fi

# Check for YOLO model
echo -e "${GREEN}🤖 Checking YOLO model...${NC}"
if [ ! -f "ultra.pt" ]; then
    echo -e "${RED}❌ ultra.pt not found!${NC}"
    echo -e "${YELLOW}⚠️  Please add your YOLO model file to continue${NC}"
    exit 1
else
    echo -e "${GREEN}✅ YOLO model found${NC}"
fi

# Create necessary directories
echo -e "${GREEN}📁 Creating necessary directories...${NC}"
mkdir -p src/samples/temp_captures
mkdir -p logs

# Set up systemd service (optional)
echo ""
read -p "📋 Do you want to set up auto-start service? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}⚙️  Setting up systemd service...${NC}"
    
    # Get current directory (absolute path)
    CURRENT_DIR=$(pwd)
    USER_NAME=$(whoami)
    
    # Create service file
    SERVICE_FILE="/etc/systemd/system/civichero-ironman.service"
    
    sudo tee $SERVICE_FILE > /dev/null <<EOF
[Unit]
Description=CivicHero Ironman Edge Detection System
After=network.target

[Service]
Type=simple
User=$USER_NAME
WorkingDirectory=$CURRENT_DIR/src
Environment="PATH=$CURRENT_DIR/venv/bin"
ExecStart=$CURRENT_DIR/venv/bin/python3 main.py
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

    # Reload systemd
    sudo systemctl daemon-reload
    
    echo -e "${GREEN}✅ Service file created at $SERVICE_FILE${NC}"
    echo ""
    echo -e "${YELLOW}📝 To enable and start the service, run:${NC}"
    echo -e "   ${GREEN}sudo systemctl enable civichero-ironman.service${NC}"
    echo -e "   ${GREEN}sudo systemctl start civichero-ironman.service${NC}"
    echo ""
    echo -e "${YELLOW}📝 To check status:${NC}"
    echo -e "   ${GREEN}sudo systemctl status civichero-ironman.service${NC}"
    echo ""
    echo -e "${YELLOW}📝 To view logs:${NC}"
    echo -e "   ${GREEN}sudo journalctl -u civichero-ironman.service -f${NC}"
fi

# Summary
echo ""
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo ""
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. Edit src/main.py to configure:"
echo "   - CAMERA_ID (from Firebase Admin Dashboard)"
echo "   - VIDEO_SOURCE (0 for webcam, RTSP URL, or file path)"
echo ""
echo "2. Configure camera ROIs in Admin Dashboard"
echo ""
echo "3. Test the system:"
echo "   ${GREEN}cd src && python3 main.py${NC}"
echo ""
echo "4. If service was set up, enable it:"
echo "   ${GREEN}sudo systemctl enable civichero-ironman.service${NC}"
echo "   ${GREEN}sudo systemctl start civichero-ironman.service${NC}"
echo ""
echo -e "${GREEN}🎉 Ready to deploy!${NC}"




