#!/usr/bin/env pwsh
using module ./SetupHashLink.psd1

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$release = Find-HashLinkRelease ($Env:SETUP_HASHLINK_VERSION ? $Env:SETUP_HASHLINK_VERSION : "Latest")
if (-not $release) { throw "No release matches the specified version constraint." }

$path = Install-HashLinkRelease -InputObject $release
"HashLink $($release.Version) successfully installed in ""$path""."
