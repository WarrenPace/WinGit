# File: Write-Log.ps1
function Write-Log {
    param (
        [string]$Message
    )
    $logPath = "WSL_Management_Log.txt"
    Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
}
