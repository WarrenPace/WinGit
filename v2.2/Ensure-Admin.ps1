# File: Ensure-Admin.ps1
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    try {
        Start-Process PowerShell -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
    } catch {
        Write-Warning "Failed to start script with administrative privileges."
        exit
    }
    exit
}
