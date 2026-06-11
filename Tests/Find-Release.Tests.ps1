<#
.SYNOPSIS
	Tests the features of the `Find-Release` cmdlet.
#>
Describe "Find-Release" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$null if no release matches the version constraint" {
		Find-HashLinkRelease $nonExistingRelease.Version | Should -BeNullOrEmpty
	}

	It "should return the release corresponding to the version constraint if it exists" {
		Find-HashLinkRelease "latest" | Should -Be $latestRelease
		Find-HashLinkRelease "*" | Should -Be $latestRelease
		Find-HashLinkRelease "1" | Should -Be $latestRelease
		Find-HashLinkRelease "2" | Should -BeNullOrEmpty
		(Find-HashLinkRelease ">1.15")?.Version | Should -BeNullOrEmpty
		(Find-HashLinkRelease "=1.8")?.Version | Should -Be "1.8.0"
		(Find-HashLinkRelease "<1.10")?.Version | Should -Be "1.9.0"
		(Find-HashLinkRelease "<=1.10")?.Version | Should -Be "1.10.0"
	}

	It "should throw if the version constraint is invalid" -ForEach "abc", "?1.10" {
		{ Find-HashLinkRelease $_ -ErrorAction Stop } | Should -Throw
	}
}
