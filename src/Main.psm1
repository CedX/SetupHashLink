foreach ($cmdlet in Get-ChildItem $PSScriptRoot -File -Filter *.ps1 -Recurse) {
	. $cmdlet.FullName
}
