
<#
.SYNOPSIS
This function helps with testing a module locally

.DESCRIPTION
This function helps with testing a module locally. Use this function To perform Pester testing for a module and then attempting to deploy it. It also allows you to use your own
subscription Id, principal Id, tenant ID and other parameters that need to be tokenized.

.PARAMETER TemplateFilePath
Mandatory. Path to the Bicep/ARM module that is being tested

.PARAMETER ParameterFilePath
Optional. Path to the template file/folder that is to be tested with the template file. Defaults to the module's default '.parameter' folder. Will be used if the DeploymentTest/ValidationTest switches are set.

.PARAMETER PesterTest
Optional. A switch parameter that triggers a Pester test for the module

.PARAMETER ValidateOrDeployParameters
Optional. An object consisting of the components that are required when using the Validate test or DeploymentTest switch parameter.  Mandatory if the DeploymentTest/ValidationTest switches are set.

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
    TemplateFilePath           = 'C:\Microsoft.Network\routeTables\deploy.bicep'
    ParameterFilePath          = 'C:\Microsoft.Network\routeTables\.parameters\parameters.json'
    PesterTest                 = $false
    DeploymentTest             = $false
    ValidationTest             = $true
    ValidateOrDeployParameters = @{
        Location          = 'westeurope'
        ResourceGroupName = 'validation-rg'
        SubscriptionId    = '00000000-0000-0000-0000-000000000000'
        ManagementGroupId = '00000000-0000-0000-0000-000000000000'
        RemoveDeployment  = $false
    }
    AdditionalTokens           = @{
        deploymentSpId = '00000000-0000-0000-0000-000000000000'
    }
}
Test-ModuleLocally @TestModuleLocallyInput -Verbose

Run a Test-Az*Deployment using a specific parameter-template combination with the provided tokens

.EXAMPLE

$TestModuleLocallyInput = @{
    TemplateFilePath           = 'C:\Microsoft.Network\routeTables\deploy.bicep'
    PesterTest                 = $true
    DeploymentTest             = $false
    ValidationTest             = $true
    ValidateOrDeployParameters = @{
        Location          = 'westeurope'
        ResourceGroupName = 'validation-rg'
        SubscriptionId    = '00000000-0000-0000-0000-000000000000'
        ManagementGroupId = '00000000-0000-0000-0000-000000000000'
        RemoveDeployment  = $false
    }
    AdditionalTokens           = @{
        deploymentSpId = '00000000-0000-0000-0000-000000000000'
    }
}
Test-ModuleLocally @TestModuleLocallyInput -Verbose

Run all Pesters test for a given template and a Test-Az*Deployment using each parameter file in the module's parameter folder in combination with the template and the provided tokens

.EXAMPLE

$TestModuleLocallyInput = @{
    TemplateFilePath           = 'C:\Microsoft.Network\routeTables\deploy.bicep'
    PesterTest                 = $true
}
Test-ModuleLocally @TestModuleLocallyInput -Verbose

Run all Pester tests for the given template file

