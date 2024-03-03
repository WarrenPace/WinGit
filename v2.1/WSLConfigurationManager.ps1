# WSLConfigurationManager.ps1

. .\Logger.ps1

function Set-WSLConf {
    param (
        [string]$distroName,
        [string]$rootPath = "/mnt/",
        [string]$options = "metadata,umask=22,fmask=11",
        [string[]]$excludeMountPoints
    )

    try {
        $wslConfigPath = "/etc/wsl.conf"
        $excludeOptions = $excludeMountPoints -join ","

        $configContent = @"
[automount]
root = $rootPath
options = "$options"
exclude = "$excludeOptions"
"@

        wsl -d $distroName sh -c "echo '$configContent' > $wslConfigPath"
        Write-Host "wsl.conf configured successfully for $distroName."
        Write-Log "Configured wsl.conf for $distroName with root: $rootPath, options: $options, excluded mount points: $excludeOptions"
    } catch {
        Write-Host "An error occurred while configuring wsl.conf for $distroName."
        Write-Log "Error configuring wsl.conf for ${distroName}: $_"
    }
}

# Example usage: Set-WSLConf -distroName "Ubuntu" -excludeMountPoints "D:", "E:"
