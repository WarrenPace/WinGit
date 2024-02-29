# Function to List Mount Points with Low Storage
function Get-MountPoints {
    Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Free -lt 10GB } | Format-Table Name, Used, Free -AutoSize
}

# Function to Configure wsl.conf
function Set-WSLConf {
    Param ([string]$distroName)
    $wslConfigPath = "/etc/wsl.conf"
    $configContent = @"
[automount]
root = /mnt/
options = "metadata,umask=22,fmask=11"
"@
    wsl -d $distroName sh -c "echo '$configContent' > $wslConfigPath"
    Write-Host "wsl.conf configured successfully for $distroName."
}

# Function to Facilitate Migration
function Move-WSLDistro {
    Param ([string]$distroName, [string]$newLocation)
    $exportPath = "$newLocation\$distroName.tar"
    wsl --export $distroName $exportPath
    wsl --unregister $distroName
    wsl --import $distroName $newLocation $exportPath
    Remove-Item $exportPath
    Write-Host "$distroName has been migrated to $newLocation."
}

# Main script logic
Write-Host "Welcome to the WSL Management Script"

# List Mount Points with Low Storage
Write-Host "Listing mount points with low storage:"
List-MountPoints

# User choice for WSL Configuration
$userChoice = Read-Host "Do you want to configure wsl.conf? (Y/N)"
if ($userChoice -eq "Y") {
    $distroName = Read-Host "Enter the WSL distribution name for configuration"
    Configure-WSLConf -distroName $distroName
}

# User choice for Migration
$distroName = Read-Host "Enter the WSL distribution name to migrate"
$newLocation = Read-Host "Enter the new location for the WSL distribution"
Migrate-WSLDistro -distroName $distroName -newLocation $newLocation

Write-Host "WSL Management operations completed."
