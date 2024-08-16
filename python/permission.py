import os

file_path = r"\\.\PhysicalDrive1"
#r'\\?\Volume{6b35d9cb-5b65-11ef-a38a-ac198ee95ecf}'

if os.access(file_path, os.R_OK):
    print(f"Read permission granted for {file_path}")
else:
    print(f"Read permission denied for {file_path}")

if os.access(file_path, os.W_OK):
    print(f"Write permission granted for {file_path}")
else:
    print(f"Write permission denied for {file_path}")

if os.access(file_path, os.X_OK):
    print(f"Execute permission granted for {file_path}")
else:
    print(f"Execute permission denied for {file_path}")