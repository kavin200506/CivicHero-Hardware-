# GPS-Based Location Detection for Pothole Complaints

Guide for using GPS to automatically detect and report the exact location where potholes occur.

## 🎯 What You Want

**Current**: Uses fixed camera location (set in Admin Dashboard)  
**Desired**: Use GPS to get the **actual location where pothole occurs**

---

## 📍 Two Scenarios

### Scenario 1: Fixed CCTV Camera
- Camera is fixed at one location
- Pothole detected in camera view
- **Location**: Should be camera location (or nearby)

### Scenario 2: Mobile/Portable Camera
- Camera moves (vehicle-mounted, handheld)
- Pothole detected while moving
- **Location**: Need real-time GPS to get exact location

---

## 🔧 Solution: Add GPS Module to Raspberry Pi 5

### Hardware Needed

1. **USB GPS Dongle** (Recommended - Easiest)
   - Plug-and-play
   - ~$10-30
   - Examples: U-blox, NEO-6M USB

2. **GPS Module with GPIO** (Advanced)
   - Connect to Pi GPIO pins
   - Requires wiring

---

## 🚀 Implementation: Add GPS Support

### Step 1: Install GPS on Raspberry Pi 5

```bash
# Install GPS tools
sudo apt update
sudo apt install -y gpsd gpsd-clients python3-gps

# Start GPS daemon
sudo systemctl start gpsd
sudo systemctl enable gpsd

# Test GPS
gpsmon
# Should show GPS coordinates
```

### Step 2: Create GPS Helper

Create `src/gps_helper.py`:

```python
"""
GPS Helper for Raspberry Pi 5
Gets real-time GPS coordinates
"""

import gps
import time
import threading

class GPSHelper:
    def __init__(self):
        self.session = None
        self.latitude = None
        self.longitude = None
        self.running = False
        self.thread = None
        
    def start(self):
        """Start GPS monitoring"""
        try:
            self.session = gps.gps(mode=gps.WATCH_ENABLE)
            self.running = True
            self.thread = threading.Thread(target=self._update_loop, daemon=True)
            self.thread.start()
            print("✅ GPS started")
        except Exception as e:
            print(f"⚠️  GPS not available: {e}")
            self.running = False
    
    def _update_loop(self):
        """Background thread to update GPS coordinates"""
        while self.running:
            try:
                report = self.session.next()
                if report['class'] == 'TPV':
                    if hasattr(report, 'lat') and hasattr(report, 'lon'):
                        self.latitude = report.lat
                        self.longitude = report.lon
            except Exception as e:
                time.sleep(1)
    
    def get_coordinates(self):
        """Get current GPS coordinates"""
        if self.latitude and self.longitude:
            return self.latitude, self.longitude
        return None, None
    
    def stop(self):
        """Stop GPS monitoring"""
        self.running = False
        if self.session:
            self.session.close()
```

### Step 3: Update main.py to Use GPS

Update `src/main.py`:

```python
# Add GPS import
try:
    from src.gps_helper import GPSHelper
    GPS_AVAILABLE = True
except ImportError:
    GPS_AVAILABLE = False
    print("⚠️  GPS not available")

# In main() function:

# Initialize GPS
gps_helper = None
if GPS_AVAILABLE:
    try:
        gps_helper = GPSHelper()
        gps_helper.start()
        time.sleep(2)  # Wait for GPS fix
    except Exception as e:
        print(f"GPS initialization failed: {e}")
        gps_helper = None

# In detection loop, when pothole detected:

if matched:
    # Get location
    if gps_helper:
        # Use GPS location (real-time)
        gps_lat, gps_lng = gps_helper.get_coordinates()
        if gps_lat and gps_lng:
            lat = gps_lat
            lng = gps_lng
            print(f"📍 Using GPS location: {lat}, {lng}")
        else:
            # Fallback to camera location
            lat = camera_config.get('latitude', 0.0)
            lng = camera_config.get('longitude', 0.0)
            print("⚠️  GPS not fixed, using camera location")
    else:
        # Use camera location (fallback)
        lat = camera_config.get('latitude', 0.0)
        lng = camera_config.get('longitude', 0.0)
    
    # Create incident with GPS location
    incident_data = {
        "latitude": lat,   # GPS location or camera location
        "longitude": lng,  # GPS location or camera location
        "address": f"GPS: {lat}, {lng}",  # Or use reverse geocoding
        ...
    }
```

---

## 🌐 Alternative: Network-Based Location (No GPS Hardware)

If you don't want to add GPS hardware, use network-based location:

### Option 1: IP Geolocation

```python
import requests

def get_location_from_ip():
    """Get approximate location from IP"""
    try:
        response = requests.get('http://ip-api.com/json/')
        data = response.json()
        if data['status'] == 'success':
            return data['lat'], data['lon']
    except:
        return None, None
```

