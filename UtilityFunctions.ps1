function Install-RequiredModules {
    param ([string[]]$requiredModules)
    foreach ($module in $requiredModules) {
        try {
            Find-Module -Name $module -ErrorAction Stop
            Install-Module -Name $module -Force -Scope CurrentUser
            Write-Host "Module '$module' installed successfully."
        } catch {
            Write-Host "Module '$module' not found or failed to install: $_"
        }
    }
}

function Write-Log {
    param ([string]$Message)
    $logPath = "WSL_Management_Log.txt"
    Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
}

function Get-MountPoints {
    Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Free -lt 10GB } | Format-Table Name, Used, Free -AutoSize
}

# Additional utility functions can be added here...
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

# Function to Uninstall and Completely Remove WSL
function Uninstall-WSL {
    try {
        # Uninstall WSL feature
        Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
        Write-Host "WSL feature has been disabled."

        # Remove all WSL distributions
        $distros = wsl --list --quiet
        foreach ($distro in $distros) {
            wsl --unregister $distro
            Write-Host "Removed WSL distribution: $distro"
        }

        Write-Log "WSL has been uninstalled and all distributions have been removed."
    } catch {
        Write-Host "An error occurred during the WSL uninstallation process."
        Write-Log "Error during WSL uninstallation: $_"
    }
}