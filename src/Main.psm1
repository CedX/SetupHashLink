foreach ($cmdlet in Get-ChildItem "$PSScriptRoot/*.ps1" -Recurse) {
	. $cmdlet.FullName
}
