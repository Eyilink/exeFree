# install.ps1
Write-Host "[*] Building Docker container..." -ForegroundColor Cyan
docker-compose build

if ($LASTEXITCODE -ne 0) {
    Write-Error "[-] Docker build failed."
    exit 1
}

Write-Host "[*] Running setup_xserver.ps1..." -ForegroundColor Cyan

$setupScript = Join-Path $PSScriptRoot "setup_xserver.ps1"
if (Test-Path $setupScript) {
    & $setupScript
} else {
    Write-Warning "[!] setup_xserver.ps1 not found. Skipping..."
}

# Set alias for current session
Write-Host "[*] Setting 'exefree' alias for current session..." -ForegroundColor Cyan
$wrapperScript = Join-Path $PSScriptRoot "exefree.ps1"
if (-Not (Test-Path $wrapperScript)) {
    Write-Error "[-] exefree.ps1 not found."
    exit 1
}
Set-Alias -Name exefree -Value $wrapperScript

# Make alias persistent by adding it to user's PowerShell profile
$profilePath = $PROFILE
if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force
}

$aliasLine = "Set-Alias exefree `"$wrapperScript`""
if (-not (Get-Content $profilePath | Select-String -SimpleMatch "Set-Alias exefree")) {
    Add-Content -Path $profilePath -Value "`n# Alias for exefree wrapper`n$aliasLine"
    Write-Host "[*] Alias 'exefree' added to PowerShell profile: $profilePath" -ForegroundColor Green
} else {
    Write-Host "[*] Alias already exists in PowerShell profile." -ForegroundColor Yellow
}

Write-Host '[✓] Installation complete. Open a new PowerShell session or run $PROFILE to load the alias.' -ForegroundColor Green
