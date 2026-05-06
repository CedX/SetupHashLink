using module ../Release.psm1
using module ../Setup.psm1

<#
.SYNOPSIS
	Installs the HashLink VM, after downloading it.
.INPUTS
	[string] The version constraint of the release to be installed.
.INPUTS
	[Release] The release to be installed.
.OUTPUTS
	The path to the installation directory.
#>
function Install-HashLinkRelease {
	[CmdletBinding(DefaultParameterSetName = "Constraint")]
	[OutputType([string])]
	param (
		# The version constraint of the release to be installed.
		[Parameter(Mandatory, ParameterSetName = "Constraint", Position = 0, ValueFromPipeline)]
		[string] $Constraint,

		# The instance of the release to be installed.
		[Parameter(Mandatory, ParameterSetName = "InputObject", ValueFromPipeline)]
		[Release] $InputObject
	)

	process {
		$release = $PSCmdlet.ParameterSetName -eq "InputObject" ? $InputObject : [Release]::Find($Constraint)
		if (${release}?.Exists()) { [Setup]::new($release).Install() }
		else { Write-Error "No release matches the specified version constraint." }
	}
}
