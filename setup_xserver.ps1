$vcxsrvZip = Join-Path $PSScriptRoot "resources\vcxsrv-64.1.17.2.0.installer.zip"
$extractedPath = "$env:TEMP\vcxsrv_installer"
$installerPath = "$extractedPath\vcxsrv-64.1.17.2.0.installer.exe"
$vcxsrvExe = "C:\Program Files\VcXsrv\vcxsrv.exe"

# Step 1: Extract the installer if not already done
if (-not (Test-Path $installerPath)) {
    Write-Host "Extracting VcXsrv installer..."
    Expand-Archive -Path $vcxsrvZip -DestinationPath $extractedPath -Force
}

# Step 2: Install VcXsrv if not already installed
if (-not (Test-Path $vcxsrvExe)) {
    Write-Host "Installing VcXsrv..."
    Start-Process -Wait -FilePath $installerPath -ArgumentList "/S"
} else {
    Write-Host "VcXsrv already installed."
}

# Step 3: Launch VcXsrv with appropriate options
if (Test-Path $vcxsrvExe) {
    Write-Host "Launching VcXsrv..."
    Start-Process -FilePath $vcxsrvExe -ArgumentList ":0 -multiwindow -ac -clipboard -wgl"
} else {
    Write-Host "Installation failed or file not found: $vcxsrvExe"
}
