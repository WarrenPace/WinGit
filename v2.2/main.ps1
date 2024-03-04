# main.ps1
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

. "$scriptPath\Write-Log.ps1"
. "$scriptPath\Ensure-Admin.ps1"
. "$scriptPath\Ensure-Modules.ps1"
. "$scriptPath\Get-MountPoints.ps1"
. "$scriptPath\Set-WSLConf.ps1"
. "$scriptPath\Move-WSLDistro.ps1"
. "$scriptPath\Uninstall-WSL.ps1"

# Main script logic
Write-Host "Welcome to the WSL Management Script"
Write-Log "Script started."

# Display menu and get user choices
Write-Host "Select the operations you want to perform (separate with commas):"
Write-Host "1. List Mount Points with Low Storage"
Write-Host "2. Configure wsl.conf for a distribution"
Write-Host "3. Migrate a WSL distribution"
Write-Host "4. Uninstall and Completely Remove WSL"
$userChoices = Read-Host "Enter your choices"

# Convert user input into an array of choices
$choices = $userChoices.Split(',').Trim() | ForEach-Object { [int]$_ }

# Execute functions based on user choices
if ($choices -contains 1) {
    Get-MountPoints
}

if ($choices -contains 2) {
    Configure-WSLConf
}

if ($choices -contains 3) {
    Migrate-WSLDistro
}

if ($choices -contains 4) {
    Uninstall-WSL
}

Write-Host "WSL Management operations completed."
Write-Log "Script completed."
