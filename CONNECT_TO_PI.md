# 🔌 Connect to Raspberry Pi - Step by Step

## ✅ Pi is Reachable!

Your Pi is online at `192.168.1.88` and SSH is working.

---

## 🔑 Connect Now (Manual Step Required)

**I cannot enter passwords automatically**, but here's exactly what to do:

### Step 1: Open Terminal on Your Mac

Open a new terminal window (or use the one you have open).

### Step 2: Connect to Pi

```bash
ssh pi@192.168.1.88
```

### Step 3: Enter Password

When prompted, enter:
- **Default password**: `raspberry`
- **Or**: The password you set during OS setup

**Note**: The password won't show on screen as you type (this is normal for security).

### Step 4: You're In!

Once connected, you'll see:
```
pi@raspberrypi:~ $
```

---

## 🚀 After Connecting - Quick Setup

Once you're logged in, run these commands:

### 1. Change Password (Recommended)
```bash
passwd
# Enter current password: raspberry
# Enter new password: [your new password]
# Confirm new password: [your new password]
```

### 2. Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### 3. Check System Info
```bash
hostname -I    # Check IP address
uname -a       # Check system info
df -h          # Check disk space
```

---

## 🔐 Set Up SSH Keys (No Password Needed!)

After you connect once, we can set up SSH keys so you don't need a password:

### On Your Mac (in a new terminal):

```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t ed25519 -C "your_email@example.com"
# Press Enter to accept default location
# Press Enter twice for no passphrase (or set one)

# Copy key to Pi
ssh-copy-id pi@192.168.1.88
# Enter password: raspberry
```

**After this, you can connect without password!**

---

## 📋 Deploy Ironman Project

Once you're connected to Pi:

### On Your Mac (in another terminal):

```bash
cd /Users/kavin/Development/projects/1/Ironman

# Transfer files
scp -r . pi@192.168.1.88:~/Ironman
# Enter password when prompted
```

### On Pi (after files are transferred):

```bash
cd ~/Ironman
chmod +x setup_pi.sh
./setup_pi.sh
```

---

## 🎯 Quick Command Reference

| Task | Command |
|------|---------|
| **Connect to Pi** | `ssh pi@192.168.1.88` |
| **Change password** | `passwd` |
| **Check IP** | `hostname -I` |
| **Update system** | `sudo apt update && sudo apt upgrade -y` |
| **Transfer files** | `scp -r . pi@192.168.1.88:~/Ironman` |

---

## ⚠️ Troubleshooting

### If "Permission denied":
- Check password is correct (default: `raspberry`)
- Make sure you're using username `pi`
- Try: `ssh -v pi@192.168.1.88` for verbose output

### If "Connection refused":
- Check SSH is enabled: `sudo systemctl status ssh` (on Pi)
- Check Pi is on network: `ping 192.168.1.88`

### If connection is slow:
- This is normal for first connection
- Subsequent connections will be faster

---

## ✅ Next Steps

1. **Connect now**: `ssh pi@192.168.1.88` (enter password)
2. **Change password**: `passwd`
3. **Transfer files**: Use `scp` from Mac
4. **Run setup**: `./setup_pi.sh` on Pi

**Your Pi is ready! Just connect manually and enter the password.** 🚀

