# File: Get-MountPoints.ps1
function Get-MountPoints {
    Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Free -lt 10GB } | Format-Table Name, Used, Free -AutoSize
}
