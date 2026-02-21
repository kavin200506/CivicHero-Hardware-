#!/bin/bash

# CivicHero Ironman - Run Script
# This script activates the virtual environment and runs the detection system

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Navigate to Ironman directory
cd "$SCRIPT_DIR"

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found!"
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo "Installing dependencies..."
    source venv/bin/activate
    pip install --upgrade pip
    pip install ultralytics opencv-python firebase-admin numpy onnxruntime
    echo "✅ Virtual environment created and dependencies installed!"
fi

# Activate virtual environment
source venv/bin/activate

# Run the main script
cd src
python3 main.py


