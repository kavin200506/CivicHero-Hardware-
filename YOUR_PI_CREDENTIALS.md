# 🔐 Your Raspberry Pi Credentials

## ✅ Your Login Information

Based on your Raspberry Pi Imager configuration:

- **Username**: `raspberrypi` (not `pi`)
- **Password**: `kavin@2006`
- **IP Address**: `192.168.1.132` (current)

---

## 🔌 Connect to Your Pi

### SSH Connection Command:

```bash
ssh raspberrypi@192.168.1.132
```

**When prompted for password, enter:**
```
kavin@2006
```

**Note**: The password won't show on screen as you type (this is normal for security).

---

## ⚠️ Important Notes

### Username Difference:
- Your username is: `raspberrypi` (not the default `pi`)
- Make sure to use the correct username when connecting

### Password:
- Your password: `kavin@2006`
- Keep this secure and don't share it
- Consider writing it down in a secure place

---

## 🚀 After Connecting

Once you're logged in, you can:

### 1. Verify Connection:
```bash
hostname -I    # Check IP address
hostname       # Should show raspberrypi
whoami         # Should show raspberrypi
```

### 2. Update System:
```bash
sudo apt update && sudo apt upgrade -y
```

### 3. Deploy Ironman Project:
```bash
# On your Mac (in another terminal):
cd /Users/kavin/Development/projects/1/Ironman
scp -r . raspberrypi@192.168.1.132:~/Ironman
# Enter password: kavin@2006
```

### 4. Run Setup on Pi:
```bash
# On Pi (after files are transferred):
cd ~/Ironman
chmod +x setup_pi.sh
./setup_pi.sh
```

---

## 📋 Quick Reference

| Item | Value |
|------|-------|
| **Username** | `raspberrypi` |
| **Password** | `kavin@2006` |
| **IP Address** | `192.168.1.132` |
| **SSH Command** | `ssh raspberrypi@192.168.1.132` |

---

## ✅ Next Steps

1. **Connect now**: `ssh raspberrypi@192.168.1.132`
2. **Enter password**: `kavin@2006`
3. **Once connected**, let me know and I'll help deploy the Ironman project!

---

**Your credentials are set! Use `raspberrypi` as username and `kavin@2006` as password.** 🔐

