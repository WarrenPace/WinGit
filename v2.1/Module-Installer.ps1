# Module-Installer.ps1

$requiredModules = @('WindowsSubsystemForLinux', 'PowerShellGet')
foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Install-Module -Name $module -Force -Scope CurrentUser
    }
}
