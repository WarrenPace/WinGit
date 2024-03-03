# WSLUninstaller.ps1

. .\Logger.ps1

function Uninstall-WSL {
    try {
        # Uninstall WSL feature
        Write-Log "Attempting to disable WSL feature..."
        Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
        Write-Host "WSL feature has been disabled."
        Write-Log "WSL feature disabled."

        # Remove all WSL distributions
        $distros = wsl --list --quiet
        foreach ($distro in $distros) {
            Write-Log "Removing WSL distribution: $distro"
            wsl --unregister $distro
            Write-Host "Removed WSL distribution: $distro"
            Write-Log "WSL distribution $distro removed."
        }

        Write-Log "WSL has been uninstalled and all distributions have been removed."
    } catch {
        Write-Host "An error occurred during the WSL uninstallation process."
        Write-Log "Error during WSL uninstallation: $_"
    }
}
