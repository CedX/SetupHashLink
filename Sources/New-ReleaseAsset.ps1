using namespace System.Diagnostics.CodeAnalysis
using module ./Platform.psm1
using module ./Release.psm1

<#
.SYNOPSIS
	Creates a new release asset.
.OUTPUTS
	The newly created release asset.
#>
function New-ReleaseAsset {
	[CmdletBinding()]
	[OutputType([ReleaseAsset])]
	[SuppressMessage("PSUseShouldProcessForStateChangingFunctions", "")]
	param (
		# The target platform.
		[Parameter(Mandatory, Position = 1)]
		[Platform] $Platform,

		# The target file.
		[Parameter(Mandatory, Position = 2)]
		[string] $File
	)

	[ReleaseAsset]::new($Platform, $File)
}
