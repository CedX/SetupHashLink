using namespace System.Diagnostics.CodeAnalysis
using module ../Sources/Release.psm1
using module ../Sources/Setup.psm1

<#
.SYNOPSIS
	Tests the features of the `Setup` class.
#>
Describe "Setup" {
	BeforeAll {
		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
		$latestRelease = [Release]::Latest()

		if (-not (Test-Path Env:GITHUB_ENV)) { $Env:GITHUB_ENV = Join-Path var GitHub-Env.txt }
		if (-not (Test-Path Env:GITHUB_PATH)) { $Env:GITHUB_PATH = Join-Path var GitHub-Path.txt }
	}

	Context "Download" {
		It "should properly download and extract the HashLink VM" {
			$setup = [Setup] $latestRelease
			$isSource = $setup.Release.IsSource()
			$path = $setup.Download()

			$executable = "hl$($isSource ? ".vcxproj" : ($IsWindows ? ".exe" : [string]::Empty))"
			Join-Path $path $executable | Should -Exist

			$dynamicLibrary = "libhl$($isSource ? ".vcxproj" : ($IsMacOS ? ".dylib" : ($IsLinux ? ".so" : ".dll")))"
			Join-Path $path $dynamicLibrary | Should -Exist
		}
	}

	Context "Install" {
		It "should add the HashLink VM binaries to the PATH environment variable" {
			$setup = [Setup] $latestRelease
			$path = $setup.Install()

			$Env:PATH | Should -BeLikeExactly "*$path*"
			if ($IsLinux -and $setup.Release.IsSource()) {
				$Env:LD_LIBRARY_PATH | Should -BeLikeExactly "*/usr/local/bin*"
			}
		}
	}
}
