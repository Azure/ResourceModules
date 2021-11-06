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
        [int] $maximumRemovalRetries = 3
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {

        #####################
        ## Process Removal ##
        #####################
        if ([String]::IsNullOrEmpty($resourceGroupName)) {
            Write-Verbose 'Handle subscription level removal'
            $resourceGroupToRemove = Get-AzResourceGroup -Tag @{ removeModule = $moduleName }
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
            $resourcesToRemove = Get-AzResource -Tag @{ removeModule = $moduleName } -ResourceGroupName $resourceGroupName
            if ($resourcesToRemove) {

                # If VMs are available, delete those first
                if ($vmsContained = $resourcesToRemove | Where-Object { $_.resourcetype -eq 'Microsoft.Compute/virtualMachines' }) {
                    Remove-Resource -resourcesToRemove $vmsContained
                    # refresh
                    $resourcesToRemove = Get-AzResource -Tag @{ removeModule = $moduleName } -ResourceGroupName $resourceGroupName
                }

                $currentRety = 0
                $resourcesToRetry = @()
                if ($PSCmdlet.ShouldProcess(("[{0}] Resource(s) with a maximum of [$maximumRemovalRetries] attempts." -f $resourcesToRemove.Count), 'Remove')) {
                    while (($resourcesToRetry = Remove-Resource -resourcesToRemove $resourcesToRemove -Verbose).Count -gt 0 -and $currentRety -le $maximumRemovalRetries) {
                        Write-Verbose ('Re-try removal of remaining [{0}] resources. Round [{1}|{2}]' -f $resourcesToRetry.Count, $currentRety, $maximumRemovalRetries)
                        $currentRety++
                    }

                    if ($resourcesToRetry.Count -gt 0) {
                        throw ('The removal failed for resources [{0}]' -f ($resourcesToRetry.Name -join ', '))
                    } else {
                        Write-Verbose 'The removal completed successfully'
                    }
                } else {
                    Remove-Resource -resourcesToRemove $resourcesToRemove -WhatIf
                }
            } else {
                Write-Error ("Unable to find resources by tags [removeModule=$moduleName] in resource group [$resourceGroupName].")
            }
        }
    }
    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}

function Remove-Resource {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [object[]] $resourcesToRemove
    )

    $resourcesToRetry = @()
    Write-Verbose '----------------------------------'
    foreach ($resource in $resourcesToRemove) {
        try {
            if ($PSCmdlet.ShouldProcess(('Resource [{0}] of type [{1}] from resource group [{2}]' -f $resource.Name, $resource.ResourceType, $resource.ResourceGroupName), 'Remove')) {
                $null = Remove-AzResource -ResourceId $resource.ResourceId -Force -ErrorAction 'Stop'
                Write-Verbose ('Removed resource [{0}] of type [{1}] from resource group [{2}]' -f $resource.Name, $resource.ResourceType, $resource.ResourceGroupName)
            }
        } catch {
            Write-Warning ('Removal moved back for re-try. Reason: [{0}]' -f $_.Exception.Message)
            $resourcesToRetry += $resource
        }
    }
    Write-Verbose '----------------------------------'
    return $resourcesToRetry
}
