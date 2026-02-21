# ✅ Deployment Confirmation - Raspberry Pi 5

## 🎯 Yes, you can deploy to Raspberry Pi 5!

Your system is **ready for deployment** and has **automatic fallback** configured.

---

## 📹 Video Source Priority (Automatic Fallback)

The system will try video sources in this order:

1. **PRIMARY**: USB Webcam (index 0) 
   - Tries to connect to USB webcam first
   - This is what you'll use on Raspberry Pi 5

2. **FALLBACK**: Test Video (`samples/test.mp4`)
   - **Automatically activates** if webcam fails to connect
   - **Automatically activates** if webcam cannot read frames
   - Loops the video continuously for testing

3. **EXIT**: Only if both webcam AND video file fail

---

## ✅ Confirmed Behavior

### On Raspberry Pi 5:

**Scenario 1: USB Webcam Connected**
```
📹 Attempting to open webcam (index 0)...
✅ Successfully connected to Webcam (index 0)
→ Uses webcam for detection
```

**Scenario 2: USB Webcam NOT Connected**
```
📹 Attempting to open webcam (index 0)...
⚠️  Cannot open webcam (index 0)
📹 Falling back to test video: .../samples/test.mp4
✅ Successfully opened Test Video (test.mp4)
→ Uses test video for detection (loops continuously)
```

**Scenario 3: Both Fail (Very Rare)**
```
❌ Failed to open any video source. Exiting.
→ System exits (this should never happen if test.mp4 exists)
```

---

## 🔧 Current Configuration

In `src/main.py`:
- `VIDEO_SOURCE = 0` ← USB webcam (primary for Pi)
- `FALLBACK_CAMERA = 1` ← Fallback camera (useful on Mac)
- `FALLBACK_VIDEO = "samples/test.mp4"` ← Automatic fallback

**The fallback is automatic - no configuration needed!**

---

## 🚀 Deployment Steps

### 1. Transfer Files to Raspberry Pi

```bash
# Option A: SCP (if Pi is on network)
scp -r Ironman pi@raspberrypi.local:~/

# Option B: USB Drive
# Copy entire Ironman folder to USB drive, then copy to Pi
```

### 2. Run Setup Script

```bash
# SSH into Pi
ssh pi@raspberrypi.local

# Navigate to Ironman folder
cd ~/Ironman

# Make setup script executable
chmod +x setup_pi.sh

# Run setup
./setup_pi.sh
```

### 3. Connect USB Webcam (Optional)

- If you connect USB webcam → System uses webcam
- If you DON'T connect webcam → System automatically uses test video

**No configuration changes needed!**

### 4. Run the System

```bash
cd ~/Ironman/src
python3 main.py
```

**What happens:**
- ✅ Tries USB webcam first
- ✅ Falls back to test video if webcam not available
- ✅ Detects potholes automatically
- ✅ Creates incidents in Firebase

---

## 📋 What You Need

### Required Files (Already in Ironman folder):
- ✅ `ultra.onnx` - Detection model
- ✅ `serviceAccountKey.json` - Firebase credentials
- ✅ `src/samples/test.mp4` - Fallback test video
- ✅ All Python source files

### Hardware:
- ✅ Raspberry Pi 5
- ✅ USB Webcam (optional - system works without it!)
- ✅ Internet connection (for Firebase)

---

## ✅ Verification

After deployment, you should see:

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
📹 Video Source: Webcam (index 0) / Test Video (test.mp4)
🔍 Starting detection...
```

---

## 🎯 Summary

**YES, you can deploy to Raspberry Pi 5!**

✅ **Automatic fallback is configured**
- Tries webcam first
- Falls back to test video automatically
- No manual configuration needed

✅ **Works with or without webcam**
- With webcam: Uses live feed
- Without webcam: Uses test video

✅ **Ready to deploy**
- All files in place
- Fallback logic working
- Firebase integration ready

---

## 🚀 Next Steps

1. **Transfer files to Pi** (SCP or USB)
2. **Run setup script** (`./setup_pi.sh`)
3. **Connect USB webcam** (optional)
4. **Run the system** (`python3 main.py`)

**That's it! The system will automatically handle everything.** 🎉

---

**Last Updated**: February 2025


