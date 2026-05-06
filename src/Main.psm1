foreach ($cmdlet in Get-ChildItem "$PSScriptRoot/Cmdlets/*.ps1") {
	. $cmdlet.FullName
}
