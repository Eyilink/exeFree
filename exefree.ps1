param (
    [string]$Command
)

$serviceName = "exefree"
$containerName = "exefree"

function Wait-ForContainer {
    Write-Output "[*] Waiting for container '$containerName'..."
    for ($i = 0; $i -lt 10; $i++) {
        if (docker ps --format '{{.Names}}' | Select-String -Pattern $containerName) {
            return
        }
        Start-Sleep -Seconds 1
    }
    Write-Error "Container '$containerName' not found or not running."
    exit 1
}

switch ($Command) {
    "start" {
        Write-Output "[*] Starting Docker container..."
        docker compose up -d
        Wait-ForContainer
        Write-Output "[*] Executing into container..."
        docker exec -it $containerName zsh
    }
    "stop" {
        Write-Output "[*] Stopping container..."
        docker compose stop
    }
    "remove" {
        Write-Output "[*] Stopping and removing container..."
        docker compose down
    }
    Default {
        Write-Output "Usage: ./exefree.ps1 start|stop|remove"
    }
}
