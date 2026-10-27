using module ./Tools.psm1

"Building the solution..."
Build-DotNetSolution ($Release ? "Release" : "Debug")
