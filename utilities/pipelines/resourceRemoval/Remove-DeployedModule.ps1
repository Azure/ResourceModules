<#
.SYNOPSIS
Remove deployed resources based on their deploymentName(s)

.DESCRIPTION
Remove deployed resources based on their deploymentName(s)

.PARAMETER deploymentName(s)
Mandatory. The name(s) of the deployment(s)

.PARAMETER templateFilePath
Mandatory. The path to the template used for the deployment. Used to determine the level/scope (e.g. subscription)

.PARAMETER ResourceGroupName
Optional. The name of the resource group the deployment was happening in. Relevant for resource-group level deployments.

.EXAMPLE
Remove-DeployedModule -deploymentName 'virtualWans-20211204T1812029146Z' -templateFilePath "$home/ResourceModules/arm/Microsoft.Network/virtualWans/deploy.bicep" -resourceGroupName 'test-virtualWan-parameters.json-rg'

Remove the deployment 'virtualWans-20211204T1812029146Z' from resource group 'test-virtualWan-parameters.json-rg' that was executed using template in path "$home/ResourceModules/arm/Microsoft.Network/virtualWans/deploy.bicep"
#>
function Remove-DeployedModule {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('deploymentName')]
        [string[]] $deploymentNames,

        [Parameter(Mandatory = $true)]
        [string] $templateFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName = 'validation-rg'
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
        # Load functions
        . (Join-Path $PSScriptRoot 'helper' 'Remove-ModuleDeployment.ps1')
    }

    process {
        $moduleName = Split-Path (Split-Path $templateFilePath -Parent) -LeafBase

        # The intial sequence is a general order-recommendation
        $removalSequence = @(
            'Microsoft.Insights/diagnosticSettings',
            'Microsoft.Resources/resourceGroups',
            'Microsoft.Compute/virtualMachines'
        )

        foreach ($deploymentName in $deploymentNames) {
            Write-Verbose ('Handling resource removal with deployment name [{0}]' -f $deploymentName) -Verbose
            switch ($moduleName) {
                'virtualWans' {
                    $removalSequence += @(
                        'Microsoft.Network/vpnGateways',
                        'Microsoft.Network/virtualHubs',
                        'Microsoft.Network/vpnSites'
                    )
                    break
                }
                'automationAccounts' {
                    $removalSequence += @(
                        'Microsoft.OperationsManagement/solutions',
                        'Microsoft.OperationalInsights/workspaces/linkedServices',
                        'Microsoft.Network/privateEndpoints/privateDnsZoneGroups',
                        'Microsoft.Network/privateEndpoints'
                    )
                    break
                }
            }

            # Invoke removal
            $inputObject = @{
                deploymentName    = $deploymentName
                ResourceGroupName = $ResourceGroupName
                templateFilePath  = $templateFilePath
                removalSequence   = $removalSequence
            }
            Remove-ModuleDeployment @inputObject -Verbose
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
