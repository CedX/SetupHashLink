using namespace System.Diagnostics.CodeAnalysis

<#
.SYNOPSIS
	Builds the .NET solution and all of its dependencies.
#>
function Build-DotNetSolution {
	param (
		# The configuration to use for generating the project.
		[Parameter(Position = 1)]
		[string] $Configuration
	)

	$argumentList = $Configuration ? "--configuration", $Configuration : @()
	dotnet build @argumentList
}

<#
.SYNOPSIS
	Invokes the FSharpLint static analyzer.
#>
function Invoke-FSharpLint {
	param (
		# The path to the file or directory to be analyzed.
		[Parameter(Mandatory, Position = 1)]
		[string[]] $Path,

		# The path to the configuration file.
		[ValidateScript({ Test-Path $_ -PathType Leaf }, ErrorMessage = "The specified configuration file does not exist.")]
		[string] $Configuration
	)

	$argumentList = $Configuration ? "--lint-config", $Configuration : @()
	$argumentList += $Path
	dotnet fsharplint lint @argumentList
}

<#
.SYNOPSIS
	Creates a new Git tag.
#>
function New-GitTag {
	[SuppressMessage("PSUseShouldProcessForStateChangingFunctions", "")]
	param (
		# The tag name.
		[Parameter(Mandatory, Position = 1)]
		[string] $Name
	)

	git tag $Name
	git push origin $Name
}

<#
.SYNOPSIS
	Checks whether an update is available for the NuGet packages.
#>
function Test-NuGetPackageUpdate {
	dotnet package list --outdated
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
		$latestVersion = [semver] (Split-Path $response.Headers.Location -Leaf)

		$module = [pscustomobject]@{ ModuleName = $InputObject.Name; CurrentVersion = $InputObject.Version; LatestVersion = $latestVersion }
		if ($module.LatestVersion -gt $module.CurrentVersion) { $module }
	}
}
