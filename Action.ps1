#!/usr/bin/env pwsh
using module ./SetupHashLink.psd1

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
if (-not $IsWindows) { Write-Warning "This action does not support Linux and macOS platforms." }

$release = $Env:SETUP_HASHLINK_VERSION ? $Env:SETUP_HASHLINK_VERSION : "Latest" | Find-HashLinkRelease
if (-not $release) { Write-Error "No release matches the specified version constraint."; exit 1 }

$path = $release | Install-HashLinkRelease
"HashLink $($release.Version) successfully installed in ""$path""."
