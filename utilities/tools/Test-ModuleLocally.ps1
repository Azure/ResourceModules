
<#
.SYNOPSIS
This Function Helps with Testing A Module Locally

.DESCRIPTION
This Function Helps with Testing A Module Locally. Use this Function To perform Pester Testing for a Module and then attempting to deploy it. It Also allows you to use your own
subscription Id, Principal Id, tenant ID and other parameters that need to be tokenized.

.PARAMETER ModuleName
The name of The module to test. (i.e. 'Microsoft.Authorization/policyExemptions')

.PARAMETER PesterTest
A Switch Paramaeter that triggers a Pester Test for the Module

.PARAMETER ValidateOrDeployParameters
An Object consisting of the components that are required when using the Validate Test or DeploymentTest Switch parameter. See example:

.PARAMETER DeploymentTest
A Switch Paramaeter that triggers the Deployment of the Module

.PARAMETER ValidationTest
A Switch Paramaeter that triggers the Validation of the Module Only without Deployment

.EXAMPLE

$TestModuleLocallyInput = @{
    ModuleName       = 'Microsoft.Authorization\roleAssignments'
    PesterTest       = $true
    DeploymentTest       = $true
    ValidationTest        = $false
    ValidateOrDeployParameters = @{
        Location          = 'azureRegionName'
        ResourceGroupName = 'resourceGroupName'
        SubscriptionId    = '12345678-1234-1234-abcd-1369d14d0d45'
        ManagementGroupId = 'mg-contoso'
        PrincipalId       = '12345678-1234-1234-abcd-1369d14d0d45'
        TenantId          = '12345678-1234-1234-abcd-1369d14d0d45'
        RemoveDeployment  = $false
    }
}

Test-ModuleLocally @TestModuleLocallyInput

