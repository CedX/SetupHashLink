<#
.SYNOPSIS
	Tests the features of the `Test-Release` cmdlet.
#>
Describe "Test-Release" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$true for the latest release" {
		Should-BeTrue (Test-HashLinkRelease $latestRelease.Version)
		Should-BeTrue ($latestRelease | Test-HashLinkRelease)
	}

	It "should return `$true if the release exists" {
		Should-BeTrue (Test-HashLinkRelease $existingRelease.Version)
		Should-BeTrue ($existingRelease | Test-HashLinkRelease)
	}

	It "should return `$false if the release does not exist" {
		Should-BeFalse (Test-HashLinkRelease $nonExistingRelease.Version)
		Should-BeFalse ($nonExistingRelease | Test-HashLinkRelease)
	}
}
