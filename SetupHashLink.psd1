@{
	ModuleVersion = "8.2.0"
	PowerShellVersion = "7.4"
	RootModule = "src/Main.psm1"

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
		"Get-HashLinkRelease"
		"Install-HashLinkRelease"
		"New-HashLinkRelease"
		"New-HashLinkReleaseAsset"
		"Test-HashLinkRelease"
	)

	PrivateData = @{
		PSData = @{
			LicenseUri = "https://github.com/cedx/setup-hashlink/blob/main/License.md"
			ProjectUri = "https://github.com/cedx/setup-hashlink"
			ReleaseNotes = "https://github.com/cedx/setup-hashlink/releases"
			Tags = "actions", "ci", "hashlink", "haxe"
		}
	}
}
