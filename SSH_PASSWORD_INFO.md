# 🔐 Raspberry Pi SSH Password Information

## 🔑 Default Passwords

### Standard Raspberry Pi OS Default:
- **Username**: `pi`
- **Password**: `raspberry`

### If You Set It Up with Raspberry Pi Imager:
- **Username**: Whatever you set during imaging (default: `pi`)
- **Password**: Whatever password you set during imaging

### If You Forgot the Password:
- You set it during OS flashing in Raspberry Pi Imager
- Check if you wrote it down
- Or reflash OS with a new password

---

## 🔍 How to Find Your Password

### Option 1: Check Your Notes
- Did you write down the password when flashing the OS?
- Check Raspberry Pi Imager settings if you saved them

### Option 2: Try Default Password
```bash
ssh pi@192.168.1.88
# Password: raspberry
```

### Option 3: Check Raspberry Pi Imager Settings
If you used Raspberry Pi Imager:
1. Open Raspberry Pi Imager
2. Check if you saved the configuration
3. The password might be in the saved settings

---

## 🔧 If You Don't Know the Password

### Option 1: Reset Password (If You Have Display/Keyboard)

1. **Connect display and keyboard to Pi**
2. **Boot Pi and login** (or boot to recovery mode)
3. **Reset password:**
   ```bash
   sudo passwd pi
   # Enter new password twice
   ```

### Option 2: Reflash OS with New Password

1. **Use Raspberry Pi Imager** on your Mac
2. **Flash OS to USB/SD card**
3. **Click ⚙️ (gear icon)** before writing:
   - ✅ Set username: `pi` (or your choice)
   - ✅ Set password: `[your new password]` ← **Write this down!**
   - ✅ Enable SSH
4. **Write to USB/SD card**
5. **Boot Pi** - Use the new password you set

### Option 3: Use Recovery Mode (Advanced)

If you have an SD card reader:
1. Boot from SD card
2. Mount USB drive
3. Edit `/etc/shadow` or use `chroot`
4. Reset password

---

## 🎯 Quick Test: Try Default Password

**Most common default password is `raspberry`**

Try this:
```bash
ssh pi@192.168.1.88
# When prompted for password, type: raspberry
```

**If that doesn't work**, the password was changed during setup.

---

## 📝 Password Best Practices

### When Setting New Password:
- ✅ Use a strong password (8+ characters, mix of letters/numbers)
- ✅ **Write it down** in a secure place
- ✅ Don't use default "raspberry" in production

### Generate Strong Password:
```bash
# On Mac/Linux
openssl rand -base64 12
```

---

## 🚨 If You're Locked Out

### Scenario 1: Forgot Password, Have Display
- Connect display/keyboard
- Boot Pi
- Login (or use recovery)
- Run: `sudo passwd pi`

### Scenario 2: Forgot Password, No Display
- **Best option**: Reflash OS with Raspberry Pi Imager
- Set a new password during flashing
- **Write it down this time!**

### Scenario 3: SSH Not Working
- Check if SSH is enabled: `sudo systemctl status ssh`
- Check if Pi is on network: `ping 192.168.1.88`
- Try connecting with display/keyboard first

---

## ✅ Step-by-Step: First Time Login

**If this is your first time connecting:**

1. **Try default password:**
   ```bash
   ssh pi@192.168.1.88
   # Password: raspberry
   ```

2. **If default doesn't work:**
   - Password was changed during setup
   - Check your notes/Imager settings
   - Or reflash OS with known password

3. **After successful login, immediately change password:**
   ```bash
   passwd
   # Enter current password
   # Enter new password (twice)
   ```

---

## 🔐 Common Passwords to Try

If you don't remember setting a password, try these common defaults:

1. `raspberry` ← **Most common default**
2. `raspberrypi`
3. `pi`
4. `password`
5. `admin`
6. `123456`

**⚠️ Note**: If none of these work, the password was definitely changed during setup.

---

## 💡 Pro Tip: Set Up SSH Keys (No Password Needed)

Once you're logged in, set up SSH keys so you don't need a password:

**On your Mac:**
```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t ed25519

# Copy to Pi
ssh-copy-id pi@192.168.1.88
```

**Then you can login without password!**

---

## 📋 Quick Reference

| Situation | Solution |
|-----------|----------|
| **First time login** | Try password: `raspberry` |
| **Forgot password** | Reflash OS with new password |
| **Have display/keyboard** | Reset password: `sudo passwd pi` |
| **Want no password** | Set up SSH keys |

---

**Most likely password**: `raspberry` (default)

Try it first! If it doesn't work, you'll need to reflash the OS or reset the password using a display/keyboard.

