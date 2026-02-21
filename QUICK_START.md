# Quick Start Guide - Raspberry Pi 5 Deployment

## 🚀 Fast Setup (5 minutes)

### 0. Install OS on USB Pendrive (Recommended)

Raspberry Pi 5 supports booting from USB drives (faster than SD cards)!

1. Use **Raspberry Pi Imager**
2. Select **Raspberry Pi OS (64-bit)**
3. Choose your **USB pendrive** (not SD card)
4. Configure SSH and WiFi
5. Flash and boot!

See **USB_BOOT_GUIDE.md** for detailed instructions.

### 1. Transfer Files to Raspberry Pi

```bash
# On your computer, use SCP to transfer the Ironman folder
scp -r Ironman pi@raspberrypi.local:~/

# Or use USB drive, or clone from git
```

### 2. Run Setup Script

```bash
cd ~/Ironman
chmod +x setup_pi.sh
./setup_pi.sh
```

The script will:
- ✅ Update system packages
- ✅ Install dependencies
- ✅ Create virtual environment
- ✅ Install Python packages
- ✅ Set up auto-start service (optional)

### 3. Configure Camera

Edit `src/main.py`:

```python
# Set your camera ID from Firebase Admin Dashboard
CAMERA_ID = "your-camera-id-here"

# Set video source:
# - 0 for USB webcam
# - "rtsp://user:pass@ip:port/stream" for IP camera
# - "src/samples/test.mp4" for test video
VIDEO_SOURCE = 0  # or your RTSP URL
```

### 4. Set Up Camera in Admin Dashboard

1. Open CivicHero Admin Dashboard
2. Go to **Cameras** tab
3. Click **Add Camera**
4. Fill in:
   - Camera Name
   - Location (use map picker)
   - Upload snapshot image
5. Click on the camera snapshot
6. Draw ROIs (Regions of Interest):
   - Draw **road** areas for pothole detection
   - Draw **garbage** areas for garbage detection
   - Draw **streetlight** areas for brightness detection
7. Save ROIs

### 5. Test the System

```bash
cd ~/Ironman/src
source ../venv/bin/activate
python3 main.py
```

You should see:
- Video window with detections
- Green ROI outlines
- Red bounding boxes on detections
- Console logs showing incident creation

Press `q` to quit.

### 6. Enable Auto-Start (Optional)

If you set up the service during setup:

```bash
sudo systemctl enable civichero-ironman.service
sudo systemctl start civichero-ironman.service

# Check status
sudo systemctl status civichero-ironman.service

# View logs
sudo journalctl -u civichero-ironman.service -f
```

---

## 📹 Camera Options

### USB Webcam
```python
VIDEO_SOURCE = 0
```

### Raspberry Pi Camera Module
```python
# Install: sudo apt install python3-picamera2
from picamera2 import Picamera2
picam2 = Picamera2()
picam2.start()
# Then capture frames in main loop
```

### RTSP IP Camera
```python
VIDEO_SOURCE = "rtsp://admin:password@192.168.1.100:554/stream1"
```

---

## 🔧 Troubleshooting

### Camera not detected?
```bash
lsusb  # Check USB devices
v4l2-ctl --list-devices  # List video devices
```

### Firebase connection failed?
- Check `serviceAccountKey.json` exists
- Verify internet connection
- Check Firebase project settings

### Low performance?
- Increase `DETECTION_INTERVAL` in `main.py` (e.g., 10 instead of 5)
- Lower video resolution
- Add cooling fan

---

## 📚 Full Documentation

See `RASPBERRY_PI_SETUP.md` for complete setup guide.

---

**Need Help?** Check logs: `sudo journalctl -u civichero-ironman.service -f`

