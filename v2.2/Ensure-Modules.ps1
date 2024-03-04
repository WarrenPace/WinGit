# Ensure-Modules.ps1
$requiredModules = @('PowerShellGet') # Replace with your required modules
foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Install-Module -Name $module -Force -SkipPublisherCheck -Scope CurrentUser
    }
}
