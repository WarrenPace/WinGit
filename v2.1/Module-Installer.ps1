# Module-Installer.ps1

. .\Logger.ps1

function Install-ModuleWithDependencies {
    param (
        [string]$moduleName
    )
    try {
        if (-not (Get-Module -ListAvailable -Name $moduleName)) {
            Write-Log "Installing module: $moduleName"
            Install-Module -Name $moduleName -Force -Scope CurrentUser
            Write-Log "$moduleName installed successfully."
        } else {
            Write-Log "$moduleName is already installed. Checking for updates."
            Update-Module -Name $moduleName
            Write-Log "$moduleName updated successfully."
        }

        # Check for and install any dependencies
        $dependencies = Find-Module -Name $moduleName | Select-Object -ExpandProperty Dependencies
        foreach ($dependency in $dependencies) {
            Install-ModuleWithDependencies -moduleName $dependency
        }
    } catch {
        Write-Log "Error occurred while installing/updating ${moduleName}: $_"
    }
}

$requiredModules = @('WindowsSubsystemForLinux', 'PowerShellGet')
foreach ($module in $requiredModules) {
    Install-ModuleWithDependencies -moduleName $module
}
