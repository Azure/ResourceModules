
<#
.SYNOPSIS
This function helps with testing a module locally

.DESCRIPTION
This function helps with testing a module locally. Use this function To perform Pester testing for a module and then attempting to deploy it. It also allows you to use your own
subscription Id, principal Id, tenant ID and other parameters that need to be tokenized.

.PARAMETER templateFilePath
Mandatory. Path to the Bicep/ARM module that is being tested

.PARAMETER parameterFilePath
Optional. Path to the template file/folder that is to be tested with the template file. Mandatory if the DeploymentTest/ValidationTest switches are set.

.PARAMETER PesterTest
Optional. A switch parameter that triggers a Pester test for the module

.PARAMETER ValidateOrDeployParameters
Mandatory. An object consisting of the components that are required when using the Validate test or DeploymentTest switch parameter. See example:

.PARAMETER DeploymentTest
Optional. A switch parameter that triggers the deployment of the module

.PARAMETER ValidationTest
Optional. A switch parameter that triggers the validation of the module only without deployment

.PARAMETER SkipParameterFileTokens
Optional. A switch parameter that enables you to skip the search for local custom parameter file tokens.

.PARAMETER AdditionalTokens
Optional. A hashtable parameter that contains custom tokens to be replaced in the paramter files for deployment

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

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $templateFilePath,

        [Parameter(Mandatory = $false)]
        [string] $parameterFilePath = (Join-Path (Split-Path $templateFilePath -Parent) '.parameters'),

        [Parameter(Mandatory)]
        [Psobject] $ValidateOrDeployParameters,

        [Parameter(Mandatory = $false)]
        [hashtable] $AdditionalTokens = @{},

        [Parameter(Mandatory = $false)]
        [switch] $PesterTest,

        [Parameter(Mandatory = $false)]
        [switch] $DeploymentTest,

        [Parameter(Mandatory = $false)]
        [switch] $ValidationTest
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

        ################
        # PESTER Tests #
        ################
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

        #################################
        # Validation & Deployment tests #
        #################################
        if (($ValidationTest -or $DeploymentTest) -and $ValidateOrDeployParameters) {

            # Find Test Parameter Files
            # -------------------------
            if ((Get-Item -Path $parameterFilePath) -is [System.IO.DirectoryInfo]) {
                $ModuleParameterFiles = Get-ChildItem -Path $parameterFilePath
            } else {
                $ModuleParameterFiles = @($templateFilePath)
            }

            # Replace parameter file tokens
            # -----------------------------

            # Default Tokens
            $ConvertTokensInputs = @{
                ParameterFileTokens = @{
                    subscriptionId    = $ValidateOrDeployParameters.SubscriptionId
                    managementGroupId = $ValidateOrDeployParameters.ManagementGroupId
                }
            }

            #Add Other Parameter File Tokens (For Testing)
            if ($AdditionalTokens) {
                $ConvertTokensInputs.ParameterFileTokens += $AdditionalTokens
            }

            # Tokens in settings.json
            $settingsFilePath = Join-Path $PSScriptRoot '../..' 'settings.json'
            if (Test-Path $settingsFilePath) {
                $Settings = Get-Content -Path $settingsFilePath -Raw | ConvertFrom-Json
                $ConvertTokensInputs += @{
                    TokenPrefix = $Settings.parameterFileTokens.tokenPrefix
                    TokenSuffix = $Settings.parameterFileTokens.tokenSuffix
                }

                if ($settings.localTokens) {
                    $ConvertTokensInputs.ParameterFileTokens += $settings.localTokens
                }
            }

            # Invoke Token Replacement Functionality and Convert Tokens in Parameter Files
            $ModuleParameterFiles | ForEach-Object { $null = Convert-TokensInParameterFile @ConvertTokensInputs -ParameterFilePath $_.FullName }

            # Deployment & Validation Testing
            # -------------------------------
            $functionInput = @{
                templateFilePath  = $templateFilePath
                location          = "$($ValidateOrDeployParameters.Location)"
                resourceGroupName = "$($ValidateOrDeployParameters.ResourceGroupName)"
                subscriptionId    = "$($ValidateOrDeployParameters.SubscriptionId)"
                managementGroupId = "$($ValidateOrDeployParameters.ManagementGroupId)"
                Verbose           = $true
            }
            try {
                # Validate template
                # -----------------
                if ($ValidationTest) {
                    # Loop through test parameter files
                    foreach ($paramFilePath in $moduleParameterFiles) {
                        Write-Verbose 'Validating module [{0}] with parameter file [{1}]' -f $ModuleName, (Split-Path $paramFilePath -Leaf)
                        Test-TemplateWithParameterFile @functionInput -TemplateParameterFile $parameterFilePath
                    }
                }


                # Deploy template
                # ---------------
                if ($DeploymentTest) {
                    $functionInput['retryLimit'] = 1 # Overwrite default of 3
                    # Loop through test parameter files
                    foreach ($paramFilePath in $moduleParameterFiles) {
                        Write-Verbose 'Deploy module [{0}] with parameter file [{1}]' -f $ModuleName, (Split-Path $paramFilePath -Leaf)
                        if ($PSCmdlet.ShouldProcess(('Module [{0}] with parameter file [{1}]' -f $ModuleName, (Split-Path $paramFilePath -Leaf)), 'Deploy')) {
                            New-ModuleDeployment @functionInput -TemplateParameterFile $parameterFilePath
                        }
                    }
                }
            } catch {
                Write-Error $PSItem.Exception
                # Replace Values with Tokens For Repo Updates and Set Restore Flag to True to Prevent Running Restore Twice
                # $RestoreAlreadyTriggered = $true
                # Write-Verbose 'Restoring Tokens'
                # $ModuleParameterFiles | ForEach-Object { $null = Convert-TokensInParameterFile @ConvertTokensInputs -ParameterFilePath $PSItem.FullName -SwapValueWithName $true }
            } finally {

                # Restore parameter files
                # -----------------------
                if (($ValidationTest -or $DeploymentTest) -and $ValidateOrDeployParameters -and !($RestoreAlreadyTriggered)) {
                    # Replace Values with Tokens For Repo Updates
                    Write-Verbose 'Restoring Tokens'
                    $ModuleParameterFiles | ForEach-Object { $null = Convert-TokensInParameterFile @ConvertTokensInputs -ParameterFilePath $PSItem.FullName -SwapValueWithName $true }
                }
            }
        }
    }
    end {
    }
}
