# 🔐 Reset Raspberry Pi Password - Complete Guide

## 🚨 You Forgot Your Password - Here's How to Fix It

Since you don't have a display/keyboard connected, here are your options:

---

## ✅ Option 1: Reflash OS with New Password (Easiest)

**This is the simplest solution if you don't have display/keyboard access.**

### Steps:

1. **Use Raspberry Pi Imager on your Mac**
   - Download from: https://www.raspberrypi.com/software/
   - Open Raspberry Pi Imager

2. **Flash OS to USB/SD Card**
   - Click "Choose OS" → Select "Raspberry Pi OS (64-bit)"
   - Click "Choose Storage" → Select your USB pendrive or SD card
   - **Important**: Click ⚙️ (gear icon) **BEFORE** clicking Write

3. **Configure Settings** (in the gear menu):
   - ✅ **Enable SSH** (check the box)
   - ✅ **Set username**: `pi` (or your choice)
   - ✅ **Set password**: `[your new password]` ← **Write this down!**
   - ✅ **Configure WiFi** (if using WiFi)
   - ✅ **Set hostname**: `raspberrypi` (optional)

4. **Click "Write"** and wait 5-10 minutes

5. **Boot Pi from the new USB/SD card**

6. **Connect with new password:**
   ```bash
   ssh pi@192.168.1.88
   # Password: [the new password you set]
   ```

**⚠️ Note**: This will erase everything on the Pi. You'll need to redeploy your Ironman project after this.

---

## ✅ Option 2: Reset Password with Display/Keyboard

**If you can get access to a display and keyboard:**

1. **Connect HDMI display and USB keyboard to Pi**
2. **Boot Pi**
3. **Login** (or boot to recovery mode)
4. **Reset password:**
   ```bash
   sudo passwd pi
   # Enter new password twice
   ```
5. **Done!** You can now SSH with the new password.

---

## ✅ Option 3: Use Recovery Mode (Advanced)

**If you have an SD card reader and another boot device:**

1. **Boot Pi from SD card** (if you have one)
2. **Mount the USB drive** (where your OS is)
3. **Chroot into the USB drive:**
   ```bash
   sudo mount /dev/sda2 /mnt  # Adjust device name
   sudo chroot /mnt
   passwd pi
   # Enter new password
   exit
   sudo umount /mnt
   ```
4. **Reboot from USB drive**

**⚠️ This is complex and requires Linux knowledge.**

---

## ✅ Option 4: Use Raspberry Pi Imager's Advanced Options

**Raspberry Pi Imager has a built-in option to reset password:**

1. **Open Raspberry Pi Imager**
2. **Click "Choose OS"**
3. **Scroll down to "Use custom image"** or select your OS
4. **Before writing, click ⚙️ (gear icon)**
5. **Set new password** in the configuration
6. **Write to USB/SD card**

---

## 🎯 Recommended Solution

**Since you don't have display/keyboard, Option 1 (Reflash OS) is best:**

### Why Reflash?
- ✅ **Easiest** - Just use Raspberry Pi Imager
- ✅ **Fast** - Takes 10-15 minutes total
- ✅ **Reliable** - Always works
- ✅ **Fresh start** - Clean OS installation

### What You'll Need to Do After:
1. Reflash OS with new password
2. Connect to Pi: `ssh pi@192.168.1.88`
3. Redeploy Ironman project (we can help with this)
4. Run setup script

---

## 📋 Step-by-Step: Reflash with New Password

### On Your Mac:

1. **Download Raspberry Pi Imager** (if not already installed)
   - Visit: https://www.raspberrypi.com/software/
   - Download and install

2. **Open Raspberry Pi Imager**

3. **Select OS:**
   - Click "Choose OS"
   - Select "Raspberry Pi OS (64-bit)"

4. **Select Storage:**
   - Click "Choose Storage"
   - Select your USB pendrive (or SD card)

5. **Configure (IMPORTANT!):**
   - Click ⚙️ (gear icon) in bottom right
   - ✅ Check "Enable SSH"
   - ✅ Set "Username": `pi`
   - ✅ Set "Password": `[your new password]` ← **Write this down!**
   - ✅ Set "WiFi SSID" (if using WiFi)
   - ✅ Set "WiFi Password" (if using WiFi)
   - Click "Save"

6. **Write:**
   - Click "Write"
   - Wait 5-10 minutes
   - Click "Continue" when done

7. **Insert USB into Pi and boot**

8. **Wait 2-3 minutes** for Pi to boot

9. **Connect:**
   ```bash
   ssh pi@192.168.1.88
   # Password: [your new password]
   ```

---

## 🔐 Password Best Practices

### When Setting New Password:
- ✅ **Write it down** in a secure place
- ✅ Use **8+ characters**
- ✅ Mix **letters, numbers, symbols**
- ✅ Don't use default "raspberry"
- ✅ Consider using a password manager

### Generate Strong Password:
```bash
# On Mac
openssl rand -base64 12
```

---

## 💡 After Password Reset

Once you have access again:

1. **Set up SSH keys** (so you don't need password):
   ```bash
   # On Mac
   ssh-keygen -t ed25519
   ssh-copy-id pi@192.168.1.88
   ```

2. **Change password to something memorable:**
   ```bash
   # On Pi
   passwd
   ```

3. **Deploy Ironman project:**
   ```bash
   # On Mac
   cd /Users/kavin/Development/projects/1/Ironman
   scp -r . pi@192.168.1.88:~/Ironman
   ```

---

## 🚨 Important Notes

### Before Reflashing:
- ⚠️ **All data on Pi will be erased**
- ⚠️ You'll need to redeploy your project
- ⚠️ Make sure you have the Ironman files on your Mac

### After Reflashing:
- ✅ Write down the new password
- ✅ Test SSH connection immediately
- ✅ Set up SSH keys to avoid this in the future

---

## ✅ Quick Checklist

- [ ] Download Raspberry Pi Imager
- [ ] Insert USB pendrive/SD card
- [ ] Flash OS with new password
- [ ] Write down the new password
- [ ] Boot Pi from USB/SD card
- [ ] Wait 2-3 minutes for boot
- [ ] Test SSH: `ssh pi@192.168.1.88`
- [ ] Redeploy Ironman project

---

## 🎯 Next Steps

1. **Reflash OS** with Raspberry Pi Imager (set new password)
2. **Connect** with new password
3. **Let me know** when you're connected, and I'll help deploy Ironman!

**The easiest solution is to reflash the OS with a new password using Raspberry Pi Imager. It takes about 10-15 minutes total!** 🔐

