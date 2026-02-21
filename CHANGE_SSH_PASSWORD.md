# 🔐 Change SSH Password and Settings on Raspberry Pi

## ✅ Yes, you can change SSH password and settings after login!

Once you're logged into your Raspberry Pi (via SSH or directly), you can modify SSH settings and change passwords.

---

## 🔑 Change Your Password

### Method 1: Using `passwd` command (Easiest)

```bash
# After logging in via SSH or directly
passwd
```

**What happens:**
1. Enter your **current password**
2. Enter your **new password** (twice)
3. Password is changed immediately!

**Example:**
```bash
pi@raspberrypi:~ $ passwd
Changing password for pi.
Current password: [enter current password]
New password: [enter new password]
Retype new password: [enter new password again]
passwd: password updated successfully
```

### Method 2: Change Another User's Password (if you have sudo)

```bash
sudo passwd pi
# Or for any user:
sudo passwd username
```

---

## 🔧 Change SSH Settings

### Enable/Disable SSH

```bash
# Enable SSH
sudo systemctl enable ssh
sudo systemctl start ssh

# Disable SSH
sudo systemctl stop ssh
sudo systemctl disable ssh

# Check SSH status
sudo systemctl status ssh
```

### Configure SSH Settings

Edit SSH configuration file:

```bash
sudo nano /etc/ssh/sshd_config
```

**Common settings to change:**

1. **Change SSH Port** (for security):
   ```
   # Find this line:
   #Port 22
   # Change to:
   Port 2222  # Or any port you want
   ```

2. **Disable Password Login** (use keys only):
   ```
   PasswordAuthentication no
   PubkeyAuthentication yes
   ```

3. **Disable Root Login**:
   ```
   PermitRootLogin no
   ```

4. **Allow Specific Users**:
   ```
   AllowUsers pi
   ```

**After editing, restart SSH:**
```bash
sudo systemctl restart ssh
```

**⚠️ Important**: If you change the SSH port, make sure you can still access it before closing your current session!

---

## 🔐 Change Root Password (if needed)

```bash
# Enable root login (if disabled)
sudo passwd root

# Or disable root login (recommended)
sudo passwd -l root
```

---

## 🛡️ Security Best Practices

### 1. Use Strong Password

```bash
# Generate a strong password
openssl rand -base64 12
```

### 2. Set Up SSH Keys (More Secure)

**On your Mac:**
```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Copy public key to Pi
ssh-copy-id pi@192.168.1.88
```

**On Pi, edit SSH config:**
```bash
sudo nano /etc/ssh/sshd_config
# Set: PasswordAuthentication no
sudo systemctl restart ssh
```

### 3. Change Default Username (Optional)

```bash
# Create new user
sudo adduser newusername
sudo usermod -aG sudo newusername

# Logout and login as new user
# Then delete old 'pi' user (optional)
sudo deluser pi
```

---

## 📋 Quick Reference Commands

### Password Management
```bash
# Change your password
passwd

# Change another user's password
sudo passwd username

# Lock/unlock user account
sudo passwd -l username  # Lock
sudo passwd -u username  # Unlock
```

### SSH Management
```bash
# Check SSH status
sudo systemctl status ssh

# Start/Stop SSH
sudo systemctl start ssh
sudo systemctl stop ssh

# Enable/Disable SSH on boot
sudo systemctl enable ssh
sudo systemctl disable ssh

# Restart SSH (after config changes)
sudo systemctl restart ssh

# View SSH config
sudo nano /etc/ssh/sshd_config
```

### Network Info
```bash
# Check IP address
hostname -I

# Check hostname
hostname

# Check network interfaces
ip addr show
# or
ifconfig
```

---

## 🚨 Important Notes

### Before Changing SSH Settings:

1. **Test your changes** - Make sure you can still connect!
2. **Keep current session open** - Don't close SSH until you verify new settings work
3. **Have backup access** - Keep display/keyboard available in case SSH breaks
4. **Document changes** - Write down new port/password in a secure place

### If You Lock Yourself Out:

1. **Use display/keyboard** - Connect directly to Pi
2. **Or reflash OS** - Start fresh with Raspberry Pi Imager
3. **Or use recovery mode** - Boot from SD card if available

---

## 🎯 Step-by-Step: Change Password After First Login

**Scenario**: You just logged in for the first time and want to change the default password.

```bash
# 1. Login to Pi
ssh pi@192.168.1.88
# Enter default password (usually "raspberry")

# 2. Change password immediately
passwd
# Enter current password: raspberry
# Enter new password: [your strong password]
# Confirm new password: [your strong password]

# 3. Verify you can login with new password
# Logout and try logging in again
exit
ssh pi@192.168.1.88
# Enter new password - should work!
```

---

## ✅ Checklist After First Login

- [ ] Change default password (`passwd`)
- [ ] Update system (`sudo apt update && sudo apt upgrade`)
- [ ] Check SSH is enabled (`sudo systemctl status ssh`)
- [ ] Note IP address (`hostname -I`)
- [ ] (Optional) Set up SSH keys
- [ ] (Optional) Change SSH port for security

---

## 🔧 Troubleshooting

### Can't Remember Password?
- Use display/keyboard to reset: `sudo passwd pi`
- Or reflash OS with new password in Raspberry Pi Imager

### SSH Not Working After Changes?
- Check SSH is running: `sudo systemctl status ssh`
- Check firewall: `sudo ufw status`
- Verify port: `sudo netstat -tlnp | grep ssh`
- Check logs: `sudo journalctl -u ssh`

### Changed SSH Port, Can't Connect?
- Use new port: `ssh -p 2222 pi@192.168.1.88` (if you changed to 2222)
- Or revert changes via display/keyboard

---

**Summary**: Yes, you can change SSH password and settings after login! Use `passwd` for password and edit `/etc/ssh/sshd_config` for SSH settings. Just make sure to test changes before closing your session! 🔐

