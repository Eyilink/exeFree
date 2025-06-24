param (
    [string]$Command,
    [string]$Vpn = "",
    [string]$Workspace = ""
)

$serviceName = "exefree"
$containerName = "exefree"
$labelFilter = "app=exefree"

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
    volumes:
      - "/workspace:/workspace"
      - "$($vpnPath.Replace('\', '/')):/vpn/$(Split-Path -Leaf $vpnPath)"
    entrypoint: ["/entrypoint.sh", "--vpn", "/vpn/$(Split-Path -Leaf $vpnPath)"]
"@

            Set-Content -Path "$ScriptDir\docker-compose.override.yml" -Value $override
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
        }
        docker compose -f "$ScriptDir\docker-compose.yml" stop
    }
    "remove" {
        if ( Test-Path "$ScriptDir\docker-compose.override.yml" -PathType Leaf)
        {
            docker compose -f "$ScriptDir\docker-compose.yml" -f "$ScriptDir\docker-compose.override.yml" down
            Remove-Item "$ScriptDir\docker-compose.override.yml" -ErrorAction SilentlyContinue
        }
        docker compose -f "$ScriptDir\docker-compose.yml" down
        
    }
    Default {
        Write-Output "Usage: ./exefree.ps1 start -Vpn path.ovpn -Workspace C:\path\to\folder"
    }
}
