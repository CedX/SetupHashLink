Write-Information "Updating the version number in the sources..."
$version = (Import-PowerShellDataFile SetupHashLink.psd1).ModuleVersion
Get-ChildItem -File -Filter *.fsproj -Recurse | ForEach-Object {
	(Get-Content $_ -Raw) -replace "<Version>\d+(\.\d+){2}</Version>", "<Version>$version</Version>" | Set-Content $_ -NoNewLine
}
