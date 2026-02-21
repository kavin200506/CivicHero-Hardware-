# Hardware Deployment Checklist

Complete checklist for deploying CivicHero Ironman on Raspberry Pi 5.

## 📋 Pre-Deployment Checklist

### Hardware Setup
- [ ] Raspberry Pi 5 (4GB+ RAM recommended)
- [ ] Storage: **USB Pendrive/USB SSD (32GB+ USB 3.0)** ⚡ **OR** MicroSD Card (32GB+ Class 10)
  - **USB boot is recommended** - faster and more reliable!
- [ ] Power Supply (27W USB-C, official recommended)
- [ ] Camera (Pi Camera Module 3 OR USB Webcam OR IP Camera)
- [ ] Internet connection (WiFi/Ethernet)
- [ ] Cooling solution (fan/heatsink recommended)
- [ ] Case/enclosure (optional but recommended)

### Software Setup
- [ ] Raspberry Pi OS (64-bit) installed
- [ ] SSH enabled
- [ ] WiFi/Ethernet configured
- [ ] System updated (`sudo apt update && sudo apt upgrade`)

### Project Files
- [ ] `Ironman` folder transferred to Pi
- [ ] `ultra.pt` (YOLO model) present
- [ ] `serviceAccountKey.json` (Firebase credentials) present
- [ ] All Python source files in `src/` directory

### Firebase Configuration
- [ ] Firebase project created
- [ ] Firestore database initialized
- [ ] Storage bucket configured
- [ ] Service account key downloaded
- [ ] Camera added in Admin Dashboard
- [ ] ROIs configured for camera

---

## 🚀 Deployment Steps

### Step 1: Initial Setup
- [ ] Run setup script: `./setup_pi.sh`
- [ ] Verify all dependencies installed
- [ ] Check virtual environment created
- [ ] Verify Python packages installed

### Step 2: Configuration
- [ ] Edit `src/main.py`:
  - [ ] Set `CAMERA_ID` (from Firebase)
  - [ ] Set `VIDEO_SOURCE` (camera/stream/file)
- [ ] Test camera access: `v4l2-ctl --list-devices`
- [ ] Verify internet connection

### Step 3: Camera Setup in Admin Dashboard
- [ ] Login to Admin Dashboard
- [ ] Navigate to Cameras tab
- [ ] Add new camera OR select existing
- [ ] Upload/configure snapshot image
- [ ] Draw ROIs on snapshot:
  - [ ] Road ROI for pothole detection
  - [ ] Garbage ROI for garbage detection
  - [ ] Streetlight ROI for brightness detection
- [ ] Save ROIs

### Step 4: Testing
- [ ] Run manually: `cd src && python3 main.py`
- [ ] Verify video feed displays
- [ ] Check ROIs are visible (green outlines)
- [ ] Test detection (should see red bounding boxes)
- [ ] Verify incidents created in Firebase
- [ ] Check images uploaded to Storage

### Step 5: Service Setup (Auto-start)
- [ ] Service file created during setup
- [ ] Enable service: `sudo systemctl enable civichero-ironman.service`
- [ ] Start service: `sudo systemctl start civichero-ironman.service`
- [ ] Verify status: `sudo systemctl status civichero-ironman.service`
- [ ] Check logs: `sudo journalctl -u civichero-ironman.service -f`

### Step 6: Monitoring
- [ ] Set up log monitoring
- [ ] Configure temperature monitoring
- [ ] Set up disk space alerts
- [ ] Test auto-restart on failure

---

## 🔍 Verification Checklist

### System Health
- [ ] CPU usage acceptable (<80% average)
- [ ] Temperature within limits (<70°C)
- [ ] Memory usage stable
- [ ] Disk space sufficient (>5GB free)

### Detection System
- [ ] Video feed stable
- [ ] Detections occurring (check logs)
- [ ] Incidents created in Firestore
- [ ] Images uploaded to Storage
- [ ] No duplicate reports (cooldown working)

### Network & Connectivity
- [ ] Internet connection stable
- [ ] Firebase accessible
- [ ] Camera stream stable (if RTSP)
- [ ] No network timeouts

### Admin Dashboard
- [ ] Can view incidents from Pi
- [ ] Images display correctly
- [ ] Status updates work
- [ ] Camera configuration accessible

---

## 🐛 Troubleshooting Checklist

### If camera not working:
- [ ] Check camera connection
- [ ] Verify camera permissions: `sudo usermod -a -G video pi`
- [ ] Test with: `ffplay /dev/video0`
- [ ] Check video device: `v4l2-ctl --list-devices`

### If Firebase not connecting:
- [ ] Verify `serviceAccountKey.json` exists
- [ ] Check file permissions: `chmod 600 serviceAccountKey.json`
- [ ] Test internet: `ping google.com`
- [ ] Verify Firebase project settings

### If detections not working:
- [ ] Check YOLO model file exists: `ls -lh ultra.pt`
- [ ] Verify ROIs configured in Firebase
- [ ] Check detection interval setting
- [ ] Review logs for errors

### If service not starting:
- [ ] Check service file paths are correct
- [ ] Verify virtual environment path
- [ ] Check logs: `sudo journalctl -u civichero-ironman.service -n 50`
- [ ] Test manual run works first

---

## 📊 Performance Optimization Checklist

### For Better Performance:
- [ ] Increase `DETECTION_INTERVAL` (e.g., 10 instead of 5)
- [ ] Lower video resolution if needed
- [ ] Adjust cooldown period
- [ ] Enable hardware acceleration (if available)
- [ ] Add cooling solution
- [ ] Use faster SD card (Class 10+)

### Monitoring:
- [ ] Set up log rotation
- [ ] Monitor temperature regularly
- [ ] Track detection accuracy
- [ ] Monitor Firebase quota usage

---

## 🔐 Security Checklist

- [ ] Service account key secured (chmod 600)
- [ ] Firewall configured (if needed)
- [ ] SSH key-based authentication
- [ ] Regular system updates scheduled
- [ ] No sensitive data in logs
- [ ] Network security configured

---

## 📝 Maintenance Checklist

### Daily:
- [ ] Check service status
- [ ] Review recent logs
- [ ] Verify detections in dashboard

### Weekly:
- [ ] Check disk space
- [ ] Review system updates
- [ ] Verify camera functionality
- [ ] Check Firebase quota

### Monthly:
- [ ] System backup
- [ ] Clean temp files
- [ ] Review performance metrics
- [ ] Update dependencies if needed

---

## ✅ Deployment Sign-off

- [ ] All hardware components working
- [ ] Software installed and configured
- [ ] Camera detection functioning
- [ ] Firebase integration working
- [ ] Auto-start service enabled
- [ ] Monitoring set up
- [ ] Documentation reviewed
- [ ] Team trained (if applicable)

**Deployed by:** _________________  
**Date:** _________________  
**Camera ID:** _________________  
**Location:** _________________

---

## 📞 Support Contacts

- **Technical Issues:** Check logs first, then review documentation
- **Firebase Issues:** Check Firebase Console
- **Hardware Issues:** Verify connections and power supply

---

**Last Updated:** February 2025

