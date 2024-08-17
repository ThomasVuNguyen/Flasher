# Flasher
Flash an OS &amp; setup SSH for your Raspberry Pi in a non-boring &amp; frustration-free way


# Prepare an image

1. Flash default Raspberry Pi (Bulls-eye / Desktop / 32-bit)

2. Take in wifi & hotspot information

3. Prepare wpa_supplicant.conf accordingly

4. Copy in ssh, userconf.txt & wpa_supplicant.conf into boot folder

5. Eject

# Scan for device & unique hardware-based id

1. Attempt SSH devices using "comfy" credentials

2. Check serial number with

```
cat /proc/cpuinfo
```
