using namespace System.Diagnostics.CodeAnalysis
using module ../Sources/Platform.psm1
using module ../Sources/Release.psm1

<#
.SYNOPSIS
	Tests the features of the `Release` class.
#>
Describe "Release" {
	BeforeAll {
		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "existingRelease")]
		$existingRelease = [Release]::new("1.15.0", @(
			[ReleaseAsset]::new([Platform]::Linux, "hashlink-1.15.0.zip")
			[ReleaseAsset]::new([Platform]::MacOS, "hashlink-1.15.0.zip")
			[ReleaseAsset]::new([Platform]::Windows, "hashlink-1.15.0.zip")
		))

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "latestRelease")]
		$latestRelease = [Release]::Latest()

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "nonExistingRelease")]
		$nonExistingRelease = [Release] "666.6.6"
	}

	Context "Exists" {
		It "should return `$true if the release exists" {
			Should-BeTrue $existingRelease.Exists()
		}

		It "should return `$false if the release does not exist" {
			Should-BeFalse $nonExistingRelease.Exists()
		}
	}

	Context "IsSource" {
		It "should return `$true if the release is provided as source code" {
			Should-BeTrue $nonExistingRelease.IsSource()
		}

		It "should return `$false if the release is provided as binary" {
			Should-BeFalse $existingRelease.IsSource()
		}
	}

	Context "Tag" {
		It "should not include the patch component if it's zero" {
			Should-BeString "1.15" $existingRelease.Tag()
		}

		It "should include the patch component if it's greater than zero" {
			Should-BeString "666.6.6" $nonExistingRelease.Tag()
		}
	}

	Context "Url" {
		It "should point to a GitHub tag if the release is provided as source code" {
			Should-BeString "https://github.com/HaxeFoundation/hashlink/archive/refs/tags/666.6.6.zip" $nonExistingRelease.Url().ToString() -CaseSensitive
		}

		It "should point to a GitHub release if the release is provided as binary" {
			Should-BeString "https://github.com/HaxeFoundation/hashlink/releases/download/1.15/hashlink-1.15.0.zip" $existingRelease.Url().ToString() -CaseSensitive
		}
	}

	Context "Find" {
		It "should return `$null if no release matches the version constraint" {
			Should-BeNull ([Release]::Find($nonExistingRelease.Version.ToString()))
			Should-BeNull ([Release]::Find("2"))
			Should-BeNull ([Release]::Find(">1.15")?.Version)
		}

		It "should return the release corresponding to the version constraint if it exists" {
			Should-BeSame $latestRelease ([Release]::Find("latest"))
			Should-BeSame $latestRelease ([Release]::Find("*"))
			Should-BeSame $latestRelease ([Release]::Find("1"))

			Should-Be ([Release] "1.8.0") ([Release]::Find("=1.8.0")?.Version)
			Should-Be ([Release] "1.9.0") ([Release]::Find("<1.10")?.Version)
			Should-Be ([Release] "1.10.0") ([Release]::Find("<=1.10")?.Version)
		}

		It "should throw if the version constraint is invalid" -ForEach "abc", "?1.10" {
			Should-Throw -ScriptBlock { [Release]::Find($_) }
		}
	}

	Context "Get" {
		It "should return `$null if no release matches to the version number" {
			Should-BeNull ([Release]::Get($nonExistingRelease.Version))
		}

		It "should return the release corresponding to the version number if it exists" {
			Should-Be ([semver] "1.8.0") ([Release]::Get("1.8.0")?.Version)
		}
	}

	Context "GetAsset" {
		It "should return `$null if no asset matches the platform" {
			Should-BeNull $nonExistingRelease.GetAsset([Platform]::Windows)
		}

		It "should return the asset corresponding to the platform number if it exists" {
			Should-BeString "hashlink-1.15.0.zip" $existingRelease.GetAsset([Platform]::Windows)?.File -CaseSensitive
		}
	}
}
