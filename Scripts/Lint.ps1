using module PSScriptAnalyzer
using module ./Tools.psm1

Write-Information "Performing the static analysis of source code..."
dotnet fsharplint lint --lint-config Configuration/FSharpLint.json (Get-Solution)
$PSScriptRoot, "Tests" | Invoke-ScriptAnalyzer -Recurse
Test-ModuleManifest (Get-Manifest) | Out-Null
