param (
    [string]$Command,
    [string]$Workspace = "",
    [string]$Vpn = "",
    [string]$Type = ""
)

$serviceName = "exefree"
$containerName = "exefree"
$labelFilter = "app=exefree"
$homeDir = $env:USERPROFILE
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

function Wait-ForContainer {
    Write-Output "[*] Waiting for container with label '$labelFilter'..."
    for ($i = 0; $i -lt 10; $i++) {
        if (docker ps --filter "label=$labelFilter" --format '{{.Names}}') {
            return
        }
        Start-Sleep -Seconds 1
    }
    Write-Error "Container with label '$labelFilter' not found or not running."
    exit 1
}

function Get-RunningContainer {
    param([string]$WorkspaceSuffix = "")
    $targetName = "$containerName$WorkspaceSuffix"
    $runningContainer = docker ps --filter "name=$targetName" --format '{{.Names}}'
    return $runningContainer
}

function Create-OverrideFile {
    param([string]$Content)
    
    $overridePath = "$ScriptDir\docker-compose.override.yml"
    
    # Check if override file exists and has same content
    if (Test-Path $overridePath) {
        $existingContent = Get-Content $overridePath -Raw
        if ($existingContent.Trim() -eq $Content.Trim()) {
            Write-Output "[*] Override file already exists with same configuration."
            return $false  # No change needed
        }
    }
    
    Set-Content -Path $overridePath -Value $Content
    Write-Output "[*] Created/updated override file."
    return $true  # File was created/changed
}

