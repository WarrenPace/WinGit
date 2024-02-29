# Ensure required PowerShell modules are installed
$requiredModules = @('WindowsSubsystemForLinux', 'PowerShellGet')
foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Install-Module -Name $module -Force -Scope CurrentUser
    }
}

# Function to write logs to a file
function Write-Log {
    param (
        [string]$Message
    )
    $logPath = "WSL_Management_Log.txt"
    Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
}

# Function to List Mount Points with Low Storage
function Get-MountPoints {
    Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Free -lt 10GB } | Format-Table Name, Used, Free -AutoSize
}

# Function to Configure wsl.conf with options to exclude mount points
function Set-WSLConf {
    Param ([string]$distroName, [string[]]$excludeMountPoints)
    $wslConfigPath = "/etc/wsl.conf"
    $excludeOptions = $excludeMountPoints -join ","
    $configContent = @"
[automount]
root = /mnt/
options = "metadata,umask=22,fmask=11"
exclude = "$excludeOptions"
"@
    wsl -d $distroName sh -c "echo '$configContent' > $wslConfigPath"
    Write-Host "wsl.conf configured successfully for $distroName."
    Write-Log "Configured wsl.conf for $distroName with excluded mount points: $excludeOptions"
}

# Function to Facilitate Migration
function Move-WSLDistro {
    Param ([string]$distroName, [string]$newLocation)
    if ($newLocation -match '^[Cc]:\\') {
        Write-Host "Migration to C: drive is not allowed."
        Write-Log "Attempted migration of $distroName to C: drive, which is not permitted."
        return
    }

    $exportPath = "$newLocation\$distroName.tar"
    try {
        wsl --export $distroName $exportPath
        wsl --unregister $distroName
        wsl --import $distroName $newLocation $exportPath
        Remove-Item $exportPath
        Write-Host "$distroName has been migrated to $newLocation."
        Write-Log "Migrated $distroName to $newLocation."
    } catch {
        Write-Host "An error occurred during migration."
        Write-Log "Error during migration: $_"
    }
}

# Main script logic
Write-Host "Welcome to the WSL Management Script"
Write-Log "Script started."

# Display menu and get user choices
Write-Host "Select the operations you want to perform (separate with commas):"
Write-Host "1. List Mount Points with Low Storage"
Write-Host "2. Configure wsl.conf for a distribution"
Write-Host "3. Migrate a WSL distribution"
$userChoices = Read-Host "Enter your choices"

# Convert user input into an array of choices
$choices = $userChoices.Split(',').Trim() | ForEach-Object { [int]$_ }

# Check if choice 1 is selected
if ($choices -contains 1) {
    Write-Host "Listing mount points with low storage:"
    List-MountPoints
}

# Check if choice 2 is selected
if ($choices -contains 2) {
    # List available Linux distributions
    $distros = wsl --list --online | Select-Object -Skip 1
    Write-Host "Available Linux Distributions:"
    $distros | ForEach-Object { $i = 0 } { Write-Host "$($i++) - $_" }
    $distroSelection = Read-Host "Select a distribution by number"
    $selectedDistro = $distros[$distroSelection]

    $excludeMountPoints = Read-Host "Enter the mount points to exclude (comma-separated)"
    Configure-WSLConf -distroName $selectedDistro -excludeMountPoints $excludeMountPoints.Split(',')
}

# Check if choice 3 is selected
if ($choices -contains 3) {
    $distroName = Read-Host "Enter the WSL distribution name to migrate"
    $newLocation = Read-Host "Enter the new location for the WSL distribution"
    Migrate-WSLDistro -distroName $distroName -newLocation $newLocation
}

Write-Host "WSL Management operations completed."
Write-Log "Script completed."