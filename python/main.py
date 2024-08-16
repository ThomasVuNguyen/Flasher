import win32file

# Open the drive for low-level access
drive_handle = win32file.CreateFile(
    
    r"\\.\PhysicalDrive1",  # Adjust drive number as needed
    # r"\\.\PhysicalDrive1",  # Adjust drive number as needed
    win32file.GENERIC_READ | win32file.GENERIC_WRITE,
    win32file.FILE_SHARE_READ | win32file.FILE_SHARE_WRITE,
    None,
    win32file.OPEN_EXISTING,
    0,
    None
)

# Read from the image file and write to the drive
with open(r"C:\Users\frost\Downloads\img\os.img", "rb") as image_file:
    while True:
        chunk = image_file.read(1024 * 1024)  # Read 1MB at a time
        if not chunk:
            break
        win32file.WriteFile(drive_handle, chunk)

win32file.CloseHandle(drive_handle)