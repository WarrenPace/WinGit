function Initialize-Environment {
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        try {
            Start-Process PowerShell -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
        } catch {
            Write-Warning "Failed to start script with administrative privileges."
            exit
        }
        exit
    }

    try {
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Install-Module -Name PowerShellGet -Force
        Install-Module -Name PackageManagement -Force
    } catch {
        Write-Warning "An error occurred while updating: $_"
    }
}
