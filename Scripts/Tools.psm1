<#
.SYNOPSIS
	The cached contents of the module manifest.
#>
[psobject] $Script:Manifest = $null

<#
.SYNOPSIS
	Gets the path, or the contents, of the module manifest.
.OUTPUTS
	[hashtable] The contents of the module manifest.
.OUTPUTS
	[System.IO.FileInfo] The path to the module manifest.
#>
function Get-Manifest {
	[CmdletBinding(DefaultParameterSetName = "FileInfo")]
	[OutputType([hashtable], [System.IO.FileInfo])]
	param (
		# Value indicating whether to return the module data instead of its path.
		[Parameter(ParameterSetName = "AsHashtable")]
		[switch] $AsHashtable
	)

	if ($null -eq $Script:Manifest) {
		$file =
			Get-ChildItem (Join-Path $PSScriptRoot ..) -File -Filter *.psd1
			| Where-Object BaseName -NotIn "PSModules", "PSScriptAnalyzerSettings"
			| Select-Object -First 1

		$Script:Manifest = [pscustomobject]@{
			FileInfo = $file
			HashTable = Import-PowerShellDataFile $file
		}
	}

	$AsHashtable ? $Script:Manifest.HashTable : $Script:Manifest.FileInfo
}

<#
.SYNOPSIS
	Gets the path to the solution file.
.OUTPUTS
	The path to the solution file.
#>
function Get-Solution {
	[CmdletBinding()]
	[OutputType([System.IO.FileInfo])]
	param ()

	Get-ChildItem (Join-Path $PSScriptRoot ..) -File -Filter *.slnx
	| Select-Object -First 1
}

<#
.SYNOPSIS
	Gets the project version number.
.OUTPUTS
	The project version number.
#>
function Get-Version {
	[CmdletBinding()]
	[OutputType([version])]
	param ()

	[version]::Parse((Get-Manifest -AsHashtable).ModuleVersion)
}

<#
.SYNOPSIS
	Checks whether an update is available for the specified PowerShell module.
.INPUTS
	The PowerShell module to be checked.
.OUTPUTS
	An object providing the current and the latest version of the specified module if an update is available, otherwise none.
#>
function Test-PSResourceUpdate {
	[CmdletBinding()]
	[OutputType([psobject])]
	param (
		# The PowerShell module to be checked.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline)]
		[Microsoft.PowerShell.PSResourceGet.UtilClasses.PSResourceInfo] $InputObject
	)

	process {
		if ($InputObject.Repository -ne "PSGallery") { return }

		$url = "https://www.powershellgallery.com/packages/$($InputObject.Name)"
		$response = Invoke-WebRequest $url -Method Head -MaximumRedirection 0 -SkipHttpErrorCheck -ErrorAction Ignore
		$latestVersion = [version]::Parse((Split-Path $response.Headers.Location -Leaf))

		$module = [pscustomobject]@{ ModuleName = $InputObject.Name; CurrentVersion = $InputObject.Version; LatestVersion = $latestVersion }
		if ($module.LatestVersion -gt $module.CurrentVersion) { $module }
	}
}
