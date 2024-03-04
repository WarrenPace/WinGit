# File: Move-WSLDistro.ps1
function Move-WSLDistro {
    Param (
        [string]$distroName,
        [string]$newLocation
    )

    $exportPath = "$newLocation\$distroName.tar"
    try {
        wsl --export $distroName $exportPath
        wsl --unregister $distroName
        wsl --import $distroName $newLocation $exportPath
        Remove-Item $exportPath -Force
        Write-Host "$distroName has been migrated to $newLocation."
        Write-Log "Migrated $distroName to $newLocation."
    } catch {
        Write-Host "An error occurred during migration."
        Write-Log "Error during migration: $_"
    }
}