.NOTES
Make sure you provide the right information in the 'ValidateOrDeployParameters' parameter for this function abd Ensure you have the ability to perform the deployment operations locally.
#>
function Test-ModuleLocally {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]$ModuleName,

        [parameter(Mandatory = $false)]
        [switch]$PesterTest,

        [Parameter(ParameterSetName = 'Deploy')]
        [parameter(Mandatory)]
        [psobject]$ValidateOrDeployParameters,

        [Parameter(ParameterSetName = 'Deploy')]
        [parameter(Mandatory = $false)]
        [switch]$DeploymentTest,

        [Parameter(ParameterSetName = 'Deploy')]
        [parameter(Mandatory = $false)]
        [switch]$ValidationTest,

        [Parameter(ParameterSetName = 'Deploy')]
        [parameter(Mandatory = $false)]
        [switch]$DeployAllParameterFiles

    )

    begin {
        Write-Verbose "Running Local Tests for $($ModuleName.Split('\')[-1])"
    }
    process {
        # Test Module
        if ($PesterTest) {
            Write-Verbose "Pester Testing Module: $ModuleName"
            Invoke-Pester -Configuration @{
                Run        = @{
                    Container = New-PesterContainer -Path (Join-Path $PSScriptRoot '..\..' 'arm\.global\global.module.tests.ps1') -Data @{
                        moduleFolderPaths = (Join-Path $PSScriptRoot '..\..\arm' $ModuleName)
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
        }
        # Deploy Module
        if (($ValidationTest -or $DeploymentTest) -and $ValidateOrDeployParameters) {
            # Find Test Parameter Files
            $ModuleParameterFiles = Get-ChildItem -Path (Join-Path $PSScriptRoot '..\..\arm' $ModuleName '.parameters') -Recurse
            # Load Tokens Converter Script
            . (Join-Path $PSScriptRoot '..\..' '.github\actions\sharedScripts\Convert-TokensInFileList.ps1')
            # Replace Tokens with Values For Local Testing
            $TokensReplaceWithObject = @(
                @{ Replace = '<<tenantId>>'; With = "$($ValidateOrDeployParameters.TenantId)" }
                @{ Replace = '<<subscriptionId>>'; With = "$($ValidateOrDeployParameters.SubscriptionId)" }
                @{ Replace = '<<managementGroupId>>'; With = "$($ValidateOrDeployParameters.ManagementGroupId)" }
                @{ Replace = '<<principalId1>>'; With = "$($ValidateOrDeployParameters.PrincipalId)" }
            )
            $ModuleParameterFiles | ForEach-Object { Convert-TokensInFileList -Paths $PSitem.FullName -TokensReplaceWith $TokensReplaceWithObject }

            # Build Modules Validation and Deployment Inputs
            $functionInput = @{
                templateFilePath  = (Join-Path $PSScriptRoot '..\..\arm' $ModuleName 'deploy.bicep')
                parameterFilePath = (Join-Path $PSScriptRoot '..\..\arm' $ModuleName '.parameters\parameters.json')
                location          = "$($ValidateOrDeployParameters.Location)"
                resourceGroupName = "$($ValidateOrDeployParameters.ResourceGroupName)"
                subscriptionId    = "$($ValidateOrDeployParameters.SubscriptionId)"
                managementGroupId = "$($ValidateOrDeployParameters.ManagementGroupId)"
            }

            try {
                # Validate Template
                if ($ValidationTest) {
                    Write-Verbose "Validating Module: $ModuleName"
                    # Load Modules Deployment Script
                    . (Join-Path $PSScriptRoot '..\..' '.github\actions\templates\validateModuleDeploy\scripts\Test-TemplateWithParameterFile.ps1')
                    # Invoke Validation
                    Test-TemplateWithParameterFile @functionInput -Verbose
                }

                # Deploy Template
                if ($DeploymentTest) {
                    Write-Verbose "Deploying Module: $ModuleName"
                    # Set the ParameterFilePath to Directory instead of the default 'parameters.json'
                    if ($DeployAllParameterFiles) {
                        $functionInput.parameterFilePath = (Join-Path $PSScriptRoot '..\..\arm' $ModuleName '.parameters')
                    }
                    # Append to Function Input the required parameters for Deployment
                    $functionInput += @{
                        moduleName       = "l-$($ModuleName.Split('\')[-1])"
                        removeDeployment = [System.Convert]::ToBoolean($ValidateOrDeployParameters.RemoveDeployment)
                        retryLimit       = 1
                    }
                    # Load Modules Deployment Script
                    . (Join-Path $PSScriptRoot '..\..' '.github\actions\templates\deployModule\scripts\New-ModuleDeployment.ps1')
                    # Invoke Deployment
                    New-ModuleDeployment @functionInput -Verbose
                }
            } catch {
                Write-Error $PSItem.Exception
                # Replace Values with Tokens For Repo Updates
                $RestoreTokensObject = @(
                    @{ Replace = "$($ValidateOrDeployParameters.TenantId)" ; With = '<<tenantId>>' }
                    @{ Replace = "$($ValidateOrDeployParameters.SubscriptionId)" ; With = '<<subscriptionId>>' }
                    @{ Replace = "$($ValidateOrDeployParameters.ManagementGroupId)"; With = '<<managementGroupId>>' }
                    @{ Replace = "$($ValidateOrDeployParameters.PrincipalId)" ; With = '<<principalId1>>' }
                )
                $ModuleParameterFiles | ForEach-Object { Convert-TokensInFileList -Paths $PSitem.FullName -TokensReplaceWith $RestoreTokensObject }
            }

        }
    }

    end {
        # Restore Parameter Files
        if (($ValidateTest -or $DeploymentTest) -and $ValidateOrDeployParameters) {
            # Replace Values with Tokens For Repo Updates
            $RestoreTokensObject = @(
                @{ Replace = "$($ValidateOrDeployParameters.TenantId)" ; With = '<<tenantId>>' }
                @{ Replace = "$($ValidateOrDeployParameters.SubscriptionId)" ; With = '<<subscriptionId>>' }
                @{ Replace = "$($ValidateOrDeployParameters.ManagementGroupId)"; With = '<<managementGroupId>>' }
                @{ Replace = "$($ValidateOrDeployParameters.PrincipalId)" ; With = '<<principalId1>>' }
            )
            $ModuleParameterFiles | ForEach-Object { Convert-TokensInFileList -Paths $PSitem.FullName -TokensReplaceWith $RestoreTokensObject }
        }
    }
}
