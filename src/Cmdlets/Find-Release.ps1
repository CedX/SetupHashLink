using module ../Release.psm1

<#
.SYNOPSIS
	Finds a release that matches the specified version constraint.
.INPUTS
	The version constraint.
.OUTPUTS
	The release corresponding to the specified constraint, or `$null` if not found.
#>
function Find-HashLinkRelease {
	[CmdletBinding()]
	[OutputType([Release])]
	param (
		# The version constraint.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[string] $Constraint
	)

	process {
		[Release]::Find($Constraint)
	}
}
