using module PSScriptAnalyzer
using module ./Tools.psm1

Write-Information "Performing the static analysis of source code..."
Invoke-FSharpLint SetupHashLink.slnx -Configuration Configuration/FSharpLint.json
$PSScriptRoot, "Tests" | Invoke-ScriptAnalyzer -Recurse
Test-ModuleManifest SetupHashLink.psd1 | Out-Null
