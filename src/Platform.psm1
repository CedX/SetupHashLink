<#
.SYNOPSIS
	Identifies an operating system or platform.
#>
enum Platform {
	Linux
	MacOS
	Windows
}

<#
.SYNOPSIS
	Gets the current platform.
.OUTPUTS
	The current platform.
#>
function Get-HashLinkPlatform {
	[CmdletBinding()]
	[OutputType([Platform])]
	param ()

	switch ($true) {
		$IsLinux { [Platform]::Linux }
		$IsMacOS { [Platform]::MacOS }
		default { [Platform]::Windows }
	}
}
