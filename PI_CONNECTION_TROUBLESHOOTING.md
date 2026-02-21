# 🔌 Raspberry Pi Connection Troubleshooting

## Current Status: Pi Not Reachable

The Pi at `192.168.1.88` is currently not responding to ping/SSH.

---

## 🔍 Possible Reasons

### 1. Pi Rebooted (Most Likely)
- Plugging in USB pendrive might have caused a reboot
- Pi might be booting from the pendrive now
- **Wait 1-2 minutes** for Pi to fully boot

### 2. IP Address Changed
- Pi might have gotten a new IP address from DHCP
- Check your router's DHCP client list
- Or scan network again

### 3. Network Issue
- Ethernet/WiFi connection might have dropped
- Check physical connections
- Verify Pi's network LED status

### 4. Pi Booting from Pendrive
- If you flashed OS to pendrive, Pi might be booting from it
- First boot from USB can take longer
- **Wait 3-5 minutes** for first boot

---

## ✅ What to Do Now

### Step 1: Wait and Check Again

```bash
# Wait 2-3 minutes, then check again
ping -c 3 192.168.1.88

# Or scan entire network
nmap -sn 192.168.1.0/24
```

### Step 2: Check Router DHCP List

1. Log into your router (usually `192.168.1.1`)
2. Check "DHCP Client List" or "Connected Devices"
3. Look for "raspberrypi" or a device with MAC address starting with `B8:27:EB` or `DC:A6:32`
4. Note the new IP address

### Step 3: Check Physical Connections

- ✅ Ethernet cable connected? (if using Ethernet)
- ✅ WiFi connected? (check Pi's WiFi LED)
- ✅ Power supply connected?
- ✅ Green LED blinking? (indicates activity)

### Step 4: Try Different IP Addresses

If Pi got a new IP, try common ones:

```bash
# Try common IPs
for ip in 192.168.1.{2..254}; do
    ping -c 1 -W 1 $ip > /dev/null 2>&1 && echo "Found: $ip"
done
```

### Step 5: Check if Pi is Booting

**If you have a display:**
- Connect HDMI cable to Pi
- You should see boot messages

**If you don't have a display:**
- Check network activity LED on Pi
- Wait 5-10 minutes for first boot from USB

---

## 🔧 If Pi Still Not Found

### Option 1: Reflash OS (Fresh Start)

1. Use Raspberry Pi Imager
2. Flash OS to pendrive (or SD card)
3. **Enable SSH** in advanced options
4. **Set username/password**
5. **Configure WiFi** (or use Ethernet)
6. Boot Pi and wait 3-5 minutes

### Option 2: Check with Display/Keyboard

If you have access to Pi with display:
- Boot Pi
- Check IP address: `hostname -I`
- Check SSH status: `sudo systemctl status ssh`
- Enable SSH if needed: `sudo systemctl enable ssh`

---

## 📋 Quick Diagnostic Commands

Once Pi is reachable again:

```bash
# Test connectivity
ping -c 3 <PI_IP>

# Test SSH
ssh pi@<PI_IP> "echo 'Connected!'"

# Check Pi info
ssh pi@<PI_IP> "hostname && uname -a && hostname -I"
```

---

## 🎯 Next Steps

1. **Wait 2-3 minutes** (Pi might be booting)
2. **Check network again**: `nmap -sn 192.168.1.0/24`
3. **Check router** for new IP address
4. **Try connecting** once Pi is found

---

## 💡 Tips

- **First boot from USB** can take 5-10 minutes
- **Pi might reboot** when USB devices are plugged in
- **IP address can change** if using DHCP
- **Use static IP** to avoid IP changes (configure in router or Pi)

---

**Status**: Waiting for Pi to come back online...

