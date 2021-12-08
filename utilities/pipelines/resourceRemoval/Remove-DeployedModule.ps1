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

    $moduleName = Split-Path (Split-Path $templateFilePath -Parent) -LeafBase

    foreach ($deploymentName in $deploymentNames) {

        switch ($moduleName) {
            'virtualWans' {
                Write-Verbose 'Run vWAN removal script' -Verbose
                # Load function
                . (Join-Path $PSScriptRoot 'helper' 'Remove-vWan.ps1')

                # Invoke removal
                $inputObject = @{
                    deploymentName    = $deploymentName
                    ResourceGroupName = $ResourceGroupName
                }
                Remove-vWan @inputObject -Verbose
            }
            'virtualMachines' {
                Write-Verbose 'Run virtual machine removal script' -Verbose
                # Load function
                . (Join-Path $PSScriptRoot 'helper' 'Remove-VirtualMachine.ps1')

                # Invoke removal
                $inputObject = @{
                    deploymentName    = $deploymentName
                    ResourceGroupName = $ResourceGroupName
                }
                Remove-VirtualMachine @inputObject -Verbose
            }
            default {
                Write-Verbose 'Run default removal script' -Verbose
                # Load function
                . (Join-Path $PSScriptRoot 'helper' 'Remove-GeneralModule.ps1')

                # Invoke removal
                $inputObject = @{
                    deploymentName    = $deploymentName
                    ResourceGroupName = $ResourceGroupName
                    templateFilePath  = $templateFilePath
                }
                Remove-GeneralModule @inputObject -Verbose
            }
        }
    }
}
