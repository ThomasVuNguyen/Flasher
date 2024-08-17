# Set up the command and arguments
$command = "cmd.exe"
$arguments = "/c  C:\Users\frost\Downloads\usbimager.exe --list"

# Set up output files
$outputFile = "output.txt"
$errorFile = "error.txt"

# Run the command
Start-Process -FilePath $command -ArgumentList $arguments -WindowStyle Hidden -RedirectStandardOutput $outputFile -RedirectStandardError $errorFile -Wait

# Display the output
Write-Host "Output:"
Get-Content $outputFile

Write-Host "Errors (if any):"
Get-Content $errorFile

