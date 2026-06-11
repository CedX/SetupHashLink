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
function Get-Platform {
	[CmdletBinding()]
	[OutputType([Platform])]
	param ()

	switch ($true) {
		$IsLinux { return [Platform]::Linux }
		$IsMacOS { return [Platform]::MacOS }
		default { [Platform]::Windows }
	}
}
