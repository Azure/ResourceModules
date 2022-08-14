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
        [string] $ParameterFilePath = (Join-Path (Split-Path $TemplateFilePath -Parent) '.test'),

        [Parameter(Mandatory = $false)]
        [string] $PesterTestFilePath = 'utilities/pipelines/staticValidation/module.tests.ps1',

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
        Write-Verbose "Running local tests for [$ModuleName]"
        # Load Tokens Converter Scripts
        . (Join-Path $PSScriptRoot '../pipelines/tokensReplacement/Convert-TokensInFileList.ps1')
        # Load Modules Validation / Deployment Scripts
        . (Join-Path $PSScriptRoot '../pipelines/resourceDeployment/New-TemplateDeployment.ps1')
        . (Join-Path $PSScriptRoot '../pipelines/resourceDeployment/Test-TemplateDeployment.ps1')
    }
    process {

        # Find Test Parameter Files
        # -------------------------
        if ((Get-Item -Path $ParameterFilePath -Force) -is [System.IO.DirectoryInfo]) {
            $parameterFiles = (Get-ChildItem -Path $ParameterFilePath -File).FullName
        } else {
            $parameterFiles = @($ParameterFilePath)
        }

        # Construct Token Configuration Input
        $GlobalVariablesObject = Get-Content -Path (Join-Path $PSScriptRoot '..\..\settings.yml') | ConvertFrom-Yaml -ErrorAction Stop | Select-Object -ExpandProperty variables
        $tokenConfiguration = @{
            FilePathList = $parameterFiles
            Tokens       = @{}
            TokenPrefix  = $GlobalVariablesObject | Select-Object -ExpandProperty tokenPrefix
            TokenSuffix  = $GlobalVariablesObject | Select-Object -ExpandProperty tokenSuffix
        }

        # Add Enforced Tokens
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
        $tokenConfiguration.Tokens += $enforcedTokenList

        # Add local (source control) tokens
        foreach ($localToken in ($GlobalVariablesObject.Keys | ForEach-Object { if ($PSItem.contains('localToken_')) { $PSItem } })) {
            $tokenConfiguration.Tokens[$localToken.Replace('localToken_', '', 'OrdinalIgnoreCase')] = $GlobalVariablesObject.$localToken
        }

        # Add Other Parameter File Tokens (For Testing)
        $AdditionalTokens.Keys | ForEach-Object {
            if (-not $tokenConfiguration.Tokens.ContainsKey($PSItem)) {
                $tokenConfiguration.Tokens[$PSItem] = $AdditionalTokens.$PSItem
            }
        }

        ################
        # PESTER Tests #
        ################
        if ($PesterTest) {
            Write-Verbose "Pester Testing Module: $ModuleName"

            # Construct Pester Token Configuration Input
            $PesterTokenConfiguration = @{
                FilePathList = $parameterFiles
                Tokens       = $enforcedTokenList
                TokenPrefix  = $GlobalVariablesObject | Select-Object -ExpandProperty tokenPrefix
                TokenSuffix  = $GlobalVariablesObject | Select-Object -ExpandProperty tokenSuffix
            }

            try {
                Invoke-Pester -Configuration @{
                    Run    = @{
                        Container = New-PesterContainer -Path (Join-Path $repoRootPath $PesterTestFilePath) -Data @{
                            repoRootPath       = $repoRootPath
                            moduleFolderPaths  = Split-Path $TemplateFilePath -Parent
                            tokenConfiguration = $PesterTokenConfiguration
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

            # Invoke Token Replacement Functionality and Convert Tokens in Parameter Files
            $null = Convert-TokensInFileList @tokenConfiguration

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
                    if ($parameterFiles) {
                        # Loop through test parameter files
                        foreach ($parameterFile in $parameterFiles) {
                            Write-Verbose ('Validating module [{0}] with test file [{1}]' -f $ModuleName, (Split-Path $parameterFile -Leaf)) -Verbose
                            Test-TemplateDeployment @functionInput -ParameterFilePath $parameterFile
                        }
                    } else {
                        Write-Verbose ('Validating module [{0}]' -f $ModuleName) -Verbose
                        Test-TemplateDeployment @functionInput
                    }
                }

                # Deploy template
                # ---------------
                if ($DeploymentTest) {
                    $functionInput['retryLimit'] = 1 # Overwrite default of 3
                    # Loop through test parameter files
                    if ($parameterFiles) {
                        foreach ($parameterFile in $parameterFiles) {
                            Write-Verbose ('Deploy Module [{0}] with test file [{1}]' -f $ModuleName, (Split-Path $parameterFile -Leaf)) -Verbose
                            if ($PSCmdlet.ShouldProcess(('Module [{0}] with test file [{1}]' -f $ModuleName, (Split-Path $parameterFile -Leaf)), 'Deploy')) {
                                New-TemplateDeployment @functionInput -ParameterFilePath $parameterFile
                            }
                        }
                    } else {
                        Write-Verbose ('Deploy Module [{0}]' -f $ModuleName) -Verbose
                        if ($PSCmdlet.ShouldProcess(('Module [{0}]' -f $ModuleName), 'Deploy')) {
                            New-TemplateDeployment @functionInput
                        }
                    }
                }

            } catch {
                Write-Error $_
            } finally {
                # Restore parameter files
                # -----------------------
                if (($ValidationTest -or $DeploymentTest) -and $ValidateOrDeployParameters -and $parameterFiles) {
                    # Replace Values with Tokens For Repo Updates
                    Write-Verbose 'Restoring Tokens'
                    $null = Convert-TokensInFileList @tokenConfiguration -SwapValueWithName $true
                }
            }
        }
    }
    end {
    }
}
