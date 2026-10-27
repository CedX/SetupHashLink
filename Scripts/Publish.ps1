using module ./Tools.psm1

if ($Release) { & "$PSScriptRoot/Default.ps1" }
else { Write-Error "The ""-Release"" switch must be set!"; exit 1 }

$answer = Read-Host "Have the compiled assemblies been committed to the Git repository? (yes/no)"
if ($answer -notin "y", "yes") { exit 2 }

Write-Information "Publishing the package..."
$version = Get-Version
git tag "v$version"
git push origin "v$version"
