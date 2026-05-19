using module ./Platform.psm1

<#
.SYNOPSIS
	Represents an asset of a HashLink release.
#>
[NoRunspaceAffinity()]
class ReleaseAsset {

	<#
	.SYNOPSIS
		The target file.
	#>
	[ValidateNotNullOrWhiteSpace()]
	[string] $File

	<#
	.SYNOPSIS
		The target platform.
	#>
	[Platform] $Platform

	<#
	.SYNOPSIS
		Creates a new release asset.
	.PARAMETER Platform
		The target platform.
	.PARAMETER File
		The target file.
	#>
	ReleaseAsset([Platform] $Platform, [string] $File) {
		$this.File = $File
		$this.Platform = $Platform
	}
}
