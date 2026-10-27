#!/usr/bin/env pwsh
param (
	# The name of the cmdlet to run.
	[Parameter(Mandatory, Position = 1)]
	[ArgumentCompleter({
		param ([string] $commandName, [string] $parameterName, [string] $wordToComplete)
		$module = Import-PowerShellDataFile "$PSScriptRoot/SetupHashLink.psd1"
		$cmdlets = $module.CmdletsToExport + $module.FunctionsToExport
		$cmdlets -like "$wordToComplete*" -replace "^([^-]+)-", "`$1-$($module.DefaultCommandPrefix)"
	})]
	[ValidateScript({
		$module = Import-PowerShellDataFile "$PSScriptRoot/SetupHashLink.psd1"
		$cmdlets = $module.CmdletsToExport + $module.FunctionsToExport
		$cmdlets -contains ($_ -replace "^([^-]+)-$($module.DefaultCommandPrefix)", "`$1-")
	}, ErrorMessage = "The specified script does not exist.")]
	[string] $Command,

	# The parameters of the cmdlet to run.
	[Parameter(Position = 2, ValueFromRemainingArguments)]
	[string[]] $Parameters = @()
)

$scriptBlock = {
	param ([string] $scriptRoot, [string] $command, [string[]] $parameters)
	$ErrorActionPreference = "Stop"
	$PSNativeCommandUseErrorActionPreference = $true

	Import-Module "$scriptRoot/SetupHashLink.psd1"
	$argumentList = $parameters | ForEach-Object { $_ -like "* *" ? "'$_'" : $_ }
	Invoke-Expression "$command $($argumentList -join " ")"
}

pwsh -Command $scriptBlock -args $PSScriptRoot, $Command, $Parameters