.NOTES
- Make sure you provide the right information in the 'ValidateOrDeployParameters' parameter for this function to work.
- Ensure you have the ability to perform the deployment operations using your account (if planning to test deploy)
#>
function Test-ModuleLocally {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [string] $parameterFilePath = (Join-Path (Split-Path $TemplateFilePath -Parent) '.parameters'),

        [Parameter(Mandatory = $false)]
        [Psobject] $ValidateOrDeployParameters = @{},

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
        $ModuleName = Split-Path (Split-Path $TemplateFilePath -Parent) -Leaf
        Write-Verbose "Running Local Tests for $($ModuleName)"
        # Load Tokens Converter Scripts
        . (Join-Path $PSScriptRoot '../pipelines/tokensReplacement/Convert-TokensInFile.ps1')
        # Load Modules Validation / Deployment Scripts
        . (Join-Path $PSScriptRoot '../pipelines/resourceDeployment/New-ModuleDeployment.ps1')
        . (Join-Path $PSScriptRoot '../pipelines/resourceDeployment/Test-TemplateWithParameterFile.ps1')
    }
    process {

        ################
        # PESTER Tests #
        ################
        if ($PesterTest) {
            Write-Verbose "Pester Testing Module: $ModuleName"
            try {
                Invoke-Pester -Configuration @{
                    Run    = @{
                        Container = New-PesterContainer -Path (Join-Path (Get-Item $PSScriptRoot).Parent.Parent 'arm/.global/global.module.tests.ps1') -Data @{
                            moduleFolderPaths = Split-Path $TemplateFilePath -Parent
                        }
                    }
                    Output = @{
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
                $ModuleParameterFiles = (Get-ChildItem -Path $parameterFilePath).FullName
            } else {
                $ModuleParameterFiles = @($parameterFilePath)
            }

            # Replace parameter file tokens
            # -----------------------------

            # Default Tokens
            $ConvertTokensInputs = @{
                Tokens = @{
                    subscriptionId    = $ValidateOrDeployParameters.SubscriptionId
                    managementGroupId = $ValidateOrDeployParameters.ManagementGroupId
                }
            }

            #Add Other Parameter File Tokens (For Testing)
            if ($AdditionalTokens) {
                $ConvertTokensInputs.Tokens += $AdditionalTokens
            }

            # Tokens in settings.json
            $settingsFilePath = Join-Path (Get-Item $PSScriptRoot).Parent.Parent 'settings.json'
            if (Test-Path $settingsFilePath) {
                $Settings = Get-Content -Path $settingsFilePath -Raw | ConvertFrom-Json -AsHashtable
                $ConvertTokensInputs += @{
                    TokenPrefix = $Settings.parameterFileTokens.tokenPrefix
                    TokenSuffix = $Settings.parameterFileTokens.tokenSuffix
                }

                if ($Settings.parameterFileTokens.localTokens) {
                    $tokenMap = @{}
                    foreach ($token in $Settings.parameterFileTokens.localTokens) {
                        $tokenMap += @{ $token.name = $token.value }
                    }
                    Write-Verbose ('Using local tokens [{0}]' -f ($tokenMap.Keys -join ', ')) -Verbose
                    $ConvertTokensInputs.Tokens += $tokenMap
                }
            }

            # Invoke Token Replacement Functionality and Convert Tokens in Parameter Files
            $ModuleParameterFiles | ForEach-Object { $null = Convert-TokensInFile @ConvertTokensInputs -FilePath $_ }

            # Deployment & Validation Testing
            # -------------------------------
            $functionInput = @{
                TemplateFilePath  = $TemplateFilePath
                location          = $ValidateOrDeployParameters.Location
                resourceGroupName = $ValidateOrDeployParameters.ResourceGroupName
                subscriptionId    = $ValidateOrDeployParameters.SubscriptionId
                managementGroupId = $ValidateOrDeployParameters.ManagementGroupId
                Verbose           = $true
            }
            try {
                # Validate template
                # -----------------
                if ($ValidationTest) {
                    # Loop through test parameter files
                    foreach ($paramFilePath in $moduleParameterFiles) {
                        Write-Verbose ('Validating module [{0}] with parameter file [{1}]' -f $ModuleName, (Split-Path $paramFilePath -Leaf)) -Verbose
                        Test-TemplateWithParameterFile @functionInput -ParameterFilePath $paramFilePath
                    }
                }


                # Deploy template
                # ---------------
                if ($DeploymentTest) {
                    $functionInput['retryLimit'] = 1 # Overwrite default of 3
                    # Loop through test parameter files
                    foreach ($paramFilePath in $moduleParameterFiles) {
                        Write-Verbose ('Deploy module [{0}] with parameter file [{1}]' -f $ModuleName, (Split-Path $paramFilePath -Leaf)) -Verbose
                        if ($PSCmdlet.ShouldProcess(('Module [{0}] with parameter file [{1}]' -f $ModuleName, (Split-Path $paramFilePath -Leaf)), 'Deploy')) {
                            New-ModuleDeployment @functionInput -ParameterFilePath $paramFilePath
                        }
                    }
                }
            } catch {
                Write-Error $_
            } finally {
                # Restore parameter files
                # -----------------------
                if (($ValidationTest -or $DeploymentTest) -and $ValidateOrDeployParameters -and -not $RestoreAlreadyTriggered) {
                    # Replace Values with Tokens For Repo Updates
                    Write-Verbose 'Restoring Tokens'
                    $ModuleParameterFiles | ForEach-Object { $null = Convert-TokensInFile @ConvertTokensInputs -FilePath $_ -SwapValueWithName $true }
                }
            }
        }
    }
    end {
    }
}
