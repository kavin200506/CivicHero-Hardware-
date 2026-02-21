# 🚀 Quick Deployment to Raspberry Pi 5

Your Pi is reachable at **192.168.1.88**! Here's how to deploy:

---

## 📋 Option 1: Automated Deployment Script

I've created a deployment script for you. Run it from your Mac:

```bash
cd /Users/kavin/Development/projects/1/Ironman
./deploy_to_pi.sh
```

**Note**: You'll be prompted for the Pi password during SSH connection.

---

## 📋 Option 2: Manual Deployment (Step by Step)

### Step 1: Transfer Files to Pi

```bash
# From your Mac, in the Ironman directory
cd /Users/kavin/Development/projects/1/Ironman

# Transfer files (you'll be asked for password)
scp -r . pi@192.168.1.88:~/Ironman
```

**Or use rsync (excludes unnecessary files):**
```bash
rsync -avz --progress \
    --exclude 'venv/' \
    --exclude '__pycache__/' \
    --exclude '*.pyc' \
    --exclude '.git/' \
    --exclude '.DS_Store' \
    pi@192.168.1.88:~/Ironman/
```

### Step 2: SSH into Pi

```bash
ssh pi@192.168.1.88
# Enter your password when prompted
```

### Step 3: Run Setup on Pi

Once you're SSH'd into the Pi:

```bash
# Navigate to Ironman folder
cd ~/Ironman

# Make setup script executable
chmod +x setup_pi.sh

# Run setup (installs dependencies)
./setup_pi.sh
```

### Step 4: Run the System

```bash
cd ~/Ironman/src
python3 main.py
```

**What will happen:**
- ✅ Tries USB webcam (index 0) first
- ✅ Falls back to test video if webcam not available
- ✅ Detects potholes automatically
- ✅ Creates incidents in Firebase

---

## 🔧 If You Forgot Your Pi Password

If you need to reset the password:

1. **With Display/Keyboard**: Boot Pi, login, run `passwd`
2. **Without Display**: Reflash OS with Raspberry Pi Imager and set new password
3. **SSH Key**: Set up SSH keys to avoid password prompts

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] Files transferred: `ls ~/Ironman/src/main.py`
- [ ] Model file exists: `ls ~/Ironman/ultra.onnx`
- [ ] Firebase key exists: `ls ~/Ironman/serviceAccountKey.json`
- [ ] Test video exists: `ls ~/Ironman/src/samples/test.mp4`
- [ ] Dependencies installed: `cd ~/Ironman && source venv/bin/activate && python3 -c "import cv2; print('OK')"`

---

## 🎯 Quick Test

Once deployed, test the system:

```bash
# On Pi
cd ~/Ironman/src
python3 main.py
```

**Expected output:**
```
Starting CivicHeroH Edge for Camera: f47QoL9zBWtzs23FBjfo
📡 Connecting to Firebase...
✅ Loaded X ROIs from Firestore.
🤖 Loading ONNX model: ultra.onnx
✅ Detectors initialized successfully
📹 Attempting to open webcam (index 0)...
✅ Successfully connected to Webcam (index 0)
# OR if webcam not available:
📹 Falling back to test video: .../samples/test.mp4
✅ Successfully opened Test Video (test.mp4)
🔍 Starting detection...
```

---

## 🚨 Troubleshooting

### If SSH connection fails:
- Check Pi is on network: `ping 192.168.1.88`
- Verify SSH is enabled on Pi
- Check username (default: `pi`)

### If file transfer fails:
- Check disk space on Pi: `df -h`
- Verify Pi has internet: `ping google.com`
- Check permissions: `ls -la ~/Ironman`

### If setup script fails:
- Run manually: `cd ~/Ironman && python3 -m venv venv && source venv/bin/activate && pip install ultralytics opencv-python firebase-admin numpy onnxruntime picamera2`

---

## 📞 Next Steps

1. **Deploy files** (use script or manual)
2. **Run setup** on Pi
3. **Test system** with `python3 main.py`
4. **Connect USB webcam** (optional - system works with test video too!)

**You're all set!** 🎉

