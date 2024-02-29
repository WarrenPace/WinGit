function Install-RequiredModules {
    param ([string[]]$requiredModules)
    foreach ($module in $requiredModules) {
        try {
            # Check if module is available in the registered repositories
            Find-Module -Name $module -ErrorAction Stop
            # Install the module
            Install-Module -Name $module -Force -Scope CurrentUser
            Write-Host "Module '$module' installed successfully."
        } catch {
            Write-Host "Module '$module' not found or failed to install: $_"
        }
    }
}

# Define the list of required modules
$requiredModules = @('PowerShellGet') # Add or update required modules

# Install required modules
Install-RequiredModules -requiredModules $requiredModules
