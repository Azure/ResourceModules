<#
.SYNOPSIS
Invoke the removal of a deployed module

.DESCRIPTION
Invoke the removal of a deployed module.
Requires the resource in question to be tagged with 'removeModule = <moduleName>'

.PARAMETER moduleName
Mandatory. The name of the module to remove

.PARAMETER resourceGroupName
Mandatory. The resource group of the resource to remove

.PARAMETER maximumRemovalRetries
Optional. As the removal fetches all resources with the removal tag, and then tries to remove them one by one it can happen that the function tries to removed that as an active dependency on it (e.g. a VM disk of a VM deployment).
If the removal fails, the resource in question is moved back in the removal queue and another attempt is made after processing each other resource found.
This parameter controls, how often we want to push resources back in the queue and retry a removal.

.PARAMETER tagSearchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag

.PARAMETER tagSearchRetryInterval
Optional. The time to wait in between the search for resources via their remove tags

.EXAMPLE
Remove-DeployedModule -moduleName 'KeyVault' -resourceGroupName 'validation-rg'

Remove any resource in the resource group 'validation-rg' with tag 'removeModule = KeyVault'
#>
function Remove-DeployedModule {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $moduleName,

        [Parameter(Mandatory = $false)]
        [string] $resourceGroupName,

        [Parameter(Mandatory = $false)]
        [int] $maximumRemovalRetries = 3,

        [Parameter(Mandatory = $false)]
        [int] $tagSearchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $tagSearchRetryInterval = 15
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path $PSScriptRoot 'helper/Remove-Resource.ps1')
    }

    process {

        #####################
        ## Process Removal ##
        #####################
        if ([String]::IsNullOrEmpty($resourceGroupName)) {
            Write-Verbose 'Handle subscription level removal'

            # Identify resources
            # ------------------
            $tagSearchRetryCount = 1
            while (-not ($resourceGroupToRemove = Get-AzResourceGroup -Tag @{ removeModule = $moduleName } -ErrorAction 'SilentlyContinue') -and $tagSearchRetryCount -le $tagSearchRetryLimit) {
                Write-Verbose ('Did not to find Resource Group by tag [removeModule={0}]. Retrying in [{1}] seconds [{2}/{3}]' -f $moduleName, $tagSearchRetryInterval, $tagSearchRetryCount, $tagSearchRetryLimit)
                Start-Sleep $tagSearchRetryInterval
                $tagSearchRetryCount++
            }


            $resourcesToRemove = @()
            if (-not $resourceGroupToRemove) {
                Write-Error "No resource Group with Tag { RemoveModule = $moduleName } found"
                return
            }

            foreach ($resourceGroupInstance in $resourceGroupToRemove) {
                $resourcesToRemove += @{
                    resourceId = $resourceGroupInstance.ResourceId
                    name       = $resourceGroupInstance.ResourceGroupName
                    type       = 'Microsoft.Resources/Resources'
                }
            }
        } else {
            Write-Verbose 'Handle resource group level removal'

            # Identify resources
            # ------------------
            $tagSearchRetryCount = 1
            while (-not ($rawResourcesToRemove = Get-AzResource -Tag @{ removeModule = $moduleName } -ResourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue') -and $tagSearchRetryCount -le $tagSearchRetryLimit) {
                Write-Verbose ('Did not to find resources by tags [removeModule={0}] in resource group [{1}]. Retrying in [{2}] seconds [{3}/{4}]' -f $moduleName, $resourceGroupName, $tagSearchRetryInterval, $tagSearchRetryCount, $tagSearchRetryLimit)
                Start-Sleep $tagSearchRetryInterval
                $tagSearchRetryCount++
            }

            # If VMs are available, delete those first
            if ($vmsContained = $rawResourcesToRemove | Where-Object { $_.resourcetype -eq 'Microsoft.Compute/virtualMachines' }) {

                $intermediateResources = @()
                foreach ($vmInstance in $vmsContained) {
                    $intermediateResources += @{
                        resourceId = $vmInstance.ResourceId
                        name       = $vmInstance.Name
                        type       = $vmInstance.Type
                    }
                }
                Remove-Resource -resourceToRemove $intermediateResources -Verbose
                # refresh
                $rawResourcesToRemove = Get-AzResource -Tag @{ removeModule = $moduleName } -ResourceGroupName $resourceGroupName
            }

            if (-not $rawResourcesToRemove) {
                Write-Error "No resource with Tag { RemoveModule = $moduleName } found in resource group [$resourceGroupName]"
                return
            }

            $resourcesToRemove = @()
            foreach ($resource in $rawResourcesToRemove) {
                $resourcesToRemove += @{
                    resourceId = $vmInstance.ResourceId
                    name       = $vmInstance.Name
                    type       = $vmInstance.Type
                }
            }
        }

        # Remove resources
        # ----------------
        if ($PSCmdlet.ShouldProcess(('[{0}] resources' -f $resourcesToRemove.Count), 'Remove')) {
            Remove-Resource -resourceToRemove $resourcesToRemove -Verbose
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
