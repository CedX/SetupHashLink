using module ./Tools.psm1

"Checking for outdated dependencies..."
(Import-PowerShellDataFile PSModules.psd1).Keys | Get-InstalledPSResource | Test-PSResourceUpdate
Test-NuGetPackageUpdate
