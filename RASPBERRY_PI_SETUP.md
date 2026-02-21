# Raspberry Pi 5 Hardware Setup Guide

Complete guide for deploying CivicHero Ironman edge detection system on Raspberry Pi 5.

## 📋 Prerequisites

### Hardware Requirements
- **Raspberry Pi 5** (4GB RAM minimum, 8GB recommended)
- **Storage Option** (choose one):
  - **MicroSD Card** (32GB+ Class 10 or better) - Traditional option
  - **USB Pendrive/USB SSD** (32GB+ USB 3.0 recommended) - **Faster & More Reliable** ⚡
- **Power Supply** (27W USB-C, official Raspberry Pi 5 PSU recommended)
- **Camera Module** (Raspberry Pi Camera Module 3 or USB webcam)
- **Internet Connection** (WiFi or Ethernet)
- **Optional**: Cooling fan/heatsink for extended operation

### Software Requirements
- Raspberry Pi OS (64-bit) - Bookworm or later
- Python 3.9+ (comes with Raspberry Pi OS)
- Stable internet connection for Firebase access

---

## 🚀 Step-by-Step Setup

### Step 1: Install Raspberry Pi OS

**Option A: USB Pendrive (Recommended for Pi 5)** ⚡

Raspberry Pi 5 has excellent USB boot support - USB drives are often faster and more reliable than SD cards!

