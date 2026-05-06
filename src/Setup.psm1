using namespace System.IO
using module ./Platform.psm1
using module ./Release.psm1

<#
.SYNOPSIS
	Manages the download and installation of the HashLink VM.
#>
class Setup {

	<#
	.SYNOPSIS
		The release to download and install.
	#>
	[ValidateNotNull()]
	[Release] $Release

	<#
	.SYNOPSIS
		Creates a new setup.
	.PARAMETER Release
		The release to download and install.
	#>
	Setup([Release] $Release) {
		$this.Release = $Release
	}

	<#
	.SYNOPSIS
		Downloads and extracts the ZIP archive of the HashLink VM.
	.OUTPUTS
		The path to the extracted directory.
	#>
	[string] Download() {
		$file = New-TemporaryFile
		Invoke-WebRequest $this.Release.Url() -OutFile $file

		$directory = Join-Path ([Path]::GetTempPath()) (New-Guid)
		Expand-Archive $file -DestinationPath $directory -Force

		$folders = Get-ChildItem $directory -Directory
		if ($folders.Count -ne 1) { throw [DirectoryNotFoundException] "No subfolders or multiple subfolders found in: $directory" }
		return Join-Path $directory $folders[0].BaseName
	}

	<#
	.SYNOPSIS
		Installs the HashLink VM, after downloading it.
	.OUTPUTS
		The path to the installation directory.
	#>
	[string] Install() {
		$directory = $this.Download()
		$isSource = $this.Release.IsSource()
		if ($isSource -and $Env:CI) { $this.Compile($directory) }

		$binFolder = $isSource ? (Join-Path $directory bin) : $directory
		$Env:PATH += "$([Path]::PathSeparator)$binFolder"
		Add-Content $Env:GITHUB_PATH $binFolder
		return $directory
	}

	<#
	.SYNOPSIS
		Compiles the sources of the HashLink VM located in the specified directory.
	.PARAMETER Directory
		The path to the directory containing the HashLink sources.
	.OUTPUTS
		The path to the output directory.
	#>
	hidden [string] Compile([string] $Directory) {
		$platform = Get-HashLinkPlatform
		if ($platform -eq [Platform]::Windows) { throw [PlatformNotSupportedException] "Compilation is not supported on Windows platform." }

		Push-Location $Directory
		$path = $platform -eq [Platform]::MacOS ? $this.CompileMacOS() : $this.CompileLinux()
		Pop-Location
		return $path
	}

	<#
	.SYNOPSIS
		Compiles the HashLink sources on the Linux platform.
	.OUTPUTS
		The path to the output directory.
	#>
	hidden [string] CompileLinux() {
		$dependencies = @(
			"libglu1-mesa-dev",
			"libmbedtls-dev",
			"libopenal-dev",
			"libpng-dev",
			"libsdl2-dev",
			"libsqlite3-dev",
			"libturbojpeg-dev",
			"libuv1-dev",
			"libvorbis-dev"
		)

		sudo apt-get update
		sudo apt-get install --assume-yes --no-install-recommends @dependencies
		make
		sudo make install
		sudo ldconfig

		$prefix = "/usr/local"
		$Env:LD_LIBRARY_PATH += "$([Path]::PathSeparator)$prefix/bin"
		Add-Content $Env:GITHUB_ENV "LD_LIBRARY_PATH=$Env:LD_LIBRARY_PATH"
		return $prefix
	}

	<#
	.SYNOPSIS
		Compiles the HashLink sources on the macOS platform.
	.OUTPUTS
		The path to the output directory.
	#>
	hidden [string] CompileMacOS() {
		$prefix = "/usr/local"

		brew bundle
		make
		sudo make codesign_osx
		sudo make install
		sudo install_name_tool -change libhl.dylib $prefix/lib/libhl.dylib $prefix/bin/hl

		return $prefix
	}
}