switch ($Command) {
    "start" {
        Write-Output "[*] Checking for existing container..."
        
        # Check if container already exists (running or stopped)
        $targetContainerName = "$containerName$Workspace"
        $existingContainer = docker ps -a --filter "name=$targetContainerName" --format '{{.Names}}'
        
        if ($existingContainer) {
            Write-Output "[*] Container '$existingContainer' already exists. Starting and connecting..."
            docker start $existingContainer | Out-Null
            docker exec -it $existingContainer zsh
            return
        }
        
        Write-Output "[*] Creating new Docker container..."
        
        $needsOverride = $false
        $override = ""
        
        if ($Vpn -and $Workspace) {
            $workspacePath = "$homeDir/workspace/$Workspace".Replace('\','/')
            $vpnPath = (Resolve-Path $Vpn).Path
            if(!(Test-Path $workspacePath)) {
                New-Item -ItemType Directory -Path $workspacePath -Force | Out-Null
            }
            $override = @"
version: '3'
services:
  ${containerName}:
    container_name: $containerName$Workspace
    volumes:
      - "$($vpnPath.Replace('\', '/')):/vpn/$(Split-Path -Leaf $vpnPath)"
      - "${workspacePath}:/workspace"
    entrypoint: ["/entrypoint.sh", "--vpn", "/vpn/$(Split-Path -Leaf $vpnPath)"]
"@
            $needsOverride = $true
        }
        elseif ($Vpn) {
            $vpnPath = (Resolve-Path $Vpn).Path
            $override = @"
version: '3'
services:
  ${containerName}:
    container_name: $containerName$Workspace
    volumes:
      - "$($vpnPath.Replace('\', '/')):/vpn/$(Split-Path -Leaf $vpnPath)"
      - "$ScriptDir/workspace/:/workspace"
    entrypoint: ["/entrypoint.sh", "--vpn", "/vpn/$(Split-Path -Leaf $vpnPath)"]
"@
            $needsOverride = $true
        }
        elseif ($Workspace) {
            $workspacePath = "$homeDir/workspace/$Workspace".Replace('\','/')
            if(!(Test-Path $workspacePath)) {
                New-Item -ItemType Directory -Path $workspacePath -Force | Out-Null
            }
            $override = @"
version: '3'
services:
  ${containerName}:
    container_name: $containerName$Workspace
    volumes:
      - "${workspacePath}:/workspace"
    entrypoint: ["/entrypoint.sh"]
"@
            $needsOverride = $true
        }

        if ($needsOverride) {
            $configChanged = Create-OverrideFile -Content $override
            
            # Only run docker-compose if config changed or container doesn't exist
            if ($configChanged -or !(docker ps -a --filter "name=$containerName$Workspace" --format '{{.Names}}')) {
                docker compose -f "$ScriptDir\docker-compose.yml" -f "$ScriptDir\docker-compose.override.yml" up -d --no-build
            } else {
                Write-Output "[*] Container exists with same config, starting if needed..."
                docker compose -f "$ScriptDir\docker-compose.yml" -f "$ScriptDir\docker-compose.override.yml" start
            }
        } else {
            docker compose -f "$ScriptDir\docker-compose.yml" up -d --no-build
        }

        Wait-ForContainer
        $containerName = docker ps --filter "label=$labelFilter" --format '{{.Names}}'
        docker exec -it $containerName zsh
    }
    "shell" {
        Write-Output "[*] Connecting to existing container..."
        
        $runningContainer = Get-RunningContainer -WorkspaceSuffix $Workspace
        
        if ($runningContainer) {
            Write-Output "[*] Found running container: $runningContainer"
            docker exec -it $runningContainer zsh
        } else {
            Write-Output "[!] No running container found. Use 'start' command first."
            if ($Workspace) {
                Write-Output "    Try: ./exefree.ps1 start -Workspace $Workspace"
            } else {
                Write-Output "    Try: ./exefree.ps1 start"
            }
        }
    }
    "stop" {
        if ( Test-Path "$ScriptDir\docker-compose.override.yml" -PathType Leaf) {
            docker compose -f "$ScriptDir\docker-compose.yml" -f "$ScriptDir\docker-compose.override.yml" stop
            Remove-Item "$ScriptDir\docker-compose.override.yml" -ErrorAction SilentlyContinue
        }
        docker compose -f "$ScriptDir\docker-compose.yml" stop
    }
    "remove" {
        if ( Test-Path "$ScriptDir\docker-compose.override.yml" -PathType Leaf) {
            docker compose -f "$ScriptDir\docker-compose.yml" -f "$ScriptDir\docker-compose.override.yml" down
            Remove-Item "$ScriptDir\docker-compose.override.yml" -ErrorAction SilentlyContinue
        }

        if ($Workspace) {
            $workspacePath = "$homeDir/workspace/$Workspace".Replace('\','/')
            if (Test-Path $workspacePath) {
                Write-Output "Do you want to delete the '$workspacePath' directory? [y/n]"
                $response = Read-Host
                if ($response -eq 'y' -or $response -eq 'Y') {
                    Remove-Item $workspacePath -Force -Recurse -ErrorAction SilentlyContinue
                    Write-Output "Directory deleted."
                } else {
                    Write-Output "Directory not deleted."
                }
            } else {
                Write-Output "Path '$workspacePath' does not exist."
            }
        }
       
        docker compose -f "$ScriptDir\docker-compose.yml" down
    }
    "build" {
        docker compose -f "$ScriptDir\docker-compose.yml" build --build-arg PROFILE="$Type"
    }
    "info" {
        Write-Output "Exefree workspaces available :"
        $workspacePath = "$homeDir/workspace/"
        if (Test-Path $workspacePath) {
            Get-ChildItem -Path $workspacePath -Directory | ForEach-Object {
                Write-Output "  - $($_.Name)"
            }
        } else {
            Write-Output "  Workspace directory not found: $workspacePath"
        }
    }
    Default {
        Write-Output "Usage: ./exefree.ps1 <command> [options]"
        Write-Output "Commands:"
        Write-Output "  start     - Start container and connect"
        Write-Output "  shell     - Connect to existing container"
        Write-Output "  stop      - Stop container"
        Write-Output "  remove    - Remove container"
        Write-Output "  build     - Build container"
        Write-Output "  info      - Show workspace info"
        Write-Output ""
        Write-Output "Examples:"
        Write-Output "  ./exefree.ps1 start -Workspace myproject"
        Write-Output "  ./exefree.ps1 shell -Workspace myproject"
    }
}