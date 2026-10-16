using module ../SetupHashLink.psd1

<#
.SYNOPSIS
	Tests the features of the `Find-Release` cmdlet.
#>
Describe "Find-Release" -Skip {
	It "should return `$null if no release matches the version constraint" {
		"666.6.6" | Find-HashLinkRelease | Should-BeNull
	}

	It "should return the release corresponding to the version constraint if it exists" {
		$latestRelease = Get-HashLinkLatestRelease
		"*", "latest", "1" | ForEach-Object { $_ | Find-HashLinkRelease | Should-BeSame $latestRelease }
		"2", ">1.16", "?1.15", "abc" | ForEach-Object { $_ | Find-HashLinkRelease | Should-BeNull }
		("=1.8", "1.8.0"), ("<1.10", "1.9.0"), ("<=1.10", "1.10.0") | ForEach-Object { (Find-HashLinkRelease $_[0])?.Version | Should-Be ([version] $_[1]) }
	}
}

<#
.SYNOPSIS
	Tests the features of the `Get-LatestRelease` cmdlet.
#>
Describe "Get-LatestRelease" -Skip {
	It "should always return the latest available release" {
		$latestRelease = Get-HashLinkLatestRelease
		$latestRelease | Should-BeSame (Get-HashLinkLatestRelease)

		$releases = Get-Content "$PSScriptRoot/../Resources/Releases.json" -Raw | ConvertFrom-Json
		$latestRelease.Version | Should-Be $releases[0].Version
	}
}

<#
.SYNOPSIS
	Tests the features of the `Get-Release` cmdlet.
#>
Describe "Get-Release" -Skip {
	It "should return `$null if no release matches to the version number" {
		"666.6.6" | Get-HashLinkRelease | Should-BeNull
	}

	It "should return the release corresponding to the version number if it exists" {
		(Get-HashLinkRelease "1.8.0")?.Version | Should-Be ([version] "1.8.0")
	}

	It "should return the latest release when '*' is used as version number" {
		$latestRelease = Get-HashLinkLatestRelease
		"*", "latest" | ForEach-Object { $_ | Get-HashLinkRelease | Should-BeSame $latestRelease }
	}
}

<#
.SYNOPSIS
	Tests the features of the `New-Release` cmdlet.
#>
Describe "New-Release" -Skip {
	Context "IsSource" {
		It "should return `$true if the release is provided as source code" {
			$nonExistingRelease = New-HashLinkRelease "666.6.6"
			$nonExistingRelease.IsSource | Should-BeTrue
		}

		It "should return `$false if the release is provided as binary" {
			$existingRelease = New-HashLinkRelease "1.16.0" @(
				New-HashLinkReleaseAsset Linux "hashlink-1.16.0.zip"
				New-HashLinkReleaseAsset MacOS "hashlink-1.16.0.zip"
				New-HashLinkReleaseAsset Windows "hashlink-1.16.0.zip"
			)

			$existingRelease.IsSource | Should-BeFalse
		}
	}

	Context "Tag" {
		It "should not include the build component if it's zero" {
			(New-HashLinkRelease "1.16.0").Tag | Should-BeString "1.16"
		}

		It "should include the build component if it's greater than zero" {
			(New-HashLinkRelease "666.6.6").Tag | Should-BeString "666.6.6"
		}
	}

	Context "Url" {
		It "should point to a GitHub tag if the release is provided as source code" {
			$nonExistingReleaseUrl = (New-HashLinkRelease "666.6.6").Url.ToString()
			$nonExistingReleaseUrl | Should-BeString "https://github.com/HaxeFoundation/hashlink/archive/refs/tags/666.6.6.zip" -CaseSensitive
		}

		It "should point to a GitHub release if the release is provided as binary" {
			$existingReleaseUrl = (New-HashLinkRelease "1.16.0").Url.ToString()
			$existingReleaseUrl | Should-BeString "https://github.com/HaxeFoundation/hashlink/releases/download/1.16/hashlink-1.16.0.zip" -CaseSensitive
		}
	}
}

<#
.SYNOPSIS
	Tests the features of the `Test-Release` cmdlet.
#>
Describe "Test-Release" {
	It "should return `$true for the latest release" {
		$latestRelease = Get-HashLinkLatestRelease
		$latestRelease | Test-HashLinkRelease | Should-BeTrue
		Test-HashLinkRelease $latestRelease.Version | Should-BeTrue
	}

	It "should return `$true if the release exists" {
		$existingRelease = New-HashLinkRelease "1.16.0"
		$existingRelease | Test-HashLinkRelease | Should-BeTrue
		Test-HashLinkRelease $existingRelease.Version | Should-BeTrue
	}

	It "should return `$false if the release does not exist" {
		$nonExistingRelease = New-HashLinkRelease "666.6.6"
		$nonExistingRelease | Test-HashLinkRelease | Should-BeFalse
		Test-HashLinkRelease $nonExistingRelease.Version | Should-BeFalse
	}
}
