<#
.SYNOPSIS
Remove deployed resources based on their deploymentName(s)

.DESCRIPTION
Remove deployed resources based on their deploymentName(s)

.PARAMETER DeploymentName(s)
Mandatory. The name(s) of the deployment(s)

.PARAMETER TemplateFilePath
Mandatory. The path to the template used for the deployment. Used to determine the level/scope (e.g. subscription)

.PARAMETER ResourceGroupName
Optional. The name of the resource group the deployment was happening in. Relevant for resource-group level deployments.

.PARAMETER ManagementGroupId
Optional. The ID of the management group to fetch deployments from. Relevant for management-group level deployments.

.EXAMPLE
Initialize-DeploymentRemoval -DeploymentName 'virtualWans-20211204T1812029146Z' -TemplateFilePath "$home/ResourceModules/arm/Microsoft.Network/virtualWans/deploy.bicep" -resourceGroupName 'test-virtualWan-parameters.json-rg'

Remove the deployment 'virtualWans-20211204T1812029146Z' from resource group 'test-virtualWan-parameters.json-rg' that was executed using template in path "$home/ResourceModules/arm/Microsoft.Network/virtualWans/deploy.bicep"
#>
function Initialize-DeploymentRemoval {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('DeploymentName')]
        [string[]] $DeploymentNames,

        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string] $subscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
        # Load functions
        . (Join-Path $PSScriptRoot 'helper' 'Remove-Deployment.ps1')
    }

    process {

        if (-not [String]::IsNullOrEmpty($subscriptionId)) {
            Write-Verbose ('Setting context to subscription [{0}]' -f $subscriptionId)
            $null = Set-AzContext -Subscription $subscriptionId
        }

        $moduleName = Split-Path (Split-Path $templateFilePath -Parent) -LeafBase

        # The initial sequence is a general order-recommendation
        $removalSequence = @(
            'Microsoft.Insights/diagnosticSettings',
            'Microsoft.Network/privateEndpoints/privateDnsZoneGroups',
            'Microsoft.Network/privateEndpoints',
            'Microsoft.OperationsManagement/solutions',
            'Microsoft.OperationalInsights/workspaces/linkedServices',
            'Microsoft.Resources/resourceGroups',
            'Microsoft.Compute/virtualMachines'
        )
        Write-Verbose ('Template file path: [{0}]' -f $templateFilePath) -Verbose
        Write-Verbose ('Module name: [{0}]' -f $moduleName) -Verbose

        foreach ($deploymentName in $deploymentNames) {
            Write-Verbose ('Handling resource removal with deployment name [{0}]' -f $deploymentName) -Verbose

            ### CODE LOCATION: Add custom removal sequence here
            ## Add custom module-specific removal sequence following the example below
            # switch ($moduleName) {
            #     '<moduleName01>' {
            #         $removalSequence += @(
            #             '<resourceType01>',
            #             '<resourceType02>',
            #             '<resourceType03>'
            #         )
            #         break
            #     }
            # }

            # Invoke removal
            $inputObject = @{
                DeploymentName   = $deploymentName
                TemplateFilePath = $templateFilePath
                RemovalSequence  = $removalSequence
            }
            if (-not [String]::IsNullOrEmpty($resourceGroupName)) {
                $inputObject['resourceGroupName'] = $resourceGroupName
            }
            if (-not [String]::IsNullOrEmpty($ManagementGroupId)) {
                $inputObject['ManagementGroupId'] = $ManagementGroupId
            }
            Remove-Deployment @inputObject -Verbose
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
