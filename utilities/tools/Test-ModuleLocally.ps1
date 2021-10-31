
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

.PARAMETER DeployTest
A Switch Paramaeter that triggers the Deployment of the Module

.PARAMETER DeployParameters
An Object consisting of the components that are required when using the DeployTest Switch parameter. See example:

.EXAMPLE

$TestModuleLocallyInput = @{
    ModuleName       = 'Microsoft.Authorization\roleAssignments'
    PesterTest       = $true
    DeployTest       = $true
    DeployParameters = @{
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
Make sure you provide the right information in the 'DeployParameters' parameter for this function abd Ensure you have the ability to perform the deployment operations locally.
#>
function Test-ModuleLocally {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]$ModuleName,

        [parameter(Mandatory = $false)]
        [switch]$PesterTest,

        [Parameter(ParameterSetName = 'Deploy')]
        [parameter(Mandatory = $false)]
        [switch]$DeployTest,

        [Parameter(ParameterSetName = 'Deploy')]
        [parameter(Mandatory)]
        [psobject]$DeployParameters
    )

    begin {
        Write-Verbose "Running Local Tests for $($ModuleName.Split('\')[-1])"
    }
    process {
        # Test Module
        if ($PesterTest) {
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
        if ($DeployTest) {
            # Find Test Parameter Files
            $ModuleParameterFiles = Get-ChildItem -Path (Join-Path $PSScriptRoot '..\..\arm' $ModuleName '.parameters') -Recurse
            # Load Tokens Converter Script
            . (Join-Path $PSScriptRoot '..\..' '.github\actions\sharedScripts\Convert-TokensInFiles.ps1')
            # Replace Tokens with Values For Local Testing
            $TokensReplaceWithObject = @(
                @{ Replace = '<<tenantId>>'; With = "$($DeployParameters.TenantId)" }
                @{ Replace = '<<subscriptionId>>'; With = "$($DeployParameters.SubscriptionId)" }
                @{ Replace = '<<managementGroupId>>'; With = "$($DeployParameters.ManagementGroupId)" }
                @{ Replace = '<<principalId>>'; With = "$($DeployParameters.PrincipalId)" }
            )
            $ModuleParameterFiles | ForEach-Object { Convert-TokensInFiles -Paths $PSitem.FullName -TokensReplaceWith $TokensReplaceWithObject }

            # Load Modules Deployment Script
            . (Join-Path $PSScriptRoot '..\..' '.github\actions\templates\deployModule\scripts\New-ModuleDeployment.ps1')
            $functionInput = @{
                moduleName        = "l-$($ModuleName.Split('\')[-1])"
                templateFilePath  = (Join-Path $PSScriptRoot '..\..\arm' $ModuleName 'deploy.bicep')
                parameterFilePath = "$ModuleParameterFiles"
                location          = "$($DeployParameters.Location)"
                resourceGroupName = "$($DeployParameters.ResourceGroupName)"
                subscriptionId    = "$($DeployParameters.SubscriptionId)"
                managementGroupId = "$($DeployParameters.ManagementGroupId)"
                removeDeployment  = [System.Convert]::ToBoolean($DeployParameters.RemoveDeployment)
                retryLimit        = 1
            }
            # Invoke deployment
            New-ModuleDeployment @functionInput -Verbose
        }
    }

    end {
        # Restore Parameter Files
        if ($DeployTest) {
            # Replace Values with Tokens For Repo Updates
            $RestoreTokensObject = @(
                @{ Replace = "$($DeployParameters.TenantId)" ; With = '<<tenantId>>' }
                @{ Replace = "$($DeployParameters.SubscriptionId)" ; With = '<<subscriptionId>>' }
                @{ Replace = "$($DeployParameters.ManagementGroupId)"; With = '<<managementGroupId>>' }
                @{ Replace = "$($DeployParameters.PrincipalId)" ; With = '<<principalId>>' }
            )
            $ModuleParameterFiles | ForEach-Object { Convert-TokensInFiles -Paths $PSitem.FullName -TokensReplaceWith $RestoreTokensObject }
        }
    }
}
