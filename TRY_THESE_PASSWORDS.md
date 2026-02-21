# 🔐 Passwords to Try for SSH Login

## 🎯 Try These Passwords (In Order)

### 1. **Default Password** (Most Common)
```
raspberry
```
**This is the default password for Raspberry Pi OS.**

### 2. **Password You Set During OS Flashing**
If you used Raspberry Pi Imager and set a password:
- Use **that password** you entered in the gear icon settings
- Check if you wrote it down anywhere

### 3. **Other Common Defaults** (Less Likely)
- `raspberrypi`
- `pi`
- `password`
- `admin`
- `123456`

---

## ⚠️ If None of These Work

### Option 1: Reflash OS with Known Password

Since you forgot the password, the easiest solution is to **reflash the OS** with a password you'll remember:

1. **Use Raspberry Pi Imager** on your Mac
2. **Flash OS to USB/SD card**
3. **Click ⚙️ (gear icon)** before writing:
   - Set username: `pi`
   - Set password: `[choose a password you'll remember]` ← **Write this down!**
   - Enable SSH
4. **Write to USB/SD card**
5. **Boot Pi from USB/SD card**
6. **Connect with new password**

### Option 2: Reset Password with Display/Keyboard

If you have access to a display and keyboard:
1. Connect to Pi
2. Boot Pi
3. Run: `sudo passwd pi`
4. Enter new password twice

---

## 💡 Password Tips

### When Setting New Password:
- ✅ **Write it down** in a secure place
- ✅ Use **8+ characters**
- ✅ Mix **letters, numbers, symbols**
- ✅ Make it **memorable** but secure
- ✅ Consider using a **password manager**

### Generate Strong Password:
```bash
# On Mac
openssl rand -base64 12
```

---

## 🔍 Quick Checklist

- [ ] Tried: `raspberry` (default)
- [ ] Tried: Password from Raspberry Pi Imager settings
- [ ] Checked if you wrote password down
- [ ] If none work: Reflash OS with new password

---

## ✅ Most Likely Password

**Try `raspberry` first** - this is the default password for Raspberry Pi OS.

If that doesn't work, you probably set a password during OS flashing. If you don't remember it, reflash the OS with a new password you'll remember.

---

**Next Step**: Try `raspberry` first. If it doesn't work, reflash the OS with a password you'll remember! 🔐

