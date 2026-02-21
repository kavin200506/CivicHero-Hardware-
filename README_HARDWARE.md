# CivicHero Ironman - Hardware Deployment Guide

Complete hardware solution for deploying edge detection on Raspberry Pi 5.

## 📦 What's Included

This hardware deployment package includes everything you need to deploy the CivicHero Ironman edge detection system on Raspberry Pi 5:

### Documentation
- **RASPBERRY_PI_SETUP.md** - Complete step-by-step setup guide
- **QUICK_START.md** - Fast 5-minute deployment guide
- **HARDWARE_DEPLOYMENT_CHECKLIST.md** - Comprehensive deployment checklist
- **README_HARDWARE.md** - This file

### Setup Scripts
- **setup_pi.sh** - Automated setup script for Raspberry Pi
- **requirements.txt** - Python dependencies

### Code Enhancements
- **src/pi_camera_helper.py** - Raspberry Pi Camera Module support
- **config.example.py** - Configuration template
- **src/main.py** - Updated with Pi Camera support

---

## 🚀 Quick Start

### 1. Transfer Files to Raspberry Pi

```bash
# Option A: Using SCP
scp -r Ironman pi@raspberrypi.local:~/

# Option B: Using USB drive
# Copy Ironman folder to USB, then transfer to Pi

# Option C: Using Git
cd ~
git clone <your-repo> CivicHero
cd CivicHero/Ironman
```

### 2. Run Setup

```bash
cd ~/Ironman
chmod +x setup_pi.sh
./setup_pi.sh
```

### 3. Configure

Edit `src/main.py`:
- Set `CAMERA_ID` from Firebase Admin Dashboard
- Set `VIDEO_SOURCE` (0 for USB, "pi" for Pi Camera, or RTSP URL)

### 4. Set Up Camera in Admin Dashboard

1. Open Admin Dashboard → Cameras tab
2. Add camera with location
3. Upload snapshot
4. Draw ROIs (road, garbage, streetlight)
5. Save

### 5. Test & Deploy

```bash
# Test
cd src && python3 main.py

# Enable auto-start
sudo systemctl enable civichero-ironman.service
sudo systemctl start civichero-ironman.service
```

---

## 📋 System Architecture

```
┌─────────────────────────────────────────┐
│      Raspberry Pi 5                     │
│  ┌───────────────────────────────────┐  │
│  │  Ironman Edge Detection System   │  │
│  │  - YOLO Pothole Detection        │  │
│  │  - Brightness Detection          │  │
│  │  - ROI Processing                │  │
│  └──────────────┬────────────────────┘  │
│                 │                        │
│  ┌──────────────▼────────────────────┐  │
│  │  Camera Input                     │  │
│  │  - Pi Camera Module              │  │
│  │  - USB Webcam                    │  │
│  │  - RTSP IP Camera                │  │
│  └───────────────────────────────────┘  │
└──────────────┬──────────────────────────┘
               │
               │ Internet
               │
               ▼
┌─────────────────────────────────────────┐
│         Firebase Cloud                   │
│  ┌───────────────────────────────────┐  │
│  │  Firestore                        │  │
│  │  - Camera Configs                 │  │
│  │  - ROIs                           │  │
│  │  - Incidents                      │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │  Storage                          │  │
│  │  - Detection Images               │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│    CivicHero Admin Dashboard            │
│  - View Incidents                       │
│  - Manage Cameras                       │
│  - Configure ROIs                       │
└─────────────────────────────────────────┘
```

---

## 🎯 Features

### ✅ What Works Now

1. **Video Processing**
   - USB webcam support
   - RTSP IP camera support
   - Local video file support
   - Raspberry Pi Camera Module support (with helper)

2. **Detection**
   - Pothole detection (YOLO)
   - Garbage detection (YOLO)
   - Streetlight failure detection (brightness)

3. **Integration**
   - Firebase Firestore for configs and incidents
   - Firebase Storage for images
   - Admin Dashboard integration

4. **Deployment**
   - Automated setup script
   - Systemd service for auto-start
   - Comprehensive documentation

---

## 📹 Camera Options

### Option 1: Raspberry Pi Camera Module 3
```python
VIDEO_SOURCE = "pi"  # or "picamera"
```
**Pros:** Native integration, good quality  
**Cons:** Requires Pi Camera Module hardware

### Option 2: USB Webcam
```python
VIDEO_SOURCE = 0  # Camera index
```
**Pros:** Easy setup, widely available  
**Cons:** May have lower quality

### Option 3: RTSP IP Camera
```python
VIDEO_SOURCE = "rtsp://user:pass@ip:port/stream"
```
**Pros:** Remote placement, professional cameras  
**Cons:** Requires network setup

---

## 🔧 Configuration

### Main Configuration (`src/main.py`)

```python
CAMERA_ID = "your-camera-id"  # From Firebase Admin Dashboard
VIDEO_SOURCE = 0  # Camera source
DETECTION_INTERVAL = 5  # Process every N frames
REPORT_COOLDOWN = 60  # Seconds between reports
```

### Firebase Configuration

1. **Camera Setup** (Admin Dashboard)
   - Add camera with location
   - Upload snapshot
   - Draw ROIs

2. **Service Account** (`serviceAccountKey.json`)
   - Download from Firebase Console
   - Place in `Ironman/` folder
   - Secure with: `chmod 600 serviceAccountKey.json`

---

## 📊 Monitoring

### View Logs
```bash
# Service logs
sudo journalctl -u civichero-ironman.service -f

# System resources
htop

# Temperature
vcgencmd measure_temp
```

### Check Status
```bash
# Service status
sudo systemctl status civichero-ironman.service

# Recent incidents
# Check Firebase Admin Dashboard
```

---

## 🐛 Troubleshooting

### Common Issues

1. **Camera not detected**
   - Check: `lsusb` or `v4l2-ctl --list-devices`
   - Fix: `sudo usermod -a -G video pi`

2. **Firebase connection failed**
   - Check: `serviceAccountKey.json` exists
   - Verify: Internet connection
   - Test: `ping google.com`

3. **Low performance**
   - Increase: `DETECTION_INTERVAL` to 10
   - Lower: Video resolution
   - Add: Cooling fan

4. **Service won't start**
   - Check: Logs with `sudo journalctl`
   - Verify: Paths in service file
   - Test: Manual run first

See **RASPBERRY_PI_SETUP.md** for detailed troubleshooting.

---

## 📚 Documentation

- **RASPBERRY_PI_SETUP.md** - Complete setup guide
- **QUICK_START.md** - Fast deployment
- **HARDWARE_DEPLOYMENT_CHECKLIST.md** - Deployment checklist
- **README.md** - Original project documentation

---

## 🎓 Next Steps

1. ✅ Deploy to Raspberry Pi 5
2. ✅ Configure camera and ROIs
3. ✅ Test detection system
4. ✅ Enable auto-start service
5. 🔄 Scale to multiple locations
6. 🔄 Add more camera types
7. 🔄 Optimize for production

---

## 📞 Support

- Check logs first: `sudo journalctl -u civichero-ironman.service`
- Review Firebase Console for incidents
- Check Admin Dashboard for camera status
- Refer to documentation files

---

**Ready to deploy!** Follow the **QUICK_START.md** guide to get started in 5 minutes.

**Last Updated:** February 2025




