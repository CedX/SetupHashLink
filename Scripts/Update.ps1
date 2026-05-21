"Updating the dependencies..."
$modules = Import-PowerShellDataFile PSModules.psd1
foreach ($key in $modules.Keys) { Update-PSResource $module -Repository $modules[$key].repository -TrustRepository }
