using module ./Cmdlets.psm1

if ($Release) { & "$PSScriptRoot/Default.ps1" }
else {
	"The ""-Release"" switch must be set!"
	exit 1
}

"Checking the status of the compiled assemblies..."
$status = git status
if (($status -like "*Binaries/FSharp.Core.dll*") -or ($status -like "*Binaries/Belin.SetupHashLink.dll*")) {
	"The compiled assemblies must be committed!"
	exit 2
}

"Publishing the package..."
$version = (Import-PowerShellDataFile SetupHashLink.psd1).ModuleVersion
New-GitTag "v$version"
