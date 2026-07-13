<#
.SYNOPSIS
	Tests the features of the `Find-Release` cmdlet.
#>
Describe "Find-Release" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$null if no release matches the version constraint" {
		Should-BeNull (Find-HashLinkRelease $nonExistingRelease.Version)
	}

	It "should return the release corresponding to the version constraint if it exists" {
		Should-BeSame $latestRelease (Find-HashLinkRelease "latest")
		Should-BeSame $latestRelease (Find-HashLinkRelease "*")
		Should-BeSame $latestRelease (Find-HashLinkRelease "1")
		Should-BeNull (Find-HashLinkRelease "2")
		Should-BeNull (Find-HashLinkRelease ">1.15")?.Version
		Should-Be "1.8.0" (Find-HashLinkRelease "=1.8")?.Version
		Should-Be "1.9.0" (Find-HashLinkRelease "<1.10")?.Version
		Should-Be "1.10.0" (Find-HashLinkRelease "<=1.10")?.Version
	}

	It "should throw if the version constraint is invalid" -ForEach "abc", "?1.10" {
		Should-Throw -ScriptBlock { Find-HashLinkRelease $_ -ErrorAction Stop }
	}
}
