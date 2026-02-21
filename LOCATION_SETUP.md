# Getting Latitude & Longitude on Raspberry Pi 5

Complete guide for obtaining location coordinates for your CivicHero Ironman system.

## 🎯 Current Implementation

**Good News**: Your system already gets lat/long from **camera configuration in Firebase**!

Looking at your code:
```python
# In main.py
lat = camera_config.get('latitude', 0.0)
lng = camera_config.get('longitude', 0.0)
```

The location comes from the **camera setup in Admin Dashboard** - you set it when adding the camera!

---

## ✅ Method 1: Use Camera Location (Recommended - Easiest)

**This is already set up!** When you add a camera in Admin Dashboard, you set the location.

### How It Works:

1. **Add Camera in Admin Dashboard**
   - Go to Cameras tab
   - Click "Add Camera"
   - Use the **map picker** to select location
   - Latitude/Longitude are automatically saved

2. **System Uses This Location**
   - Ironman system reads camera config from Firebase
   - Gets lat/long from camera configuration
   - Uses it for all incidents from that camera

### Advantages:
- ✅ **Already implemented** - no code changes needed
- ✅ **Accurate** - you set exact location
- ✅ **No hardware needed** - works with any Pi
- ✅ **One-time setup** - set once per camera

### Setup Steps:

1. Open Admin Dashboard
2. Go to **Cameras** tab
3. Add camera or edit existing
4. Click **map icon** to pick location
5. Save camera
6. Done! All incidents will use this location

---

## 📍 Method 2: GPS Module (For Mobile/Portable Setup)

If your Pi 5 is **mobile** or you need **real-time GPS tracking**:

### Hardware Needed:
- **GPS Module** (e.g., NEO-6M, NEO-8M)
- **USB GPS dongle** (easier, plug-and-play)

### Option A: USB GPS Dongle (Easiest)

1. **Buy USB GPS Dongle**
   - Plug into Pi 5 USB port
   - Works immediately

2. **Install GPS Tools**:
```bash
sudo apt update
sudo apt install -y gpsd gpsd-clients python3-gps
```

3. **Test GPS**:
```bash
# Check if GPS detected
lsusb | grep GPS

# Start GPS daemon
sudo systemctl start gpsd
sudo systemctl enable gpsd

# Test GPS
gpsmon
# Or
cgps -s
```

4. **Get Coordinates**:
```bash
gpspipe -w -n 10 | grep -m 1 TPV
```

### Option B: GPS Module (GPIO)

1. **Connect GPS Module** to Pi 5 GPIO pins
2. **Install dependencies** (same as above)
3. **Configure** serial port

### Python Code for GPS:

Create `src/gps_helper.py`:
```python
import gps
import time

def get_gps_coordinates():
    """Get current GPS coordinates"""
    try:
        # Connect to GPS daemon
        session = gps.gps(mode=gps.WATCH_ENABLE)
        
        # Wait for fix
        for report in session:
            if report['class'] == 'TPV':
                if hasattr(report, 'lat') and hasattr(report, 'lon'):
                    return report.lat, report.lon
            time.sleep(0.1)
    except Exception as e:
        print(f"GPS error: {e}")
        return None, None
```

---

## 🌐 Method 3: Network-Based Geolocation (Fallback)

Get approximate location from IP address or WiFi networks.

### Using IP Geolocation API:

```python
import requests

def get_location_from_ip():
    """Get approximate location from IP address"""
    try:
        # Free IP geolocation API
        response = requests.get('http://ip-api.com/json/')
        data = response.json()
        
        if data['status'] == 'success':
            return data['lat'], data['lon']
    except Exception as e:
        print(f"IP geolocation error: {e}")
        return None, None
```

### Using WiFi Networks (More Accurate):

```python
import subprocess
import json

def get_location_from_wifi():
    """Get location from nearby WiFi networks"""
    try:
        # Scan WiFi networks
        result = subprocess.run(
            ['iwlist', 'scan'],
            capture_output=True,
            text=True
        )
        
        # Parse WiFi networks
        # Use WiFi positioning service (like Google's)
        # This requires API key
        
        return None, None
    except Exception as e:
        print(f"WiFi location error: {e}")
        return None, None
```

---

## 🔧 Method 4: Manual Configuration File

Set location in a config file on the Pi.

### Create `config.py`:

