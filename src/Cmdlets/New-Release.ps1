using namespace System.Diagnostics.CodeAnalysis
using module ../Release.psm1
using module ../ReleaseAsset.psm1

<#
.SYNOPSIS
	Creates a new release.
.INPUTS
	The version number.
.OUTPUTS
	The newly created release.
#>
function New-HashLinkRelease {
	[CmdletBinding()]
	[OutputType([Release])]
	[SuppressMessage("PSUseShouldProcessForStateChangingFunctions", "")]
	param (
		# The version number.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[version] $Version,

		# The associated assets.
		[Parameter(Position = 1)]
		[ValidateNotNull()]
		[ReleaseAsset[]] $Assets = @()
	)

	process {
		[Release]::new($Version, $Assets)
	}
}
