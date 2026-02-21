# Headless Raspberry Pi Setup (No Display Needed)

Complete guide for setting up and running CivicHero Ironman on Raspberry Pi 5 without a display.

## ✅ Your Pi Status

**Green LED blinking** = ✅ **Normal operation!**
- Pi is powered on
- SD card is active
- System is running

**LAN connected** = ✅ **Network ready!**
- Ethernet connected
- Should have IP address
- Ready for SSH access

---

## 🔍 Step 1: Find Your Pi's IP Address

### Method 1: Check Your Router

1. Log into your router admin panel (usually `192.168.1.1` or `192.168.0.1`)
2. Look for connected devices
3. Find "raspberrypi" or device with MAC address starting with `B8:27:EB` or `DC:A6:32`
4. Note the IP address (e.g., `192.168.1.100`)

### Method 2: Use Network Scanner (From Mac)

```bash
# Scan your local network
nmap -sn 192.168.1.0/24

# Or try ping
ping raspberrypi.local
```

### Method 3: Check Connected Devices

If you have access to your router's admin page, check DHCP client list.

---

## 🔌 Step 2: SSH Into Your Pi

### From Your Mac Terminal:

```bash
# Try default hostname first
ssh pi@raspberrypi.local

# Or if that doesn't work, use IP directly
ssh pi@<PI_IP_ADDRESS>

# Example:
ssh pi@192.168.1.100
```

### Default Credentials:

- **Username**: `pi` (or the username you set during OS installation)
- **Password**: The password you set during OS installation

### If SSH Doesn't Work:

1. **Check if SSH is enabled:**
   - If you used Raspberry Pi Imager, SSH should be enabled if you configured it
   - If not, you may need to enable it manually (see troubleshooting)

2. **Check firewall:**
   - Make sure port 22 is not blocked

---

## 🚀 Step 3: Once Connected via SSH

### Verify Connection:

```bash
# Check you're on the Pi
hostname
# Should show: raspberrypi

# Check IP address
hostname -I
# Should show your Pi's IP

# Check internet connection
ping -c 3 google.com
# Should work if internet is connected
```

### Transfer Files:

From your Mac (in a new terminal):

```bash
# Navigate to Ironman folder
cd /Users/kavin/Development/projects/1

# Transfer to Pi
scp -r Ironman pi@raspberrypi.local:~/

# Or use IP
scp -r Ironman pi@<PI_IP>:~/
```

---

## 📦 Step 4: Setup on Pi (Via SSH)

Once SSH'd into Pi:

```bash
# Navigate to Ironman folder
cd ~/Ironman

# Make setup script executable
chmod +x setup_pi.sh

# Run setup
./setup_pi.sh
```

This will:
- Install all dependencies
- Create virtual environment
- Install Python packages
- Set up systemd service (optional)

---

## 🎥 Step 5: Run Headless (No Display)

The code needs to be updated for headless mode (no display window).

### Option 1: Run with X11 Forwarding (if you want to see window)

```bash
# On Mac, enable X11 forwarding
ssh -X pi@raspberrypi.local

# Then run (window will appear on Mac)
cd ~/Ironman/src
python3 main.py
```

### Option 2: Run Headless (Recommended)

Update code to run without display window (I'll do this next).

---

## 🔧 Troubleshooting

### SSH Connection Issues:

**Problem**: "Connection refused" or "Host not found"

**Solutions**:
1. **Enable SSH** (if not enabled):
   - Create empty file: `touch /Volumes/boot/ssh` (on SD card)
   - Or use Raspberry Pi Imager's advanced options

2. **Check IP address**:
   ```bash
   # On Mac, scan network
   arp -a | grep -i "b8:27:eb\|dc:a6:32"
   ```

3. **Try different methods**:
   ```bash
   # Try hostname
   ssh pi@raspberrypi.local
   
   # Try common IPs
   ssh pi@192.168.1.100
   ssh pi@192.168.0.100
   ```

### Green LED Blinking:

- ✅ **Normal**: Blinking = SD card activity (good!)
- ✅ **Network**: LAN activity can cause blinking
- ⚠️ **Issue**: If it stops blinking completely, Pi might be frozen

### No Internet:

```bash
# Check network
ping google.com

# Check DNS
cat /etc/resolv.conf

# Restart network
sudo systemctl restart networking
```

---

## 📝 Quick Commands Reference

### Find Pi IP (from Mac):

```bash
# Scan network
nmap -sn 192.168.1.0/24 | grep -B 2 "Raspberry"

# Or check router admin page
```

### Connect to Pi:

```bash
ssh pi@raspberrypi.local
# or
ssh pi@<IP_ADDRESS>
```

### Transfer Files:

```bash
# From Mac to Pi
scp -r Ironman pi@raspberrypi.local:~/

# From Pi to Mac
scp pi@raspberrypi.local:~/file.txt ./
```

### Run Code:

```bash
# On Pi via SSH
cd ~/Ironman/src
python3 main.py
```

---

## ✅ Next Steps

1. **Find Pi IP** (check router or scan network)
2. **SSH into Pi** (`ssh pi@raspberrypi.local`)
3. **Transfer files** (`scp -r Ironman pi@...`)
4. **Run setup** (`./setup_pi.sh`)
5. **Update code for headless** (I'll do this)
6. **Run detection system**

---

**You don't need a display!** Everything can be done via SSH. 🚀



