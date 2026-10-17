using namespace System.Diagnostics.CodeAnalysis
using module ../SetupHashLink.psd1

<#
.SYNOPSIS
	Tests the features of the `Install-Release` class.
#>
Describe "Install-Release" {
	BeforeAll {
		if (-not (Test-Path Env:GITHUB_ENV)) { $Env:GITHUB_ENV = Join-Path Temp GitHub-Env.txt }
		if (-not (Test-Path Env:GITHUB_PATH)) { $Env:GITHUB_PATH = Join-Path Temp GitHub-Path.txt }

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "path")]
		$path = Install-HashLinkRelease "latest"

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "release")]
		$release = Get-HashLinkLatestRelease
	}

	It "should properly download and extract the HashLink VM" {
		$isSource = $release.IsSource

		$executable = "hl$($isSource ? ".vcxproj" : ($IsWindows ? ".exe" : [string]::Empty))"
		Join-Path $path $executable | Test-Path | Should-BeTrue

		$dynamicLibrary = "libhl$($isSource ? ".vcxproj" : ($IsMacOS ? ".dylib" : ($IsLinux ? ".so" : ".dll")))"
		Join-Path $path $dynamicLibrary | Test-Path | Should-BeTrue
	}

	It "should add the HashLink VM binaries to the PATH environment variable" {
		$Env:PATH | Should-BeLikeString "*$path*" -CaseSensitive
		if ($IsLinux -and $release.IsSource) {
			$Env:LD_LIBRARY_PATH | Should-BeLikeString "*/usr/local/bin*" -CaseSensitive
		}
	}
}
