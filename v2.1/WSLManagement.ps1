# WSLManagement.ps1
. .\Logger.ps1
Initialize-Logger
# Check for administrative rights
. .\Check-Admin.ps1

# Import required modules
. .\Module-Installer.ps1
. .\Logger.ps1
. .\MountPointManager.ps1
. .\WSLConfigurationManager.ps1
. .\WSLMigrationManager.ps1
. .\WSLUninstaller.ps1

# Initialize Logger
Initialize-Logger

# Display menu and handle user input
. .\MenuHandler.ps1
