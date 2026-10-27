using module ./Tools.psm1

Write-Information "Building the solution..."
Build-DotNetSolution ($Release ? "Release" : "Debug")
