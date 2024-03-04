# File: Uninstall-WSL.ps1
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