**Accuracy**: 1-10km (not very accurate)

### Option 2: WiFi Positioning

```python
import subprocess
import requests

def get_location_from_wifi():
    """Get location from WiFi networks"""
    try:
        # Scan WiFi networks
        result = subprocess.run(['iwlist', 'scan'], capture_output=True, text=True)
        # Parse networks
        # Use Google WiFi Positioning API or similar
        # Requires API key
        return None, None
    except:
        return None, None
```

**Accuracy**: 10-50m (better than IP, but requires API)

---

## 🎯 Recommended Approach

### For Fixed CCTV Camera:

**Use Camera Location** (Current Method)
- ✅ Already implemented
- ✅ Accurate (you set exact location)
- ✅ No hardware needed
- ✅ Works immediately

**Why**: If camera is fixed, pothole location = camera location (or very close)

### For Mobile/Portable Camera:

**Use GPS Module**
- ✅ Real-time location
- ✅ Accurate (3-5m)
- ✅ Works anywhere
- ⚠️ Requires GPS hardware

---

## 📝 Complete Implementation

### Updated main.py with GPS:

```python
import cv2
import time
import os
import sys
import numpy as np

# GPS support
try:
    from src.gps_helper import GPSHelper
    GPS_AVAILABLE = True
except ImportError:
    GPS_AVAILABLE = False

from src.firebase_client import get_camera_config, create_incident, upload_incident_image
from src.roi_utils import get_roi_crop
from src.detectors.yolo_detector import YoloDetector
from src.detectors.brightness_detector import BrightnessDetector

def main():
    CAMERA_ID = "f47QoL9zBWtzs23FBjfo"
    VIDEO_SOURCE = 0  # USB webcam
    
    # Initialize GPS
    gps_helper = None
    if GPS_AVAILABLE:
        try:
            gps_helper = GPSHelper()
            gps_helper.start()
            print("📍 GPS initialized, waiting for fix...")
            time.sleep(3)  # Wait for GPS fix
        except Exception as e:
            print(f"⚠️  GPS not available: {e}")
    
    # Get camera config
    camera_config = get_camera_config(CAMERA_ID)
    if not camera_config:
        print("Failed to load camera config")
        return
    
    # Initialize detectors
    yolo_detector = YoloDetector("ultra.pt")
    
    # Video processing loop
    cap = cv2.VideoCapture(VIDEO_SOURCE)
    
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        
        # Detection logic...
        if pothole_detected:
            # Get location
            if gps_helper:
                lat, lng = gps_helper.get_coordinates()
                if not lat or not lng:
                    # Fallback to camera location
                    lat = camera_config.get('latitude', 0.0)
                    lng = camera_config.get('longitude', 0.0)
            else:
                # Use camera location
                lat = camera_config.get('latitude', 0.0)
                lng = camera_config.get('longitude', 0.0)
            
            # Create incident with GPS location
            incident_data = {
                "latitude": lat,
                "longitude": lng,
                "address": f"GPS: {lat:.6f}, {lng:.6f}",
                "issue_type": "Pothole",
                "status": "Reported",
                ...
            }
            
            create_incident(incident_data)
            print(f"📍 Incident created at GPS: {lat}, {lng}")
```

---

## 🔧 Setup Instructions

### 1. Buy USB GPS Dongle

- Search: "USB GPS dongle Raspberry Pi"
- Price: $10-30
- Plug into Pi 5 USB port

### 2. Install GPS Software

```bash
sudo apt update
sudo apt install -y gpsd gpsd-clients python3-gps
```

### 3. Test GPS

```bash
# Start GPS daemon
sudo systemctl start gpsd

# Test GPS
gpsmon
# Should show coordinates

# Or
cgps -s
```

### 4. Update Code

- Add `gps_helper.py`
- Update `main.py` to use GPS
- Test with GPS connected

---

## 📊 Location Accuracy Comparison

| Method | Accuracy | Setup | Cost | Best For |
|--------|----------|-------|------|----------|
| **GPS Module** | 3-5m | Medium | $10-30 | Mobile setup |
| **Camera Location** | Exact | Easy | Free | Fixed cameras |
| **IP Geolocation** | 1-10km | Easy | Free | Fallback |
| **WiFi Positioning** | 10-50m | Medium | Free* | Indoor |

*May require API key

---

## ✅ Summary

**To use GPS for pothole location:**

1. **Buy USB GPS dongle** (~$10-30)
2. **Install GPS software** on Pi 5
3. **Add GPS helper code** to your project
4. **Update main.py** to use GPS coordinates
5. **Test** with GPS connected

**Result**: Complaints will show exact GPS location where pothole was detected!

---

**Note**: For fixed CCTV cameras, camera location is usually sufficient. GPS is mainly needed for mobile/portable setups.




