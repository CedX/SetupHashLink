& "$PSScriptRoot/Build.ps1"

Write-Information "Running the test suite..."
pwsh -Command {
	Import-Module Pester
	Invoke-Pester Tests
	exit $LASTEXITCODE
}
