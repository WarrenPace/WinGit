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

# Check if choice 1 is selected
if ($choices -contains 1) {
    Write-Host "Listing mount points with low storage:"
    Get-MountPoints
}

# Check if choice 2 is selected
if ($choices -contains 2) {
    # List available Linux distributions
    $distros = wsl --list --online | Select-Object -Skip 1
    Write-Host "Available Linux Distributions:"
    $distros | ForEach-Object { Write-Host "$($_)" }
    $distroSelection = Read-Host "Select a distribution by number"
    $selectedDistro = $distros[$distroSelection]

    $excludeMountPoints = Read-Host "Enter the mount points to exclude (comma-separated)"
    Set-WSLConf -distroName $selectedDistro -excludeMountPoints $excludeMountPoints.Split(',')
}

# Check if choice 3 is selected
if ($choices -contains 3) {
    $distroName = Read-Host "Enter the WSL distribution name to migrate"
    $newLocation = Read-Host "Enter the new location for the WSL distribution"
    Move-WSLDistro -distroName $distroName -newLocation $newLocation
}

# Check if choice 4 is selected
if ($choices -contains 4) {
    Write-Host "Uninstalling and completely removing WSL..."
    Uninstall-WSL
}

Write-Host "WSL Management operations completed."
Write-Log "Script completed."
