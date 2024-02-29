# Import the necessary scripts
. .\Dependencies.ps1
. .\Initialize-Environment.ps1
. .\UtilityFunctions.ps1

function Main {
    # Initialize the environment
    Initialize-Environment

    # Main script logic
    Write-Log "WSL Management Tool script started."
    Write-Host "Listing mount points with low storage:"
    Get-MountPoints
    Set-WSLConf
    Move-WSLDistro
    Uninstall-WSL
    
        
    # Additional main script logic can be added here...
}

# Execute the Main function
Main
