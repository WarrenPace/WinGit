# DO NOT RUN WITH IDE, USE POWERSHELL TERMINAL
param (
    [string]$Flag
)

# Define variables
$distroName = "Ubuntu-22.04"
$newLocation = "J:\ubu"
$exportPath = "$newLocation\$distroName.tar"
$logFile = "$newLocation\WSL_Setup_Log.txt"

function Write-Log {
    Param ([string]$message)
    $logEntry = "$((Get-Date).ToString()) : $message"
    $logEntry | Out-File $logFile -Append
    Write-Host $logEntry
}

function Get-WSLStatus {
    Param ([string]$distroName, [string]$statusCheck, [int]$timeout)
    $startTime = Get-Date
    while ($true) {
        $currentStatus = wsl --list --quiet | Select-String $distroName
        if ($statusCheck -eq "installed" -and $currentStatus) { break }
        if ($statusCheck -eq "unregistered" -and -not $currentStatus) { break }
        Start-Sleep -Seconds 5
        $elapsedTime = (Get-Date) - $startTime
        if ($elapsedTime.TotalSeconds -gt $timeout) {
            throw "Timeout reached while waiting for WSL $statusCheck status."
        }
    }
}

# Create log file
if (-not (Test-Path $logFile)) {
    New-Item -ItemType File -Path $logFile
}
Write-Log "Starting WSL setup script for $distroName."

if ($Flag -eq "--uninstall") {
    # Uninstall logic
    try {
        Write-Log "Unregistering and uninstalling $distroName."
        wsl --unregister $distroName
        Write-Log "$distroName unregistered successfully."
        # Additional cleanup if needed
    } catch {
        Write-Log "Error occurred during uninstallation: $_"
        exit
    }
} else {
    # Install and setup logic
    try {
        Write-Log "Installing $distroName."
        wsl --install -d $distroName
        Get-WSLStatus -distroName $distroName -statusCheck "installed" -timeout 300
        Write-Log "$distroName installed successfully."

        Write-Log "Exporting $distroName to $exportPath."
        wsl --export $distroName $exportPath
        Write-Log "Exported successfully."

        Write-Log "Unregistering $distroName."
        wsl --unregister $distroName
        Write-Log "$distroName unregistered successfully."

        if (-not (Test-Path $newLocation)) {
            Write-Log "Creating new directory at $newLocation."
            New-Item -ItemType Directory -Path $newLocation
        }

        Write-Log "Importing $distroName to $newLocation."
        wsl --import $distroName $newLocation $exportPath
        Write-Log "Imported successfully."

        Write-Log "Cleaning up exported tar file."
        Remove-Item $exportPath
        Write-Log "Clean up completed."
    } catch {
        Write-Log "Error occurred: $_"
        exit
    }
}

Write-Log "$distroName operation completed successfully."
