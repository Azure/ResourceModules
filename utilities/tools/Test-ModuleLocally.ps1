
<#
.SYNOPSIS
This Function Helps with Testing A Module Locally

.DESCRIPTION
This Function Helps with Testing A Module Locally. Use this Function To perform Pester Testing for a Module and then attempting to deploy it. It Also allows you to use your own
subscription Id, Principal Id, tenant ID and other parameters that need to be tokenized.

.PARAMETER templateFilePath
Mandatory. Path to the Bicep/ARM module that is being tested

.PARAMETER PesterTest
Optional. A Switch Parameter that triggers a Pester Test for the Module

.PARAMETER ValidateOrDeployParameters
An Object consisting of the components that are required when using the Validate Test or DeploymentTest Switch parameter. See example:

.PARAMETER DeploymentTest
Optional. A Switch Parameter that triggers the Deployment of the Module

.PARAMETER ValidationTest
Optional. A Switch Parameter that triggers the Validation of the Module Only without Deployment

.PARAMETER DeployAllModuleParameterFiles
Optional. A Boolean Parameter that enables directory based search for parameter files and deploys all of them. If not true, it will only deploy the 'parameters.json' file. Default is false.

.PARAMETER SkipParameterFileTokens
Optional. A Switch Parameter that enables you to skip the search for local custom parameter file tokens.

.PARAMETER AdditionalTokens
Optional. A Hashtable Parameter that contains custom tokens to be replaced in the paramter files for deployment

.EXAMPLE

$TestModuleLocallyInput = @{
    templateFilePath              = 'Microsoft.Network\applicationSecurityGroups'
    PesterTest                    = $true
    DeploymentTest                = $true
    ValidationTest                = $false
    ValidateOrDeployParameters    = @{
        Location          = 'australiaeast'
        ResourceGroupName = 'validation-rg'
        SubscriptionId    = '12345678-1234-1234-1234-123456789123'
        ManagementGroupId = 'mg-contoso'
    }
    AdditionalTokens      = @(
        @{ Name = 'deploymentSpId'; Value = '12345678-1234-1234-1234-123456789123' }
        @{ Name = 'tenantId'; Value = '12345678-1234-1234-1234-123456789123' }
    )
}

Test-ModuleLocally @TestModuleLocallyInput -Verbose

.EXAMPLE

$TestModuleLocallyInput = @{
    templateFilePath                    = 'Microsoft.Network\applicationSecurityGroups'
    PesterTest                    = $true
    DeploymentTest                = $true
    ValidationTest                = $false
    ValidateOrDeployParameters    = @{
        Location          = 'australiaeast'
        ResourceGroupName = 'validation-rg'
        SubscriptionId    = '12345678-1234-1234-1234-123456789123'
        ManagementGroupId = 'mg-contoso'
    }
    DeployAllModuleParameterFiles = $true
    GetParameterFileTokens        = $true
    AdditionalTokens      = @(
        @{ Name = 'deploymentSpId'; Value = '12345678-1234-1234-1234-123456789123' }
        @{ Name = 'tenantId'; Value = '12345678-1234-1234-1234-123456789123' }
    )
}

Test-ModuleLocally @TestModuleLocallyInput -Verbose

.NOTES
- Make sure you provide the right information in the 'ValidateOrDeployParameters' parameter for this function to work.
- Ensure you have the ability to perform the deployment operations using your account

