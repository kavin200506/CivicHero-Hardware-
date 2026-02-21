# Setting Up Without Raspberry Pi 5

Guide for preparing and testing CivicHero Ironman on your Mac before you get the Raspberry Pi 5.

## 🎯 Options Available

### Option 1: Test on Mac (Recommended) ✅
Test and develop the code on your Mac, then deploy to Pi when ready.

### Option 2: Use QEMU Emulator (Advanced)
Emulate Raspberry Pi on your Mac (slower, but closer to Pi environment).

### Option 3: Prepare Everything Now
Set up all files and configurations, ready to transfer when you get the Pi.

---

## ✅ Option 1: Test on Mac (Easiest & Recommended)

You can run and test the entire system on your Mac right now!

### Step 1: Install Dependencies on Mac

```bash
# Navigate to Ironman folder
cd /Users/kavin/Development/projects/1/Ironman

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies (picamera2 is Linux-only, so install individually on Mac)
pip install --upgrade pip
pip install ultralytics opencv-python firebase-admin numpy onnxruntime
# Note: picamera2 is only needed on Raspberry Pi, not on Mac
```

### Step 2: Test with Video File

The system already works with video files! Just run:

```bash
cd src
python3 main.py
```

It will use `src/samples/test.mp4` by default.

### Step 3: Test with Webcam (if you have one)

Edit `src/main.py`:

```python
# Change this line:
VIDEO_SOURCE = 0  # Use Mac's webcam (or 1, 2 for other cameras)
```

Then run:
```bash
python3 main.py
```

### Step 4: Test with RTSP Stream (if you have IP camera)

```python
VIDEO_SOURCE = "rtsp://username:password@camera-ip:554/stream"
```

### Step 5: Verify Everything Works

- ✅ Video processing works
- ✅ YOLO detection works
- ✅ Firebase connection works
- ✅ Incident creation works
- ✅ Image upload works

**When you get the Pi 5**, just transfer the folder and it will work the same way!

---

## 🐳 Option 2: Use Docker (Alternative)

Create a containerized environment that's closer to Pi:

### Create Dockerfile

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libopencv-dev \
    python3-opencv \
    libatlas-base-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

CMD ["python3", "src/main.py"]
```

### Build and Run

```bash
docker build -t civichero-ironman .
docker run -it --rm \
  -v $(pwd):/app \
  -v /dev/video0:/dev/video0 \
  civichero-ironman
```

---

## 🖥️ Option 3: QEMU Raspberry Pi Emulator (Advanced)

Emulate Raspberry Pi on your Mac (slower, but tests Pi environment).

### Install QEMU

```bash
# Using Homebrew
brew install qemu

# Or download from: https://www.qemu.org/download/
```

### Download Raspberry Pi OS Image

1. Download Raspberry Pi OS (64-bit) image
2. Extract the `.img` file

### Run QEMU

```bash
qemu-system-aarch64 \
  -M raspi5 \
  -cpu cortex-a76 \
  -smp 4 \
  -m 4G \
  -drive file=raspios.img,format=raw \
  -netdev user,id=net0 \
  -device rtl8139,netdev=net0 \
  -nographic
```

**Note**: QEMU emulation is slow and complex. Not recommended unless you need exact Pi environment testing.

---

## 📋 Option 4: Prepare Everything Now (Best Approach)

Set up all configurations and files now, ready for Pi deployment.

### Step 1: Prepare Project Structure

```bash
cd /Users/kavin/Development/projects/1/Ironman

# Ensure all files are in place
ls -la
# Should see: ultra.pt, serviceAccountKey.json, src/, etc.
```

### Step 2: Test Code on Mac

```bash
# Test with video file
cd src
python3 main.py

# Verify:
# - Firebase connection works
# - Detections work
# - Images upload
# - Incidents created
```

### Step 3: Configure for Pi (in advance)

Edit `src/main.py` and prepare configurations:

```python
# Set these when you know your camera setup:
CAMERA_ID = "your-camera-id"  # Get from Admin Dashboard
VIDEO_SOURCE = 0  # Will be USB webcam or Pi Camera on Pi
```

### Step 4: Create Setup Scripts

The `setup_pi.sh` script is already created and ready!

### Step 5: Document Your Setup

Note down:
- Camera type you'll use (USB/Pi Camera/RTSP)
- Network settings
- Camera locations
- Any custom configurations

---

## 🎯 Recommended Workflow

### Now (On Mac):

1. **Test the code**:
   ```bash
   cd Ironman/src
   python3 main.py
   ```

2. **Verify Firebase works**:
   - Check incidents are created
   - Check images are uploaded
   - Test Admin Dashboard integration

3. **Prepare configurations**:
   - Set up cameras in Admin Dashboard
   - Draw ROIs
   - Test with different video sources

4. **Document everything**:
   - Camera IDs
   - Network settings
   - Any custom settings

### When You Get Pi 5:

1. **Transfer files**:
   ```bash
   # From Mac to Pi
   scp -r Ironman pi@raspberrypi.local:~/
   ```

2. **Run setup**:
   ```bash
   cd ~/Ironman
   ./setup_pi.sh
   ```

3. **Configure camera**:
   - Update `VIDEO_SOURCE` in `main.py`
   - Test detection

4. **Enable service**:
   ```bash
   sudo systemctl enable civichero-ironman.service
   ```

---

## ✅ What You Can Do Right Now

### 1. Test Detection System

```bash
cd /Users/kavin/Development/projects/1/Ironman/src
python3 main.py
```

This will:
- ✅ Load YOLO model
- ✅ Process video file
- ✅ Detect potholes
- ✅ Create Firebase incidents
- ✅ Upload images

### 2. Set Up Cameras in Admin Dashboard

1. Open Admin Dashboard
2. Go to Cameras tab
3. Add cameras with locations
4. Draw ROIs on snapshots
5. Save configurations

### 3. Test Firebase Integration

Verify:
- ✅ Service account key works
- ✅ Firestore reads/writes work
- ✅ Storage uploads work
- ✅ Incidents appear in dashboard

### 4. Prepare Configurations

Document:
- Camera IDs you'll use
- Network settings
- Video sources
- ROI configurations

---

## 🚀 Quick Test Command

Run this to test everything on your Mac:

```bash
cd /Users/kavin/Development/projects/1/Ironman/src
python3 main.py
```

If it works on Mac, it will work on Pi 5!

---

## 💡 Pro Tips

1. **Test now, deploy later**: Get everything working on Mac first
2. **Use video files**: Test with `test.mp4` without needing camera
3. **Prepare Admin Dashboard**: Set up cameras and ROIs in advance
4. **Document everything**: Write down configurations for easy Pi setup
5. **Keep USB ready**: Your pendrive is already prepared!

---

## 📝 Summary

**You don't need the Pi 5 right now!**

✅ Test code on Mac  
✅ Verify Firebase works  
✅ Set up Admin Dashboard  
✅ Prepare configurations  
✅ When Pi arrives, just transfer and run!

The code is **platform-independent** - if it works on Mac, it will work on Pi 5!

---

**Next Steps:**
1. Test the code on your Mac now
2. Set up cameras in Admin Dashboard
3. When you get Pi 5, transfer files and run `setup_pi.sh`

You're all set! 🎉



