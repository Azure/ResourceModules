<#
	.NOTES
		==============================================================================================
		Copyright(c) Microsoft Corporation. All rights reserved.

		File:		module.tests.ps1

		Purpose:	Pester - Test ARM Templates

		Version: 	2.0.1 - 15th June 2020 - Microsoft Services
		==============================================================================================

	.SYNOPSIS
		This script contains functionality used to test ARM template synatax.

	.DESCRIPTION
		This script contains functionality used to test ARM template synatax.

		Deployment steps of the script are outlined below.
		1) Test Template File Syntax
		2) Test Parameter File Syntax
		3) Test Template and Parameter File Compatibility
#>

#region Parameters

#Requires -Version 7

param (
    [Parameter()][string]$script:ParameterFilePath = 'parameters',
    [Parameter()][string]$script:TemplateFileName = 'deploy.json'
)

#endregion 

#region Collect parameter files for TestCases 

$Parameters = @()
$ParameterFiles = (Get-ChildItem (Join-Path -Path $($(Get-Item $PSScriptRoot).Parent.FullName) -ChildPath $ParameterFilePath -AdditionalChildPath "*parameters.json") -Recurse).FullName
ForEach ($ParameterFile in $ParameterFiles) {
    $Parameters += @{ 
        ParameterFilePath = $ParameterFile
    }
}

#endregion

#region Tests

Describe "Template: $(Split-Path $($(Get-Item $PSScriptRoot).Parent.FullName) -Leaf)" -Tags Unit {

    Context "Template File Syntax" {

        It "JSON template file ($TemplateFileName) exists" {
            if (-not (Get-ChildItem $($(Get-Item $PSScriptRoot).Parent.FullName) $TemplateFileName)) {
                Write-Host "   [-] Template file ($TemplateFileName) does not exist."
                exit
            }
			(Join-Path -Path $($(Get-Item $PSScriptRoot).Parent.FullName) -ChildPath $TemplateFileName) | Should -Exist
        }

        It "Template file ($TemplateFileName) converts from JSON and has all expected properties" {
            $ExpectedProperties = '$schema',
            'contentVersion',
            'parameters',
            'variables',
            'resources',
            'functions',
            'outputs' | Sort-Object
            $TemplateProperties = (Get-Content (Join-Path -Path $($(Get-Item $PSScriptRoot).Parent.FullName) -ChildPath $TemplateFileName) `
                | ConvertFrom-Json -ErrorAction SilentlyContinue) `
            | Get-Member -MemberType NoteProperty `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            $TemplateProperties | Should -Be $ExpectedProperties
        }
    }

    Context "Parameter File Syntax" {

        It "Parameter file (<ParameterFilePath>)  does contain all expected properties" -TestCases $Parameters {
            Param ($ParameterFilePath)

            $ExpectedProperties = '$schema',
            'contentVersion',
            'parameters' | Sort-Object
            $templateFileProperties = (Get-Content $ParameterFilePath `
                | ConvertFrom-Json -ErrorAction SilentlyContinue) `
            | Get-Member -MemberType NoteProperty `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            $templateFileProperties | Should -Be $ExpectedProperties
        }
    }

    Context "Template and Parameter Compatibility" {

        It "Count of required parameters in template file ($TemplateFileName) is equal or less than count of all parameters in parameters file (<ParameterFilePath>)" -TestCases $Parameters {
            Param ($ParameterFilePath)

            $requiredParametersInTemplateFile = (Get-Content (Join-Path -Path $($(Get-Item $PSScriptRoot).Parent.FullName) -ChildPath $TemplateFileName) `
                | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties `
            | Where-Object -FilterScript { -not ($_.Value.PSObject.Properties.Name -eq "defaultValue") } `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            $allParametersInParametersFile = (Get-Content $ParameterFilePath `
                | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            if ($requiredParametersInTemplateFile.Count -gt $allParametersInParametersFile.Count) {
                Write-Host "   [-] Required parameters are: $requiredParametersInTemplateFile"
                $requiredParametersInTemplateFile.Count | Should -Not -BeGreaterThan $allParametersInParametersFile.Count
            }
        }

        It "All parameters in parameters file (<ParameterFilePath>) exist in template file ($TemplateFileName)" -TestCases $Parameters {
            Param ($ParameterFilePath)

            $allParametersInTemplateFile = (Get-Content (Join-Path -Path $($(Get-Item $PSScriptRoot).Parent.FullName) -ChildPath $TemplateFileName) `
                | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            $allParametersInParametersFile = (Get-Content $ParameterFilePath `
                | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            $result = @($allParametersInParametersFile | Where-Object { $allParametersInTemplateFile -notcontains $_ })
            if ($result) { 
                Write-Host "   [-] Following parameter does not exist: $result"
            }
            @($allParametersInParametersFile | Where-Object { $allParametersInTemplateFile -notcontains $_ }).Count | Should -Be 0
        }

        It "All required parameters in template file ($TemplateFileName) existing in parameters file (<ParameterFilePath>)" -TestCases $Parameters {
            Param ($ParameterFilePath)

            $requiredParametersInTemplateFile = (Get-Content (Join-Path -Path $($(Get-Item $PSScriptRoot).Parent.FullName) -ChildPath $TemplateFileName) `
                | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties `
            | Where-Object -FilterScript { -not ($_.Value.PSObject.Properties.Name -eq "defaultValue") } `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            $allParametersInParametersFile = (Get-Content $ParameterFilePath `
                | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties `
            | Sort-Object -Property Name `
            | ForEach-Object Name
            $result = $requiredParametersInTemplateFile | Where-Object { $allParametersInParametersFile -notcontains $_ }
            if ($result.Count -gt 0) {
                Write-Host "   [-] Required parameters: $result"
            }
            @($requiredParametersInTemplateFile | Where-Object { $allParametersInParametersFile -notcontains $_ }).Count | Should -Be 0
        }
    }
}

#endregion