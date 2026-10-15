& "$PSScriptRoot/Build.ps1"

"Running the test suite..."
pwsh -Command {
	Import-Module Pester
	Invoke-Pester Tests
	exit $LASTEXITCODE
}
