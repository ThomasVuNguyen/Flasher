Day 1: 
Learn Windows
Goal - understand & implement a realiable, deployable & testable way to flash an OS onto a USB

1. Windows

- Plug in USB
- Run Command Prompt as admin
- Check installation requirement

```
diskpart
```

- List all available disks
```
list disk
```

- Select USB drive

```
select disk X
```

- Clean partition

```
clean
```

- Create primary partition

```
create partition primary
```

- Select the new partition

```
select partition 1
```

- Format the drive
```
format fs=ntfs quick
```

- Make partition active
```
active
```

- Format the drive
```
format fs=fat32 quick
```

- Assign something & exit

```
assign
exit
```

- Mount the Linux ISO
```
powershell Mount-DiskImage -ImagePath "C:\path\to\your\file.iso"
powershell Get-DiskImage -ImagePath "C:\path\to\your\file.iso" | Get-Volume
powershell Dismount-DiskImage -ImagePath "C:\path\to\your\file.iso"
```

- Cope files to USB file
```
xcopy /E /F /H [mounted ISO drive letter]:\ [USB drive letter]:\
```

- (Not sure if needed) for some Linux distroes, may need to make USB bootable
```
[USB drive letter]:
cd boot
bootsect /nt60 [USB drive letter]:
```


Day 2: Setup Flutter project & try out the commands on an actual USB