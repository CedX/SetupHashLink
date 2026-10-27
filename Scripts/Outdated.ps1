using module ./Tools.psm1

Write-Information "Checking for outdated dependencies..."
(Import-PowerShellDataFile PSModules.psd1).Keys | Get-InstalledPSResource | Test-PSResourceUpdate
Test-NuGetPackageUpdate