```python
# Camera location (set manually)
CAMERA_LATITUDE = 12.9716  # Your location
CAMERA_LONGITUDE = 77.5946  # Your location
```

### Update `main.py`:

```python
# Option 1: Use from config file
try:
    from config import CAMERA_LATITUDE, CAMERA_LONGITUDE
    lat = CAMERA_LATITUDE
    lng = CAMERA_LONGITUDE
except:
    # Fallback to camera config
    lat = camera_config.get('latitude', 0.0)
    lng = camera_config.get('longitude', 0.0)
```

---

## 🎯 Recommended Approach

### For Fixed Camera Locations:

**Use Method 1** (Camera Location in Admin Dashboard)
- ✅ Already implemented
- ✅ Easiest setup
- ✅ Most accurate
- ✅ No hardware needed

### For Mobile/Portable Setup:

**Use Method 2** (GPS Module)
- ✅ Real-time location
- ✅ Works anywhere
- ✅ Accurate
- ⚠️ Requires GPS hardware

### For Quick Testing:

**Use Method 4** (Config File)
- ✅ Quick setup
- ✅ No dependencies
- ⚠️ Manual update needed

---

## 📝 Implementation Guide

### Option 1: Keep Current (Recommended)

**No changes needed!** Your system already:
1. Gets location from camera config in Firebase
2. Uses it for all incidents
3. Works automatically

**Just set location in Admin Dashboard when adding camera!**

### Option 2: Add GPS Support

If you want GPS, update `main.py`:

```python
# Add GPS helper import
try:
    from src.gps_helper import get_gps_coordinates
    GPS_AVAILABLE = True
except:
    GPS_AVAILABLE = False

# In main() function, after getting camera_config:
if GPS_AVAILABLE:
    gps_lat, gps_lng = get_gps_coordinates()
    if gps_lat and gps_lng:
        lat = gps_lat
        lng = gps_lng
        print(f"Using GPS location: {lat}, {lng}")
    else:
        # Fallback to camera config
        lat = camera_config.get('latitude', 0.0)
        lng = camera_config.get('longitude', 0.0)
else:
    # Use camera config (current method)
    lat = camera_config.get('latitude', 0.0)
    lng = camera_config.get('longitude', 0.0)
```

---

## 🗺️ Finding Your Location

### If You Don't Know Coordinates:

1. **Google Maps**:
   - Right-click on location
   - Click coordinates
   - Copy lat/long

2. **Online Tools**:
   - https://www.latlong.net/
   - Enter address, get coordinates

3. **Admin Dashboard Map Picker**:
   - Click on map
   - Coordinates shown automatically

---

## ✅ Quick Setup Checklist

### For Fixed Camera (Recommended):

- [ ] Open Admin Dashboard
- [ ] Go to Cameras tab
- [ ] Add/Edit camera
- [ ] Click map icon
- [ ] Pick location on map
- [ ] Save camera
- [ ] Done! Location is set

### For GPS Module:

- [ ] Buy USB GPS dongle
- [ ] Plug into Pi 5
- [ ] Install: `sudo apt install gpsd gpsd-clients python3-gps`
- [ ] Test: `gpsmon`
- [ ] Update code to use GPS (optional)

---

## 📊 Comparison

| Method | Accuracy | Setup | Cost | Best For |
|--------|----------|-------|------|----------|
| **Camera Config** | Exact | Easy | Free | Fixed cameras |
| **GPS Module** | 3-5m | Medium | $10-30 | Mobile setup |
| **IP Geolocation** | 1-10km | Easy | Free | Fallback |
| **Manual Config** | Exact | Easy | Free | Testing |

---

## 🎯 My Recommendation

**For Raspberry Pi 5 with fixed camera:**

1. **Use Method 1** (Camera Location in Admin Dashboard)
   - Already implemented
   - Easiest setup
   - Most accurate for fixed locations
   - No hardware needed

2. **Set location when adding camera:**
   - Open Admin Dashboard
   - Add camera
   - Use map picker
   - Done!

**For mobile/portable setup:**
- Use GPS module (Method 2)
- More complex but accurate for moving locations

---

## 💡 Summary

**Current System**: Gets lat/long from camera configuration in Firebase ✅

**To Set Location**:
1. Open Admin Dashboard
2. Add/Edit camera
3. Use map picker to set location
4. Save

**That's it!** No code changes needed. The system automatically uses the camera location for all incidents.

---

**Last Updated**: February 2025




