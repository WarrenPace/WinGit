# Import the Initialize-Environment and Utility Functions scripts
. .\Initialize-Environment.ps1
. .\UtilityFunctions.ps1

function Main {
    Initialize-Environment

    # Define the list of required modules
    $requiredModules = @('PowerShellGet') # Add other required modules here

    Install-RequiredModules -requiredModules $requiredModules

    # Additional main script logic can be added here...

    # Example: Write a log entry
    Write-Log "WSL Management Tool script started."

    # Example: Get and display mount points with low storage
    Write-Host "Listing mount points with low storage:"
    Get-MountPoints
}

# Execute the script
Main
