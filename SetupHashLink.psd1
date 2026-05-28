@{
	ModuleVersion = "8.2.0"
	PowerShellVersion = "7.4"
	RootModule = "Sources/Main.psm1"

	Author = "Cédric Belin <cedx@outlook.com>"
	CompanyName = "Cedric-Belin.fr"
	Copyright = "© Cédric Belin"
	Description = "Set up your GitHub Actions workflow with a specific version of the HashLink VM."
	GUID = "6bb1e481-9f7c-4dd0-922c-fdf44f2c0e78"

	AliasesToExport = @()
	CmdletsToExport = @()
	VariablesToExport = @()

	FunctionsToExport = @(
		"Find-HashLinkRelease"
		"Get-HashLinkPlatform"
		"Get-HashLinkRelease"
		"Install-HashLinkRelease"
		"New-HashLinkRelease"
		"New-HashLinkReleaseAsset"
		"Test-HashLinkRelease"
	)

	PrivateData = @{
		PSData = @{
			LicenseUri = "https://github.com/CedX/SetupHashLink/blob/main/License.md"
			ProjectUri = "https://github.com/CedX/SetupHashLink"
			ReleaseNotes = "https://github.com/CedX/SetupHashLink/releases"
			Tags = "actions", "ci", "hashlink", "haxe"
		}
	}
}
