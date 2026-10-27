#!/usr/bin/env pwsh
param (
	# The script to invoke.
	[Parameter(Position = 1)]
	[ArgumentCompleter({
		param ([string] $commandName, [string] $parameterName, [string] $wordToComplete)
		(Get-Item "$PSScriptRoot/Scripts/$wordToComplete*.ps1").BaseName
	})]
	[ValidateScript(
		{ Test-Path "$PSScriptRoot/Scripts/$_.ps1" -PathType Leaf },
		ErrorMessage = "The specified script does not exist."
	)]
	[string] $Script = "Default",

	# Value indicating whether to enable the release configuration.
	[switch] $Release
)

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"
$PSNativeCommandUseErrorActionPreference = $true
& "$PSScriptRoot/Scripts/$Script.ps1"
