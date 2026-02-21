# 🔧 Fix: Copy to SD Card - macOS Limitation

## ⚠️ Issue: macOS Can't Write to ext4

**Problem:**
- macOS only mounts the **boot partition** (`bootfs`)
- The **rootfs partition** (ext4) is **not writable** on macOS
- That's why `/Volumes/rootfs/home/raspberrypi/` doesn't exist

---

## ✅ Solution: Copy to Boot Partition, Move on Pi

### Step 1: Copy Files to Boot Partition

**The boot partition is mounted as `/Volumes/bootfs`**

```bash
cd /Users/kavin/Development/projects/1/Ironman

# Create directory on boot partition
mkdir -p /Volumes/bootfs/Ironman

# Copy files (excluding large venv)
rsync -av --progress \
    --exclude 'venv/' \
    --exclude '__pycache__/' \
    --exclude '*.pyc' \
    --exclude '.git/' \
    --exclude '.DS_Store' \
    --exclude 'samples/temp_captures/' \
    ./ /Volumes/bootfs/Ironman/
```

**Or use simple cp:**
```bash
cp -r . /Volumes/bootfs/Ironman/
```

### Step 2: On Pi, Move Files to Home Directory

**After booting Pi:**

```bash
# Move files from boot partition to home
sudo mv /boot/Ironman ~/Ironman

# Set permissions
chmod +x ~/Ironman/setup_pi.sh
chown -R raspberrypi:raspberrypi ~/Ironman

# Run setup
cd ~/Ironman
./setup_pi.sh
```

---

## 🎯 Alternative: Use Network Transfer Instead

**Since macOS can't write to ext4, network transfer might be easier:**

```bash
cd /Users/kavin/Development/projects/1/Ironman
scp -r . raspberrypi@192.168.1.132:~/Ironman
# Enter password: kavin@2006
```

**This takes 1-2 minutes but is simpler!**

---

## 📋 Quick Commands

### Copy to Boot Partition:
```bash
cd /Users/kavin/Development/projects/1/Ironman
mkdir -p /Volumes/bootfs/Ironman
cp -r . /Volumes/bootfs/Ironman/
```

### On Pi (after booting):
```bash
sudo mv /boot/Ironman ~/Ironman
chmod +x ~/Ironman/setup_pi.sh
cd ~/Ironman
./setup_pi.sh
```

---

## ✅ Summary

**Two Options:**

1. **Copy to boot partition** → Move on Pi (works but requires moving)
2. **Network transfer** → Direct to Pi (simpler, takes 1-2 min)

**I recommend network transfer** - it's simpler and files go directly to the right place! 🚀

