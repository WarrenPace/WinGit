function Initialize-Logger {
    $Global:logPath = "C:\Users\admin\source\repos\WinGit\v2.1\WSL_Management_Log.txt"
    Add-Content -Path $Global:logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): Logger initialized"
}

function Write-Log {
    param (
        [string]$Message
    )
    Add-Content -Path $Global:logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
}

# Initialize the logger as soon as this script is run
Initialize-Logger
