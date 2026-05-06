using namespace System.Diagnostics.CodeAnalysis
using module ../Platform.psm1
using module ../ReleaseAsset.psm1

<#
.SYNOPSIS
	Creates a new release asset.
.OUTPUTS
	The newly created release asset.
#>
function New-HashLinkReleaseAsset {
	[CmdletBinding()]
	[OutputType([ReleaseAsset])]
	[SuppressMessage("PSUseShouldProcessForStateChangingFunctions", "")]
	param (
		# The target platform.
		[Parameter(Mandatory, Position = 0)]
		[Platform] $Platform,

		# The target file.
		[Parameter(Mandatory, Position = 1)]
		[string] $File
	)

	[ReleaseAsset]::new($Platform, $File)
}
