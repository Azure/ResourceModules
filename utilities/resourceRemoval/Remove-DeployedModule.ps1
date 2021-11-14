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
        [int] $tagSearchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $tagSearchRetryInterval = 30
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


            # start update
            # TODO: Adjust to new structure
            # TODO: Make recursive/oder childresourceId split by longest path (childiest child)
            # if ($PSCmdlet.ShouldProcess(('Resource [{0}] of type [{1}] from resource group [{2}]' -f $resource.Name, $resource.ResourceType, $resource.ResourceGroupName), 'Remove')) {
            #     $allResources = Get-AzResource -ResourceGroupName $resource.ResourceGroupName
            #     $childResources = $allResources.ResourceId | Where-Object { $_.startswith("$($resource.ResourceId)/") } | Sort-Object -Descending -Property { $_.Split('/').Count }
            #     if ($null -eq $childResources) {
            #         # No child resources
            #         $null = Remove-AzResource -ResourceId $resource.ResourceId -Force -ErrorAction 'Stop'
            #         Write-Verbose ('Removed resource [{0}] of type [{1}] from resource group [{2}]' -f $resource.Name, $resource.ResourceType, $resource.ResourceGroupName)
            #     } else {
            #         foreach ($childResorceID in $childResources) {
            #             $resourceIDTokens = $childResorceID.Split('/')
            #             if ($PSCmdlet.ShouldProcess(('Resource [{0}] of type [{1}] from parent resource [{2}]' -f $resourceIDTokens[-1], $resourceIDTokens[-2], $resourceIDTokens[-3]), 'Remove')) {
            #                 $null = Remove-AzResource -ResourceId $childResorceID -Force -ErrorAction 'Stop'
            #                 Write-Verbose ('Removed child resource [{0}] of type [{1}] from parent resource [{2}]' -f $resourceIDTokens[-1], $resourceIDTokens[-2], $resourceIDTokens[-3])
            #             }
            #         }
            #     }
            # }
            ## end update


            $rawResourcesToRemoveExpaned = [System.Collections.ArrayList]@()
            $allResources = Get-AzResource -ResourceGroupName $resource.ResourceGroupName
            foreach ($topLevelResource in $rawResourcesToRemove) {
                if ($childResources = $allResources | Where-Object { $_.ResourceId.startswith('{0}/' -f $topLevelResource.ResourceId) } | Sort-Object -Descending -Property { $_.Split('/').Count }) {
                    foreach ($childResorce in $childResources) {
                        $resourcesToRemove += @{
                            resourceId = $childResorce.ResourceId
                            name       = $childResorce.Name
                            type       = $childResorce.Type
                        }
                    }
                } else {
                    $rawResourcesToRemoveExpaned += $topLevelResource
                }
            }



            # If VMs are available, delete those first
            if ($vmsContained = $rawResourcesToRemoveExpaned | Where-Object { $_.resourcetype -eq 'Microsoft.Compute/virtualMachines' }) {

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
                $rawResourcesToRemoveExpaned = $rawResourcesToRemoveExpaned | Where-Object { $_.ResourceId -notin $intermediateResources.resourceId }
            }

            if (-not $rawResourcesToRemoveExpaned) {
                Write-Error "No resource with Tag { RemoveModule = $moduleName } found in resource group [$resourceGroupName]"
                return
            }

            $resourcesToRemove = @()
            foreach ($resource in $rawResourcesToRemoveExpaned) {
                $resourcesToRemove += @{
                    resourceId = $resource.ResourceId
                    name       = $resource.Name
                    type       = $resource.Type
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
