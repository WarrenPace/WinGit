# MenuHandler.ps1

. .\Logger.ps1
. .\MountPointManager.ps1
. .\WSLConfigurationManager.ps1
. .\WSLMigrationManager.ps1
. .\WSLUninstaller.ps1

function Display-Menu {
    Write-Host "Select the operations you want to perform:"
    Write-Host "1. List Mount Points with Low Storage"
    Write-Host "2. Configure wsl.conf for a distribution"
    Write-Host "3. Migrate a WSL distribution"
    Write-Host "4. Uninstall and Completely Remove WSL"
    Write-Host "5. Exit"
}

function Process-UserChoice {
    param (
        [int]$choice
    )
    switch ($choice) {
        1 {
            Write-Host "Listing mount points with low storage:"
            Get-MountPoints
        }
        2 {
            Configure-WSL
        }
        3 {
            Migrate-WSLDistro
        }
        4 {
            Uninstall-WSL
        }
        5 {
            Write-Host "Exiting..."
            return $false
        }
        default {
            Write-Host "Invalid choice. Please try again."
            return $true
        }
    }
    return $true
}

function Main {
    do {
        Display-Menu
        $choice = Read-Host "Enter your choice"
        $continue = Process-UserChoice -choice $choice
    } while ($continue)
}

# Start the main function
Main
