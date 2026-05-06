using module ../Release.psm1

<#
.SYNOPSIS
	Gets the release corresponding to the specified version.
.INPUTS
	A string that contains a version number.
.OUTPUTS
	The release corresponding to the specified version, or `$null` if not found.
#>
function Get-HashLinkRelease {
	[CmdletBinding()]
	[OutputType([Release])]
	param (
		# The version number. Use `*` or `Latest` to get the latest release.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[string] $Version
	)

	process {
		$Version -in "*", "Latest" ? [Release]::Latest() : [Release]::Get($Version)
	}
}
