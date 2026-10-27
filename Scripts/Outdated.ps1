using module ./Tools.psm1

Write-Information "Checking for outdated dependencies..."
dotnet package list --outdated
$modules = Import-PowerShellDataFile PSModules.psd1
$modules.Keys | Get-InstalledPSResource | Test-PSResourceUpdate
