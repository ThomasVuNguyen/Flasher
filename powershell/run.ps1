$exePath = "C:\Users\frost\Downloads\usbimager.exe"
$arguments = "-a"
$outputFile = "output.txt"
$errorFile = "error.txt"

Start-Process -FilePath $exePath -ArgumentList $arguments -WindowStyle Hidden -RedirectStandardOutput $outputFile -RedirectStandardError $errorFile -Wait

# Display the output
Get-Content $outputFile
Get-Content $errorFile

