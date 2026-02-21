# USB Boot Guide for Raspberry Pi 5

Complete guide for installing and booting Raspberry Pi OS from a USB pendrive on Raspberry Pi 5.

## 🎯 Why Use USB Boot?

✅ **Faster Performance** - USB 3.0 drives are typically faster than SD cards  
✅ **More Reliable** - USB drives have better wear leveling  
✅ **Larger Capacity** - Easier to get larger storage  
✅ **Better for Edge Computing** - More reliable for 24/7 operation  
✅ **Native Support** - Raspberry Pi 5 has excellent USB boot support

---

## 📋 Requirements

- **Raspberry Pi 5** (USB boot is well-supported)
- **USB Pendrive/USB SSD** (32GB+ recommended, USB 3.0 preferred)
- **Computer** with Raspberry Pi Imager installed
- **Optional**: MicroSD card (for initial boot configuration if needed)

---

## 🚀 Step-by-Step USB Boot Setup

### Step 1: Prepare USB Drive

1. **Connect USB drive** to your computer
2. **Backup any data** (the drive will be erased)
3. **Format if needed** (Raspberry Pi Imager will handle this)

### Step 2: Flash Raspberry Pi OS to USB

1. **Download Raspberry Pi Imager**
   - Visit: https://www.raspberrypi.com/software/
   - Download for your OS (Windows/Mac/Linux)

2. **Open Raspberry Pi Imager**

3. **Choose OS**
   - Click **"Choose OS"**
   - Select **"Raspberry Pi OS (64-bit)"** (Bookworm or later)
   - Or choose **"Raspberry Pi OS (other)"** → **"Raspberry Pi OS (64-bit)"**

4. **Choose Storage**
   - Click **"Choose Storage"**
   - **Important**: Select your **USB pendrive** (not SD card)
   - Make sure you select the correct drive!

5. **Configure Settings** (Click the gear icon ⚙️)
   - ✅ **Enable SSH**: Check this box
   - ✅ **Set username**: `pi` (or your preferred username)
   - ✅ **Set password**: Choose a secure password
   - ✅ **Configure WiFi**: 
     - SSID: Your WiFi network name
     - Password: Your WiFi password
     - Country: Your country code
   - ✅ **Set locale**: Choose your timezone
   - ✅ **Enable public key authentication** (optional, for advanced users)

6. **Write to USB**
   - Click **"Write"**
   - Confirm the drive selection
   - Wait for the process to complete (5-15 minutes depending on drive speed)

### Step 3: Enable USB Boot on Raspberry Pi 5

Raspberry Pi 5 supports USB boot, but you may need to configure it:

**Method 1: Using Raspberry Pi Imager (Easiest)**

1. The latest Raspberry Pi Imager automatically configures USB boot
2. After flashing, the USB drive should boot directly

**Method 2: Manual Configuration (If needed)**

If USB boot doesn't work automatically:

1. **Boot from SD card first** (temporary):
   - Flash a minimal OS to SD card
   - Or use an existing SD card with Pi OS

2. **Enable USB Boot**:
   ```bash
   # Option A: Using raspi-config
   sudo raspi-config
   # Navigate to: Advanced Options → Boot Order → USB Boot
   
   # Option B: Using rpi-eeprom-config
   sudo rpi-eeprom-config --edit
   # Set: BOOT_ORDER=0xf41
   # This means: Try USB first, then SD card
   ```

3. **Reboot**:
   ```bash
   sudo reboot
   ```

4. **Remove SD card** after confirming USB boot works

### Step 4: Boot from USB

1. **Insert USB drive** into Raspberry Pi 5 (USB 3.0 port recommended)
2. **Power on** the Raspberry Pi
3. **Wait for boot** (may take 30-60 seconds first time)
4. **Verify boot source**:
   ```bash
   # Check boot partition
   lsblk
   # Should show USB drive as root filesystem
   
   # Check boot order
   vcgencmd bootloader_config
   ```

---

## 🔧 Troubleshooting USB Boot

### Issue: Pi won't boot from USB

**Solutions:**
1. **Check USB drive compatibility**
   - Use USB 3.0 drive if possible
   - Try different USB port (use USB 3.0 ports)
   - Some drives may not be compatible

2. **Verify boot order**
   ```bash
   vcgencmd bootloader_config | grep BOOT_ORDER
   # Should show: BOOT_ORDER=0xf41
   ```

3. **Check USB drive format**
   - Ensure it's formatted correctly
   - Re-flash using Raspberry Pi Imager

4. **Try different USB drive**
   - Some drives work better than others
   - USB SSDs are most reliable

### Issue: Slow boot or performance

**Solutions:**
1. **Use USB 3.0 drive** (not USB 2.0)
2. **Use USB 3.0 port** on Pi 5
3. **Use USB SSD** instead of flash drive
4. **Check drive health**:
   ```bash
   sudo smartctl -a /dev/sda  # Replace sda with your drive
   ```

### Issue: Drive not detected

**Solutions:**
1. **Check USB connection** (try different port)
2. **Verify drive works** on another computer
3. **Check power supply** (27W recommended for Pi 5)
4. **Try different USB cable** (if using external drive)

---

## 📊 Performance Comparison

| Storage Type | Boot Time | Read Speed | Write Speed | Reliability |
|--------------|-----------|------------|-------------|-------------|
| SD Card (Class 10) | ~30s | ~20 MB/s | ~15 MB/s | Good |
| USB 2.0 Flash | ~25s | ~30 MB/s | ~20 MB/s | Good |
| USB 3.0 Flash | ~20s | ~100 MB/s | ~50 MB/s | Very Good |
| USB 3.0 SSD | ~15s | ~500 MB/s | ~400 MB/s | Excellent |

**Recommendation**: Use USB 3.0 SSD for best performance!

---

## ✅ Verification Checklist

After USB boot setup:

- [ ] USB drive boots successfully
- [ ] SSH connection works
- [ ] WiFi/Ethernet connected
- [ ] System updates work: `sudo apt update`
- [ ] Performance is acceptable
- [ ] No boot errors in logs: `dmesg | grep -i error`

---

## 🎯 Next Steps

After successful USB boot:

1. ✅ Follow **RASPBERRY_PI_SETUP.md** for system setup
2. ✅ Run **setup_pi.sh** to install dependencies
3. ✅ Configure CivicHero Ironman system
4. ✅ Set up auto-start service

---

## 💡 Tips

1. **Use USB 3.0 SSD** for best performance
2. **Keep SD card as backup** (with minimal boot config)
3. **Monitor drive health** regularly
4. **Use quality USB drive** (avoid cheap, unknown brands)
5. **Backup important data** regularly

---

## 📝 Notes

- Raspberry Pi 5 has **excellent USB boot support** - it's the recommended method
- USB 3.0 drives are **faster and more reliable** than SD cards
- USB SSDs provide **best performance** for edge computing applications
- Make sure to use **adequate power supply** (27W for Pi 5)

---

**Last Updated:** February 2025  
**Compatible with:** Raspberry Pi 5, Raspberry Pi OS Bookworm+




