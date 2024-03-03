# MountPointManager.ps1

. .\Logger.ps1

function Select-MainMountDrive {
    $driveChoices = Get-PSDrive -PSProvider FileSystem | Format-Table -Property Name, Used, Free -AutoSize | Out-String
    $maxAttempts = 3
    $attempts = 0

    while ($attempts -lt $maxAttempts) {
        Write-Host "Available Drives:"
        Write-Host $driveChoices

        $selectedDrive = Read-Host "Enter the name of the drive to be the main mount drive"
        if ((Get-PSDrive -Name $selectedDrive -ErrorAction SilentlyContinue) -and (Get-PSDrive -Name $selectedDrive).Provider.Name -eq 'FileSystem') {
            Write-Log "Selected main mount drive: $selectedDrive"
            return $selectedDrive
        } else {
            Write-Host "Invalid drive name. Please try again."
            Write-Log "Invalid drive selection attempt: $selectedDrive"
            $attempts++
        }
    }

    Write-Host "Maximum attempts reached. Operation canceled."
    Write-Log "Failed to select main mount drive after maximum attempts."
    return $null
}

function Get-ExclusionList {
    $exclusions = Read-Host "Enter the mount points to exclude (comma-separated, leave blank for none)"
    $exclusionArray = $exclusions.Split(',') | ForEach-Object { $_.Trim() }
    Write-Log "Exclusion list: $exclusions"
    return $exclusionArray
}

function Test-SpaceRequirements {
    param (
        [string]$driveName,
        [int]$requiredSpaceGB = 10
    )

    $drive = Get-PSDrive -Name $driveName
    if ($drive.Free -gt $requiredSpaceGB * 1GB) {
        Write-Log "Drive $driveName meets space requirements."
        return $true
    } else {
        Write-Host "Drive $driveName does not have enough free space. Required: $requiredSpaceGB GB, Available: $($drive.Free / 1GB) GB"
        Write-Log "Drive $driveName fails to meet space requirements."
        return $false
    }
}

function Invoke-MountPointsManagement {
    $mainDrive = Select-MainMountDrive
    if (-not $mainDrive) {
        return
    }

    $exclusionList = Get-ExclusionList
    $spaceCheck = Check-SpaceRequirements -driveName $mainDrive

    if (-not $spaceCheck) {
        Write-Host "Operation aborted due to insufficient space."
        Write-Log "Operation aborted: Insufficient space on $mainDrive."
    } else {
        # Continue with further operations
        Write-Log "Proceeding with mount point management on $mainDrive with exclusions: $exclusionList"
        # Implementation for managing mount points goes here
    }
}

# Invoke the Manage-MountPoints function
Invoke-MountPointsManagement
