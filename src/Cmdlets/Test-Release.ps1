using module ../Release.psm1

<#
.SYNOPSIS
	Gets a value indicating whether a release with the specified version exists.
.INPUTS
	[string] The version number of the release to be tested.
.INPUTS
	[Release] The release to be tested.
.OUTPUTS
	`$true` if a release with the specified version exists, otherwise `$false`.
#>
function Test-HashLinkRelease {
	[CmdletBinding(DefaultParameterSetName = "Version")]
	[OutputType([bool])]
	param (
		# The version number of the release to be tested.
		[Parameter(Mandatory, ParameterSetName = "Version", Position = 0, ValueFromPipeline)]
		[version] $Version,

		# The release to be tested.
		[Parameter(Mandatory, ParameterSetName = "InputObject", ValueFromPipeline)]
		[Release] $InputObject
	)

	process {
		$release = $PSCmdlet.ParameterSetName -eq "InputObject" ? $InputObject : [Release] $Version
		$release.Exists()
	}
}
