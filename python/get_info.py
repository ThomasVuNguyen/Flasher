import win32file
import pywintypes

def try_open_usb(drive_number):
    try:
        handle = win32file.CreateFile(
            f"\\\\.\\PhysicalDrive1",
            win32file.GENERIC_READ | win32file.GENERIC_WRITE,
            win32file.FILE_SHARE_READ | win32file.FILE_SHARE_WRITE,
            None,
            win32file.OPEN_EXISTING,
            0,
            None
        )
        print(f"Successfully opened PhysicalDrive{drive_number}")
        win32file.CloseHandle(handle)
        return True
    except pywintypes.error as e:
        print(f"Error opening PhysicalDrive{drive_number}: {e}")
        return False

# Try opening PhysicalDrive1, PhysicalDrive2, etc.
for i in range(10):
    try_open_usb(i)