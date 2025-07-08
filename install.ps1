# install.ps1

# Pas besoin de X11 mais si jamais
# Write-Host "[*] Running setup_xserver.ps1..." -ForegroundColor Cyan

# $setupScript = Join-Path $PSScriptRoot "setup_xserver.ps1"
# if (Test-Path $setupScript) {
#     & $setupScript
# } else {
#     Write-Warning "[!] setup_xserver.ps1 not found. Skipping..."
# }

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
$profileDir = Split-Path $profilePath

# Ensure profile directory exists
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

# Ensure profile file exists
if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}


$aliasLine = "Set-Alias exefree `"$wrapperScript`""
if (-not (Get-Content $profilePath | Select-String -SimpleMatch "Set-Alias exefree")) {
    Add-Content -Path $profilePath -Value "`n# Alias for exefree wrapper`n$aliasLine"
    Write-Host "[*] Alias 'exefree' added to PowerShell profile: $profilePath" -ForegroundColor Green
} else {
    Write-Host "[*] Alias already exists in PowerShell profile." -ForegroundColor Yellow
}

Write-Host '[✓] Installation complete. Open a new PowerShell session or run $PROFILE to load the alias.' -ForegroundColor Green

. $PROFILE  # reloads your profile
