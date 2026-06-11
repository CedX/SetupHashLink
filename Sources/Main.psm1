foreach ($script in Get-ChildItem $PSScriptRoot -File -Filter *.ps1 -Recurse) {
	. $script.FullName
}