1. Download **Raspberry Pi Imager** from [raspberrypi.com](https://www.raspberrypi.com/software/)
2. Insert your **USB pendrive** (32GB+ USB 3.0 recommended)
3. Open Raspberry Pi Imager
4. Click **"Choose OS"** → Select **"Raspberry Pi OS (64-bit)"**
5. Click **"Choose Storage"** → Select your **USB pendrive** (not SD card)
6. Click the **gear icon** (⚙️) to configure:
   - ✅ Enable SSH
   - ✅ Set username/password
   - ✅ Configure WiFi (or use Ethernet)
   - ✅ Set locale settings
7. Click **"Write"** to flash OS to USB drive
8. **Important**: After flashing, you may need to enable USB boot:
   - Insert the USB drive into your Pi 5
   - Boot from an SD card first (or use existing boot)
   - Run: `sudo rpi-eeprom-config --edit`
   - Set: `BOOT_ORDER=0xf41` (USB boot first)
   - Or use: `raspi-config` → Advanced Options → Boot Order → USB Boot
9. Reboot and it should boot from USB

**Option B: MicroSD Card (Traditional)**

1. Download **Raspberry Pi Imager** from [raspberrypi.com](https://www.raspberrypi.com/software/)
2. Flash **Raspberry Pi OS (64-bit)** to your microSD card
3. Enable SSH and configure WiFi during imaging (or use Ethernet)
4. Boot your Raspberry Pi 5

**Note**: USB boot is recommended for better performance and reliability!

### Step 2: Initial System Setup

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install essential build tools
sudo apt install -y python3-pip python3-venv git build-essential

# Install camera libraries (if using Pi Camera)
sudo apt install -y python3-picamera2 python3-opencv

# Install additional dependencies
sudo apt install -y libopencv-dev python3-opencv libatlas-base-dev
```

### Step 3: Clone/Transfer Project Files

**Option A: Using Git (Recommended)**
```bash
cd ~
git clone <your-repo-url> CivicHero
cd CivicHero/Ironman
```

**Option B: Manual Transfer**
- Use SCP, SFTP, or USB drive to transfer the `Ironman` folder
- Ensure all files are in place:
  - `ultra.pt` (YOLO model)
  - `serviceAccountKey.json` (Firebase credentials)
  - `src/` directory with all Python files
  - `reeq.txt` (requirements)

### Step 4: Create Virtual Environment

```bash
cd ~/CivicHero/Ironman
python3 -m venv venv
source venv/bin/activate
```

### Step 5: Install Python Dependencies

```bash
# Upgrade pip first
pip install --upgrade pip

# Install requirements
pip install -r reeq.txt

# Additional dependencies for Raspberry Pi
pip install picamera2  # If using Pi Camera Module
```

### Step 6: Configure Firebase Service Account

Ensure `serviceAccountKey.json` is in the `Ironman/` directory:
```bash
ls -la serviceAccountKey.json
# Should show the file exists
```

### Step 7: Configure Camera Source

Edit `src/main.py` to set your video source:

**For Raspberry Pi Camera Module:**
```python
VIDEO_SOURCE = 0  # Use default camera index
# OR use picamera2:
# from picamera2 import Picamera2
# picam2 = Picamera2()
```

**For USB Webcam:**
```python
VIDEO_SOURCE = 0  # Usually 0 for first USB camera
# Test with: lsusb to see connected cameras
```

**For RTSP Stream (IP Camera):**
```python
VIDEO_SOURCE = "rtsp://username:password@camera-ip:554/stream"
```

**For Local Video File:**
```python
VIDEO_SOURCE = "src/samples/test.mp4"
```

### Step 8: Set Camera ID in Firebase

1. Open your **CivicHero Admin Dashboard**
2. Go to **Cameras** tab
3. Add a new camera or use existing one
4. Note the **Camera ID** from Firebase
5. Update `CAMERA_ID` in `src/main.py`:
```python
CAMERA_ID = "your-camera-id-from-firebase"
```

### Step 9: Configure ROIs (Regions of Interest)

1. In Admin Dashboard, select your camera
2. Draw ROIs on the camera snapshot:
   - **Road ROI**: For pothole detection
   - **Garbage ROI**: For garbage detection
   - **Streetlight ROI**: For brightness detection
3. Save the ROIs - they'll be automatically fetched by the Pi

### Step 10: Test the System

```bash
cd ~/CivicHero/Ironman/src
python3 main.py
```

You should see:
- Video feed displaying
- ROIs drawn in green
- Detections highlighted in red
- Console logs showing incident creation

Press `q` to quit.

---

## 🔄 Running as a Service (Auto-start on Boot)

### Create Systemd Service

Create service file:
```bash
sudo nano /etc/systemd/system/civichero-ironman.service
```

Add this content:
```ini
[Unit]
Description=CivicHero Ironman Edge Detection System
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/CivicHero/Ironman/src
Environment="PATH=/home/pi/CivicHero/Ironman/venv/bin"
ExecStart=/home/pi/CivicHero/Ironman/venv/bin/python3 main.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Update paths** to match your setup!

### Enable and Start Service

```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable service (start on boot)
sudo systemctl enable civichero-ironman.service

# Start service now
sudo systemctl start civichero-ironman.service

# Check status
sudo systemctl status civichero-ironman.service

# View logs
sudo journalctl -u civichero-ironman.service -f
```

---

## 📹 Camera Configuration Options

### Option 1: Raspberry Pi Camera Module 3

**Hardware Setup:**
1. Connect camera ribbon cable to Pi 5's camera connector
2. Enable camera in `raspi-config`:
```bash
sudo raspi-config
# Navigate to: Interface Options > Camera > Enable
```

**Code Configuration:**
```python
from picamera2 import Picamera2
import cv2

picam2 = Picamera2()
picam2.configure(picam2.create_video_configuration(main={"size": (1920, 1080)}))
picam2.start()

# In main loop, capture frames:
frame = picam2.capture_array()
frame_rgb = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)
```

### Option 2: USB Webcam

**Hardware Setup:**
1. Plug USB webcam into Pi 5
2. Verify detection:
```bash
lsusb
v4l2-ctl --list-devices
```

**Code Configuration:**
```python
VIDEO_SOURCE = 0  # Usually 0, try 1, 2 if multiple cameras
```

### Option 3: RTSP IP Camera

**Code Configuration:**
```python
VIDEO_SOURCE = "rtsp://admin:password@192.168.1.100:554/stream1"
```

**Test RTSP stream:**
```bash
ffplay rtsp://admin:password@192.168.1.100:554/stream1
```

---

## 🔧 Troubleshooting

### Issue: "Cannot open video source"
**Solution:**
- Check camera is connected: `lsusb` or `v4l2-ctl --list-devices`
- Verify camera permissions: `sudo usermod -a -G video pi`
- Test with: `ffplay /dev/video0`

### Issue: "Firebase connection failed"
**Solution:**
- Verify `serviceAccountKey.json` exists and is valid
- Check internet connection: `ping google.com`
- Test Firebase: `python3 -c "import firebase_admin; print('OK')"`

### Issue: "YOLO model not found"
**Solution:**
- Verify `ultra.pt` is in `Ironman/` directory
- Check file size (should be ~50MB)
- Verify path in `main.py`

### Issue: "Low FPS / Performance"
**Solution:**
- Reduce detection interval: `DETECTION_INTERVAL = 10` (check every 10 frames)
- Lower video resolution
- Use hardware acceleration if available
- Ensure adequate cooling (add fan)

### Issue: "Service won't start"
**Solution:**
- Check logs: `sudo journalctl -u civichero-ironman.service -n 50`
- Verify paths in service file are correct
- Test manually: `cd ~/CivicHero/Ironman/src && python3 main.py`

---

## 📊 Performance Optimization

### For Better Performance:

1. **Reduce Detection Frequency:**
```python
DETECTION_INTERVAL = 10  # Check every 10 frames instead of 5
```

2. **Lower Video Resolution:**
```python
# In camera setup
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
```

3. **Adjust Cooldown Period:**
```python
REPORT_COOLDOWN = 3600  # 1 hour instead of 60 seconds
```

4. **Use GPU Acceleration (if available):**
```python
# In YOLO detector initialization
self.model = YOLO(model_path)
self.model.to('cuda')  # If CUDA available
```

---

## 🔐 Security Considerations

1. **Protect Service Account Key:**
   - Never commit to git (already in `.gitignore`)
   - Use file permissions: `chmod 600 serviceAccountKey.json`
   - Consider using environment variables in production

2. **Network Security:**
   - Use firewall: `sudo ufw enable`
   - Only allow necessary ports
   - Use VPN for remote access if needed

3. **System Updates:**
   - Regular updates: `sudo apt update && sudo apt upgrade`
   - Monitor logs for issues

---

## 📝 Monitoring & Maintenance

### View Real-time Logs:
```bash
sudo journalctl -u civichero-ironman.service -f
```

### Check System Resources:
```bash
htop
# Or
top
```

### Monitor Temperature:
```bash
vcgencmd measure_temp
```

### Check Disk Space:
```bash
df -h
```

### Restart Service:
```bash
sudo systemctl restart civichero-ironman.service
```

---

## 🎯 Next Steps

1. ✅ Deploy to Raspberry Pi 5
2. ✅ Configure camera and ROIs
3. ✅ Set up auto-start service
4. ✅ Monitor detections in Admin Dashboard
5. 🔄 Scale to multiple Pi devices
6. 🔄 Add more camera locations
7. 🔄 Optimize for production use

---

## 📞 Support

For issues or questions:
- Check logs: `sudo journalctl -u civichero-ironman.service`
- Review Firebase console for incident records
- Verify camera configuration in Admin Dashboard

---

**Last Updated:** February 2025
**Compatible with:** Raspberry Pi 5, Raspberry Pi OS Bookworm

