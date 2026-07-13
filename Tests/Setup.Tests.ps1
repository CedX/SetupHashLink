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
			$setup = [Setup]::new($latestRelease)
			$isSource = $setup.Release.IsSource()
			$path = $setup.Download()

			$executable = "hl$($isSource ? ".vcxproj" : ($IsWindows ? ".exe" : [string]::Empty))"
			Should-BeTrue (Join-Path $path $executable | Test-Path)

			$dynamicLibrary = "libhl$($isSource ? ".vcxproj" : ($IsMacOS ? ".dylib" : ($IsLinux ? ".so" : ".dll")))"
			Should-BeTrue (Join-Path $path $dynamicLibrary | Test-Path)
		}
	}

	Context "Install" {
		It "should add the HashLink VM binaries to the PATH environment variable" {
			$setup = [Setup]::new($latestRelease)
			$path = $setup.Install()

			Should-BeLikeString "*$path*" $Env:PATH -CaseSensitive
			if ($IsLinux -and $setup.Release.IsSource()) {
				Should-BeLikeString "*/usr/local/bin*" $Env:LD_LIBRARY_PATH -CaseSensitive
			}
		}
	}
}
