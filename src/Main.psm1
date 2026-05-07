foreach ($cmdlet in Get-ChildItem $PSScriptRoot -Filter *.ps1 -Recurse) {
	. $cmdlet.FullName
}
