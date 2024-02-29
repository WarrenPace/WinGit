# BEGIN: Test installation and setup
.\wsl-setup.ps1 -Flag ""
# Verify that the log file is created
Assert (Test-Path "J:\ubu\WSL_Setup_Log.txt")
# Verify that the installation is successful
Assert (wsl --list --quiet | Select-String "Ubuntu-22.04")
# Verify that the export is successful
Assert (Test-Path "J:\ubu\Ubuntu-22.04.tar")
# Verify that the unregister is successful
Assert (-not (wsl --list --quiet | Select-String "Ubuntu-22.04"))
# Verify that the import is successful
Assert (wsl --list --quiet | Select-String "Ubuntu-22.04")
# Verify that the export file is cleaned up
Assert (-not (Test-Path "J:\ubu\Ubuntu-22.04.tar"))
# END: Test installation and setup