param (
    [string]$Command,
    [string]$Workspace = "",
    [string]$Vpn = ""
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
switch ($Command) {
    "start" {
        Write-Output "[*] Starting Docker container..."
        
       
       
        if ($Vpn) {
             # Normalize paths
             Write-Output "Overriding Docker Compose"
        #$workspacePath = Resolve-Path $Workspace
            $vpnPath = (Resolve-Path $Vpn).Path
            # Build override YAML 
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
            Set-Content -Path "$ScriptDir\docker-compose.override.yml" -Value $override
            }
           if($Workspace)
            {
                $workspacePath = "$homeDir/workspace/$Workspace".Replace('\','/')
                Write-Output $workspacePath
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
                Set-Content -Path "$ScriptDir\docker-compose.override.yml" -Value $override
            }

            if($Vpn -and $Workspace)
            {
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
                Set-Content -Path "$ScriptDir\docker-compose.override.yml" -Value $override
            }

            if($Vpn -or $Workspace)
        {
            docker compose -f "$ScriptDir\docker-compose.yml" -f "$ScriptDir\docker-compose.override.yml" up -d
            
        }
       else {
        docker compose -f "$ScriptDir\docker-compose.yml" up -d
       }

        
        Wait-ForContainer
        $containerName = docker ps --filter "label=$labelFilter" --format '{{.Names}}'
        docker exec -it $containerName zsh
    }
    "stop" {
         if ( Test-Path "$ScriptDir\docker-compose.override.yml" -PathType Leaf)
        {
            docker compose -f "$ScriptDir\docker-compose.yml" -f "$ScriptDir\docker-compose.override.yml" stop
            Remove-Item "$ScriptDir\docker-compose.override.yml" -ErrorAction SilentlyContinue
        }
        docker compose -f "$ScriptDir\docker-compose.yml" stop
    }
    "remove" {
        if ( Test-Path "$ScriptDir\docker-compose.override.yml" -PathType Leaf)
        {
            docker compose -f "$ScriptDir\docker-compose.yml" -f "$ScriptDir\docker-compose.override.yml" down
            Remove-Item "$ScriptDir\docker-compose.override.yml" -ErrorAction SilentlyContinue
        }
        if($Workspace)
        {
            $workspacePath = "$homeDir/workspace/$Workspace".Replace('\','/')
             if(Test-Path $workspacePath) {
                   Remove-Item $workspacePath -Force -Recurse -ErrorAction SilentlyContinue
                }
        }
       
        docker compose -f "$ScriptDir\docker-compose.yml" down
        
    }
    "build"
    {
        docker compose -f "$ScriptDir\docker-compose.yml" build
    }
    "info" {
    Write-Output "Exefree workspaces available :"
    
    # Get all directories in the workspace folder
    $workspacePath = "$homeDir/workspace/"
    
    # Check if the workspace directory exists
    if (Test-Path $workspacePath) {
        # Get all directories and display their names
        Get-ChildItem -Path $workspacePath -Directory | ForEach-Object {
            Write-Output "  - $($_.Name)"
        }
    } else {
        Write-Output "  Workspace directory not found: $workspacePath"
    }
    }
    Default {
        Write-Output "Usage: ./exefree.ps1 start -Vpn path.ovpn -Workspace C:\path\to\folder"
    }
}
