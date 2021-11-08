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
                Write-Verbose ('Did not to find Resource Group by tag [removeModule={0}]. Retrying in [{1} seconds] [{2}/{3}]' -f $moduleName, $tagSearchRetryInterval, $tagSearchRetryCount, $tagSearchRetryLimit)
                Start-Sleep $tagSearchRetryInterval
                $tagSearchRetryCount++
            }

            # Remove resources
            # ----------------
            if ($resourceGroupToRemove) {
                if ($resourceGroupToRemove.Count -gt 1) {
                    Write-Error "More than 1 Resource Group has been found with tag [removeModule=$moduleName]. Only 1 Resource Group is expected."
                } elseif (Get-AzResource -ResourceGroupName $resourceGroupToRemove.ResourceGroupName) {
                    Write-Error ('Resource Group [{0}] still has resources provisioned.' -f $resourceGroupToRemove.ResourceGroupName)
                } else {
                    Write-Verbose ('Removing Resource Group: {0}' -f $resourceGroupToRemove.ResourceGroupName) -Verbose
                    try {
                        $removeStatus = $resourceGroupToRemove |
                            Remove-AzResourceGroup -Force -ErrorAction Stop
                        if ($removeStatus) {
                            Write-Verbose ('Successfully removed Resource Group: {0}' -f $resourceGroupToRemove.ResourceGroupName) -Verbose
                        }
                    } catch {
                        Write-Error ('Resource Group removal failed. Reason: [{0}]' -f $_.Exception.Message)
                    }
                }
            } else {
                Write-Error ('Unable to find Resource Group by tag [removeModule={0}].' -f $moduleName)
            }
        } else {
            Write-Verbose 'Handle resource group level removal'

            # Identify resources
            # ------------------
            $tagSearchRetryCount = 1
            while (-not ($resourcesToRemove = Get-AzResource -Tag @{ removeModule = $moduleName } -ResourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue') -and $tagSearchRetryCount -le $tagSearchRetryLimit) {
                Write-Verbose ('Did not to find resources by tags [removeModule={0}] in resource group [{1}]. Retrying in [{2} seconds] [{3}/{4}]' -f $moduleName, $resourceGroupName, $tagSearchRetryInterval, $tagSearchRetryCount, $tagSearchRetryLimit)
                Start-Sleep $tagSearchRetryInterval
                $tagSearchRetryCount++
            }

            # Remove resources
            # ----------------
            if ($resourcesToRemove) {

                # If VMs are available, delete those first
                if ($vmsContained = $resourcesToRemove | Where-Object { $_.resourcetype -eq 'Microsoft.Compute/virtualMachines' }) {
                    Remove-Resource -resourceToRemove $vmsContained
                    # refresh
                    $resourcesToRemove = Get-AzResource -Tag @{ removeModule = $moduleName } -ResourceGroupName $resourceGroupName
                }

                Remove-Resource -resourceToRemove $resourcesToRemove

                # $currentRetry = 0
                # $resourcesToRetry = @()
                # if ($PSCmdlet.ShouldProcess(("[{0}] Resource(s) with a maximum of [$maximumRemovalRetries] attempts." -f $resourcesToRemove.Count), 'Remove')) {
                #     while (($resourcesToRetry = Remove-Resource -resourceToRemove $resourcesToRemove -Verbose).Count -gt 0 -and $currentRetry -le $maximumRemovalRetries) {
                #         Write-Verbose ('Re-try removal of remaining [{0}] resources. Round [{1}|{2}]' -f $resourcesToRetry.Count, $currentRetry, $maximumRemovalRetries)
                #         $currentRetry++
                #     }

                #     if ($resourcesToRetry.Count -gt 0) {
                #         throw ('The removal failed for resources [{0}]' -f ($resourcesToRetry.Name -join ', '))
                #     } else {
                #         Write-Verbose 'The removal completed successfully'
                #     }
                # } else {
                #     Remove-Resource -resourceToRemove $resourcesToRemove -WhatIf
                # }
            } else {
                Write-Error ("Unable to find resources by tags [removeModule=$moduleName] in resource group [$resourceGroupName].")
            }
        }
    }
    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
