# Logger.ps1
function Initialize-Logger {
    $Global:logPath = "WSL_Management_Log.txt"
    Add-Content -Path $Global:logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): Script initialized"
}

function Write-Log {
    param ([string]$Message)
    Add-Content -Path $Global:logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
}