#>
function Test-ModuleLocally {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]$templateFilePath,

        [parameter(Mandatory = $false)]
        [switch]$PesterTest,

        [parameter(Mandatory)]
        [psobject]$ValidateOrDeployParameters,

        [parameter(Mandatory = $false)]
        [switch]$DeploymentTest,

        [parameter(Mandatory = $false)]
        [switch]$ValidationTest,

        [parameter(Mandatory = $false)]
        [bool]$DeployAllModuleParameterFiles = $false,

        [parameter(Mandatory = $false)]
        [switch]$SkipParameterFileTokens,

        [parameter(Mandatory = $false)]
        [psobject]$AdditionalTokens
    )

    begin {
        $ModuleName = Split-Path (Split-Path $templateFilePath -Parent) -Leaf
        Write-Verbose "Running Local Tests for $($ModuleName)"
        # Load Tokens Converter Scripts
        . (Join-Path $PSScriptRoot '../pipelines/tokensReplacement/Convert-TokensInParameterFile.ps1')
        # Load Modules Validation / Deployment Scripts
        . (Join-Path $PSScriptRoot '../pipelines/resourceDeployment/New-ModuleDeployment.ps1')
        . (Join-Path $PSScriptRoot '../pipelines/resourceValidation/Test-TemplateWithParameterFile.ps1')
    }
    process {
        # Test Module
        if ($PesterTest) {
            Write-Verbose "Pester Testing Module: $ModuleName"
            try {
                Invoke-Pester -Configuration @{
                    Run        = @{
                        Container = New-PesterContainer -Path (Join-Path $PSScriptRoot '../..' 'arm/.global/global.module.tests.ps1') -Data @{
                            moduleFolderPaths = Split-Path $templateFilePath -Parent
                        }
                    }
                    Filter     = @{
                        #ExcludeTag = 'ApiCheck'
                        #Tag = 'ApiCheck'
                    }
                    TestResult = @{
                        TestSuiteName = 'Global Module Tests'
                        Enabled       = $false
                    }
                    Output     = @{
                        Verbosity = 'Detailed'
                    }
                }
            } catch {
                $PSItem.Exception.Message
            }
        }
        # Deploy Module
        if (($ValidationTest -or $DeploymentTest) -and $ValidateOrDeployParameters) {
            # Find Test Parameter Files
            $ModuleParameterFiles = Get-ChildItem -Path (Join-Path (Split-Path $templateFilePath -Parent) '.parameters') -Recurse
            # Replace Tokens with Values For Local Testing
            $DefaultParameterFileTokens = @(
                @{ Name = 'subscriptionId'; Value = "$($ValidateOrDeployParameters.SubscriptionId)" }
                @{ Name = 'managementGroupId'; Value = "$($ValidateOrDeployParameters.ManagementGroupId)" }
            ) | ForEach-Object { [PSCustomObject]$PSItem }

            # Look for Local Custom Parameter File Tokens (Source Control)
            if (-not $SkipParameterFileTokens) {
                # Get Settings JSON File
                $Settings = Get-Content -Path (Join-Path $PSScriptRoot '../..' 'settings.json') | ConvertFrom-Json
                # Get Custom Parameter File Tokens (Local)
                $ConvertTokensInputs = @{
                    DefaultParameterFileTokens     = $DefaultParameterFileTokens
                    LocalCustomParameterFileTokens = $Settings.parameterFileTokens.localTokens.tokens
                    TokenPrefix                    = $Settings.parameterFileTokens.tokenPrefix
                    TokenSuffix                    = $Settings.parameterFileTokens.tokenSuffix
                }
                #Add Other Parameter File Tokens (For Testing)
                if ($AdditionalTokens) {
                    $ConvertTokensInputs += @{ OtherCustomParameterFileTokens = $AdditionalTokens
                    }
                }
            }
            # Invoke Token Replacement Functionality and Convert Tokens in Parameter Files
            $ModuleParameterFiles | ForEach-Object { $null = Convert-TokensInParameterFile @ConvertTokensInputs -ParameterFilePath $PSItem.FullName }
            # Build Modules Validation and Deployment Inputs
            $functionInput = @{
                templateFilePath  = $templateFilePath
                parameterFilePath = (Join-Path (Split-Path $templateFilePath -Parent) '.parameters/parameters.json')
                location          = "$($ValidateOrDeployParameters.Location)"
                resourceGroupName = "$($ValidateOrDeployParameters.ResourceGroupName)"
                subscriptionId    = "$($ValidateOrDeployParameters.SubscriptionId)"
                managementGroupId = "$($ValidateOrDeployParameters.ManagementGroupId)"
            }
            try {
                # Validate Template
                if ($ValidationTest) {
                    Write-Verbose "Validating Module: $ModuleName"
                    # Invoke Validation
                    Test-TemplateWithParameterFile @functionInput -Verbose
                }
                # Deploy Template
                if ($DeploymentTest) {
                    Write-Verbose "Deploying Module: $ModuleName"
                    # Set the ParameterFilePath to Directory instead of the default 'parameters.json'
                    if ($DeployAllModuleParameterFiles) {
                        $functionInput.parameterFilePath = (Join-Path (Split-Path $templateFilePath -Parent) $ModuleName '.parameters')
                    }
                    # Append to Function Input the required parameters for Deployment
                    $functionInput += @{
                        retryLimit = 1
                    }
                    # Invoke Deployment
                    New-ModuleDeployment @functionInput -Verbose
                }
            } catch {
                Write-Error $PSItem.Exception
                # Replace Values with Tokens For Repo Updates and Set Restore Flag to True to Prevent Running Restore Twice
                $RestoreAlreadyTriggered = $true
                Write-Verbose 'Restoring Tokens'
                $ModuleParameterFiles | ForEach-Object { $null = Convert-TokensInParameterFile @ConvertTokensInputs -ParameterFilePath $PSItem.FullName -SwapValueWithName $true }
            }
        }
    }
    end {
        # Restore Parameter Files
        if (($ValidationTest -or $DeploymentTest) -and $ValidateOrDeployParameters -and !($RestoreAlreadyTriggered)) {
            # Replace Values with Tokens For Repo Updates
            Write-Verbose 'Restoring Tokens'
            $ModuleParameterFiles | ForEach-Object { $null = Convert-TokensInParameterFile @ConvertTokensInputs -ParameterFilePath $PSItem.FullName -SwapValueWithName $true }
        }
    }
}
