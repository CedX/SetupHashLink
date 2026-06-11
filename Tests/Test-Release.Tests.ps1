<#
.SYNOPSIS
	Tests the features of the `Test-Release` cmdlet.
#>
Describe "Test-Release" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$true for the latest release" {
		Test-HashLinkRelease $latestRelease.Version | Should -BeTrue
		$latestRelease | Test-HashLinkRelease | Should -BeTrue
	}

	It "should return `$true if the release exists" {
		Test-HashLinkRelease $existingRelease.Version | Should -BeTrue
		$existingRelease | Test-HashLinkRelease | Should -BeTrue
	}

	It "should return `$false if the release does not exist" {
		Test-HashLinkRelease $nonExistingRelease.Version | Should -BeFalse
		$nonExistingRelease | Test-HashLinkRelease | Should -BeFalse
	}
}
