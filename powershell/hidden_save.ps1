$exePath = "C:\Users\frost\Downloads\usbimager.exe"
$arguments = "--list"
$outputFile = "devices_list.txt"

Start-Process -FilePath $exePath -ArgumentList $arguments -WindowStyle Hidden -RedirectStandardOutput $outputFile -Wait

Write-Host "Available devices:"
Get-Content $outputFile

