# 💾 Copy Files to SD Card Using Card Reader

## ✅ Yes! This is Actually Faster!

Copying directly to the SD card is **much faster** than network transfer:
- ✅ **No network speed limits** - Direct USB 3.0 speed
- ✅ **Faster transfer** - Usually 2-5x faster than WiFi
- ✅ **No password needed** - Just copy files
- ✅ **More reliable** - No network issues

---

## 📋 Step-by-Step Guide

### Step 1: Safely Eject SD Card from Pi

**On Pi (if connected via SSH):**
```bash
sudo sync  # Flush all data to disk
sudo umount /dev/sda1  # Unmount if needed
```

**Or just:**
- Power off the Pi
- Remove the SD card

### Step 2: Insert SD Card into Card Reader

1. **Insert SD card** into your card reader
2. **Connect card reader** to your Mac
3. **Wait** for Mac to recognize the card

### Step 3: Find the SD Card on Mac

**Check if SD card is mounted:**
```bash
ls -la /Volumes/
```

**You should see something like:**
- `boot` (boot partition)
- `rootfs` or `root` (main partition)

**Or check Disk Utility:**
- Open **Disk Utility** (Applications → Utilities)
- Look for external devices

### Step 4: Copy Files to SD Card

**Option A: Copy to Home Directory (Recommended)**

```bash
cd /Users/kavin/Development/projects/1/Ironman

# Find the SD card mount point
# Usually: /Volumes/rootfs or /Volumes/root

# Copy files to Pi's home directory
cp -r . /Volumes/rootfs/home/raspberrypi/Ironman/
```

**Option B: Copy to /tmp First, Then Move on Pi**

```bash
cd /Users/kavin/Development/projects/1/Ironman

# Copy to SD card's /tmp directory
cp -r . /Volumes/rootfs/tmp/Ironman/
```

**Then on Pi (after booting):**
```bash
mv /tmp/Ironman ~/Ironman
```

### Step 5: Set Permissions (Important!)

**After copying, set correct permissions:**

```bash
# On Mac, after copying:
sudo chown -R 1000:1000 /Volumes/rootfs/home/raspberrypi/Ironman
sudo chmod +x /Volumes/rootfs/home/raspberrypi/Ironman/setup_pi.sh
```

**Or do it on Pi after booting:**
```bash
chmod +x ~/Ironman/setup_pi.sh
chown -R raspberrypi:raspberrypi ~/Ironman
```

### Step 6: Eject SD Card Safely

**On Mac:**
```bash
diskutil eject /Volumes/rootfs
diskutil eject /Volumes/boot
```

**Or use Finder:**
- Right-click SD card → Eject

### Step 7: Insert SD Card Back into Pi

1. **Insert SD card** into Pi
2. **Boot Pi**
3. **Files are already there!**

---

## 🎯 Quick Copy Command

**Once SD card is mounted, run:**

```bash
cd /Users/kavin/Development/projects/1/Ironman

# Find SD card mount point (adjust if different)
SD_CARD="/Volumes/rootfs"  # or /Volumes/root

# Copy files (excluding venv, .git, etc.)
rsync -av --progress \
    --exclude 'venv/' \
    --exclude '__pycache__/' \
    --exclude '*.pyc' \
    --exclude '.git/' \
    --exclude '.DS_Store' \
    --exclude 'samples/temp_captures/' \
    ./ "$SD_CARD/home/raspberrypi/Ironman/"

# Set permissions
sudo chown -R 1000:1000 "$SD_CARD/home/raspberrypi/Ironman"
sudo chmod +x "$SD_CARD/home/raspberrypi/Ironman/setup_pi.sh"
```

---

## ⚠️ Important Notes

### File System Compatibility:
- **SD card uses Linux file system** (ext4)
- **Mac can read it** but may have limitations
- **Use `rsync` or `cp`** - works fine

### Permissions:
- Files copied from Mac may have wrong permissions
- **Fix on Pi** after booting:
  ```bash
  chmod +x ~/Ironman/setup_pi.sh
  chown -R raspberrypi:raspberrypi ~/Ironman
  ```

### Large Files:
- **ultra.onnx (97MB)** will copy quickly via USB 3.0
- **Much faster** than network transfer!

---

## 📊 Speed Comparison

| Method | Speed | Time (for 110MB) |
|--------|-------|------------------|
| **SD Card (USB 3.0)** | 20-50 MB/s | **2-5 seconds** ⚡ |
| **WiFi Transfer** | 2-5 MB/s | 20-60 seconds |
| **Ethernet** | 10-20 MB/s | 5-15 seconds |

**SD Card is fastest!** 🚀

---

## ✅ Checklist

- [ ] SD card removed from Pi
- [ ] Card reader connected to Mac
- [ ] SD card mounted (check `/Volumes/`)
- [ ] Files copied to SD card
- [ ] Permissions set correctly
- [ ] SD card safely ejected
- [ ] SD card inserted back into Pi
- [ ] Pi booted and files verified

---

## 🎯 After Copying

**On Pi (after booting):**

```bash
# Verify files are there
ls -la ~/Ironman/

# Check permissions
ls -l ~/Ironman/setup_pi.sh

# Fix permissions if needed
chmod +x ~/Ironman/setup_pi.sh
chown -R raspberrypi:raspberrypi ~/Ironman

# Run setup
cd ~/Ironman
./setup_pi.sh
```

---

## 💡 Pro Tips

1. **Use rsync** - Shows progress and can resume
2. **Copy to /tmp first** - Safer, then move on Pi
3. **Check disk space** - Make sure SD card has enough space
4. **Verify after copy** - Check file sizes match

---

## ✅ Summary

**Yes, you can copy directly to SD card!**

- ✅ **Much faster** than network transfer
- ✅ **No password needed**
- ✅ **More reliable**
- ✅ **Takes 2-5 seconds** instead of 1-2 minutes

**This is actually the best method if you have a card reader!** 💾

