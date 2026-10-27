using module ./Tools.psm1

Write-Information "Updating the version number in the sources..."
$version = Get-Version
Get-ChildItem -File -Filter *.fsproj -Recurse | ForEach-Object {
	(Get-Content $_ -Raw) -replace "<Version>\d+(\.\d+){2}</Version>", "<Version>$version</Version>" | Set-Content $_ -NoNewLine
}
