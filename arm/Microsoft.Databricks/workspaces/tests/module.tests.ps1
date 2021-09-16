<#
	.NOTES
		==============================================================================================
		Copyright(c) Microsoft Corporation. All rights reserved.

		File:		module.tests.ps1

		Purpose:	Pester - Test ARM Templates

		Version: 	2.0.2 - 16th September 2021 - Microsoft Services
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

#Requires -Version 7

param (
    [Parameter()][string] $ParameterFolderPath = 'parameters',
    [Parameter()][string] $Script:TemplateFileName = 'deploy.json'
)

#region Collect parameter files for TestCases 
$templateFileParameters = (Get-Content (Join-Path -Path $($(Get-Item $PSScriptRoot).Parent.FullName) -ChildPath $TemplateFileName) | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties 
$TemplateFile_AllParameterNames = $templateFileParameters | Sort-Object -Property Name | ForEach-Object Name
$TemplateFile_RequiredParametersNames = $templateFileParameters | Where-Object -FilterScript { -not ($_.Value.PSObject.Properties.Name -eq "defaultValue") } | Sort-Object -Property Name | ForEach-Object Name

$ParameterTestCases = @()
$ParameterFilePaths = (Get-ChildItem (Join-Path -Path $($(Get-Item $PSScriptRoot).Parent.FullName) -ChildPath $ParameterFolderPath -AdditionalChildPath "*parameters.json") -Recurse).FullName
forEach ($ParameterFilePath in $ParameterFilePaths) {
    $parameterFile_AllParameterNames = (Get-Content $ParameterFilePath | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters.PSObject.Properties | Sort-Object -Property Name | ForEach-Object Name
    $ParameterTestCases += @{ 
        TemplateFileName                     = $TemplateFileName
        parameterFile_Path                   = $ParameterFilePath
        parameterFile_Name                   = Split-Path $ParameterFilePath -Leaf
        parameterFile_AllParameterNames      = $parameterFile_AllParameterNames
        templateFile_AllParameterNames       = $TemplateFile_AllParameterNames
        templateFile_RequiredParametersNames = $TemplateFile_RequiredParametersNames
    }
}
#endregion

#region Tests
Describe "Template: $(Split-Path $($(Get-Item $PSScriptRoot).Parent.FullName) -Leaf)" -Tags Unit {

    Context "Template File Syntax" {

        It "JSON template file ($TemplateFileName) exists" {
            $expectedTemplatePath = Join-Path -Path $($(Get-Item $PSScriptRoot).Parent.FullName) -ChildPath $TemplateFileName 
            $expectedTemplatePath | Should -Exist
        }

        It "Template file ($TemplateFileName) converts from JSON and has all expected properties" {
            $ExpectedProperties = @('$schema', 'contentVersion', 'parameters', 'variables', 'resources', 'functions', 'outputs') | Sort-Object
            $TemplateProperties = ((Get-Content (Join-Path -Path $($(Get-Item $PSScriptRoot).Parent.FullName) -ChildPath $TemplateFileName) | ConvertFrom-Json) | Get-Member -MemberType NoteProperty).Name | Sort-Object
            $TemplateProperties | Should -Be $ExpectedProperties
        }
    }

    Context "Parameter File Syntax" {

        It "Parameter file (<parameterFile_Name>)  does contain all expected properties" -TestCases $ParameterTestCases {
            param (
                [string] $ParameterFile_Path
            )
            $ExpectedProperties = @('$schema', 'contentVersion', 'parameters') | Sort-Object
            $TemplateProperties = ((Get-Content $ParameterFile_Path | ConvertFrom-Json) | Get-Member -MemberType NoteProperty).Name | Sort-Object
            $TemplateProperties | Should -Be $ExpectedProperties
        }
    }

    Context "Template and Parameter Compatibility" {

        It "Count of required parameters in template file ($TemplateFileName) is equal or less than count of all parameters in parameters file (<parameterFile_Name>)" -TestCases $ParameterTestCases {
            param (
                [string[]] $parameterFile_AllParameterNames,
                [string[]] $templateFile_RequiredParametersNames
            )
            $templateFile_RequiredParametersNames.Count | Should -Not -BeGreaterThan $parameterFile_AllParameterNames.Count
        }

        It "All parameters in parameters file (<parameterFile_Name>) exist in template file ($TemplateFileName)" -TestCases $ParameterTestCases {
            param (
                [string[]] $templateFile_AllParameterNames,
                [string[]] $parameterFile_AllParameterNames
            )
            $nonExistentParameters = $parameterFile_AllParameterNames | Where-Object { $templateFile_AllParameterNames -notcontains $_ }
            $nonExistentParameters.Count | Should -Be 0 -Because ("all parameters in the parameter file should exist in the template file. Found excess items: [{0}]" -f ($nonExistentParameters -join ', '))
        }

        It "All required parameters in template file ($TemplateFileName) existing in parameters file (<parameterFile_Name>)" -TestCases $ParameterTestCases {
            param (
                [string[]] $TemplateFile_RequiredParametersNames,
                [string[]] $parameterFile_AllParameterNames
            )
            $missingParameters = $templateFile_RequiredParametersNames | Where-Object { $parameterFile_AllParameterNames -notcontains $_ }
            $missingParameters.Count | Should -Be 0 -Because ("all required parameters in the template file should exist in the parameter file. Found missing items: [{0}]" -f ($missingParameters -join ', '))
        }
    }
}
#endregion
