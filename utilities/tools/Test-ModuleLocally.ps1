
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
    ParameterFilePath          = 'C:\Microsoft.Network\routeTables\.test\parameters.json'
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

Run all Pester tests for a given template and a Test-Az*Deployment using each test file in the module's default test folder ('.test') in combination with the template and the provided tokens

.EXAMPLE

$TestModuleLocallyInput = @{
    TemplateFilePath           = 'C:\Microsoft.Network\routeTables\deploy.bicep'
    PesterTest                 = $true
}
Test-ModuleLocally @TestModuleLocallyInput -Verbose

Run all Pester tests for the given template file

.EXAMPLE

$TestModuleLocallyInput = @{
    TemplateFilePath           = 'C:\Microsoft.Network\routeTables\deploy.bicep'
    PesterTest                 = $true
    ValidateOrDeployParameters = @{
        SubscriptionId    = '00000000-0000-0000-0000-000000000000'
        ManagementGroupId = '00000000-0000-0000-0000-000000000000'
    }
    AdditionalTokens           = @{
        deploymentSpId = '00000000-0000-0000-0000-000000000000'
    }
}
Test-ModuleLocally @TestModuleLocallyInput -Verbose

Run all Pester tests for the given template file including tests for the use of tokens

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
        [string] $testFilePath = (Join-Path (Split-Path $TemplateFilePath -Parent) '.test'),

        [Parameter(Mandatory = $false)]
        [string] $moduleTestFilePath = 'utilities/pipelines/staticValidation/module.tests.ps1',

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
        $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent
        $ModuleName = Split-Path (Split-Path $TemplateFilePath -Parent) -Leaf
        Write-Verbose "Running Local Tests for $($ModuleName)"
        # Load Tokens Converter Scripts
        . (Join-Path $PSScriptRoot '../pipelines/tokensReplacement/Convert-TokensInFileList.ps1')
        # Load Modules Validation / Deployment Scripts
        . (Join-Path $PSScriptRoot '../pipelines/resourceDeployment/New-TemplateDeployment.ps1')
        . (Join-Path $PSScriptRoot '../pipelines/resourceDeployment/Test-TemplateDeployment.ps1')
    }
    process {

        ################
        # PESTER Tests #
        ################
        if ($PesterTest) {
            Write-Verbose "Pester Testing Module: $ModuleName"
            try {
                $enforcedTokenList = @{}
                if ($ValidateOrDeployParameters.ContainsKey('subscriptionId')) {
                    $enforcedTokenList['subscriptionId'] = $ValidateOrDeployParameters.SubscriptionId
                }
                if ($ValidateOrDeployParameters.ContainsKey('managementGroupId')) {
                    $enforcedTokenList['managementGroupId'] = $ValidateOrDeployParameters.ManagementGroupId
                }
                if ($AdditionalTokens.ContainsKey('deploymentSpId')) {
                    $enforcedTokenList['deploymentSpId'] = $AdditionalTokens['deploymentSpId']
                }
                if ($AdditionalTokens.ContainsKey('tenantId')) {
                    $enforcedTokenList['tenantId'] = $AdditionalTokens['tenantId']
                }

                Invoke-Pester -Configuration @{
                    Run    = @{
                        Container = New-PesterContainer -Path (Join-Path $repoRootPath $moduleTestFilePath) -Data @{
                            repoRootPath      = $repoRootPath
                            moduleFolderPaths = Split-Path $TemplateFilePath -Parent
                            enforcedTokenList = $enforcedTokenList
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
            if ($TemplateFilePath -notlike '*.test*') {
                if ((Get-Item -Path $testFilePath) -is [System.IO.DirectoryInfo]) {
                    $moduleTestFiles = (Get-ChildItem -Path $testFilePath).FullName
                } else {
                    $moduleTestFiles = @($testFilePath)
                }
            }

            # Replace parameter file tokens
            # -----------------------------

            # Default Tokens
            $ConvertTokensInputs = @{
                FilePathList = $moduleTestFiles
                Tokens       = @{
                    subscriptionId    = $ValidateOrDeployParameters.SubscriptionId
                    managementGroupId = $ValidateOrDeployParameters.ManagementGroupId
                }
            }

            # Add Other Parameter File Tokens (For Testing)
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
            if ($moduleTestFiles) {
                $null = Convert-TokensInFileList @ConvertTokensInputs
            }

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

            if (-not $moduleTestFiles) {
                # Using new testing templates - adding special parameters
                if ((Split-Path $TemplateFilePath -Extension) -eq '.bicep') {
                    $testTemplatePossibleParameters = (az bicep build --file $TemplateFilePath --stdout --no-restore | ConvertFrom-Json -AsHashtable).parameters.Keys
                } else {
                    $testTemplatePossibleParameters = ((Get-Content $TemplateFilePath -Raw) | ConvertFrom-Json -AsHashtable).parameters.keys
                }

                if (Test-Path $settingsFilePath) {
                    if ($testTemplatePossibleParameters -contains 'namePrefix') {
                        $functionInput['additionalParameters'] += @{
                            namePrefix = ($Settings.parameterFileTokens.localTokens | Where-Object { $_.name -eq 'namePrefix' }).value
                        }
                    }
                }
            }

            try {
                # Validate template
                # -----------------
                if ($ValidationTest) {
                    # Loop through test parameter files
                    if ($moduleTestFiles) {
                        foreach ($moduleTestFile in $moduleTestFiles) {
                            Write-Verbose ('Validating module [{0}] with test file [{1}]' -f $ModuleName, (Split-Path $moduleTestFile -Leaf)) -Verbose
                            Test-TemplateDeployment @functionInput -ParameterFilePath $moduleTestFile
                        }
                    } else {
                        Test-TemplateDeployment @functionInput
                    }
                }


                # Deploy template
                # ---------------
                if ($DeploymentTest) {
                    $functionInput['retryLimit'] = 1 # Overwrite default of 3
                    # Loop through test parameter files
                    if ($moduleTestFiles) {

                        foreach ($moduleTestFile in $moduleTestFiles) {
                            Write-Verbose ('Deploy module [{0}] with test file [{1}]' -f $ModuleName, (Split-Path $moduleTestFile -Leaf)) -Verbose
                            if ($PSCmdlet.ShouldProcess(('Module [{0}] with test file [{1}]' -f $ModuleName, (Split-Path $moduleTestFile -Leaf)), 'Deploy')) {
                                New-TemplateDeployment @functionInput -ParameterFilePath $moduleTestFile
                            }
                        }
                    } else {
                        New-TemplateDeployment @functionInput
                    }
                }
            } catch {
                Write-Error $_
            } finally {
                # Restore parameter files
                # -----------------------
                if (($ValidationTest -or $DeploymentTest) -and $ValidateOrDeployParameters -and $moduleTestFiles) {
                    # Replace Values with Tokens For Repo Updates
                    Write-Verbose 'Restoring Tokens'
                    $ConvertTokensInputs += @{
                        SwapValueWithName = $true
                    }
                    $null = Convert-TokensInFileList @ConvertTokensInputs
                }
            }
        }
    }
    end {
    }
}
