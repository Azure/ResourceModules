<#
.SYNOPSIS
Format the provide resource IDs into objects of resourceID, name & type

.DESCRIPTION
Format the provide resource IDs into objects of resourceID, name & type

.PARAMETER resourceIds
Optional. The resource IDs to process

.EXAMPLE
Get-ResourceIdsAsFormattedObjects -resourceIds @('/subscriptions/<subscriptionID>/resourceGroups/test-analysisServices-parameters.json-rg/providers/Microsoft.Storage/storageAccounts/adpsxxazsaaspar01')

Returns an object @{
    resourceId = '/subscriptions/<subscriptionID>/resourceGroups/test-analysisServices-parameters.json-rg/providers/Microsoft.Storage/storageAccounts/adpsxxazsaaspar01'
    type       = 'Microsoft.Storage/storageAccounts'
    name       = 'adpsxxazsaaspar01'
}
#>
function Get-ResourceIdsAsFormattedObjects {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string[]] $resourceIds = @()
    )

    $formattedResources = [System.Collections.ArrayList]@()

    # Optional resourceGroup-level resources to identify implicitly deployed child-resources
    $allResourceGroupResources = @()

    foreach ($resourceId in $resourceIds) {

        $idElements = $resourceId.Split('/')

        switch ($idElements.Count) {
            { $PSItem -eq 5 } {
                # subscription level resource group
                $formattedResources += @{
                    resourceId = $resourceId
                    name       = $idElements[-1]
                    type       = 'Microsoft.Resources/resourceGroups'
                }
                break
            }
            { $PSItem -eq 6 } {
                # subscription-level resource group
                $formattedResources += @{
                    resourceId = $resourceId
                    name       = $idElements[-1]
                    type       = $idElements[4, 5] -join '/'
                }
                break
            }
            { $PSItem -eq 7 } {
                if (($resourceId.Split('/'))[3] -ne 'resourceGroups') {
                    # subscription-level resource
                    $formattedResources += @{
                        resourceId = $resourceId
                        name       = Split-Path $resourceId -Leaf
                        type       = $idElements[4, 5] -join '/'
                    }
                } else {
                    # resource group-level
                    if ($allResourceGroupResources.Count -eq 0) {
                        $allResourceGroupResources = Get-AzResource -ResourceGroupName $resourceGroupName -Name '*'
                    }
                    $expandedResources = $allResourceGroupResources | Where-Object { $_.ResourceId.startswith($resourceId) }
                    $expandedResources = $expandedResources | Sort-Object -Descending -Property { $_.ResourceId.Split('/').Count }
                    foreach ($resource in $expandedResources) {
                        $formattedResources += @{
                            resourceId = $resource.ResourceId
                            name       = $resource.Name
                            type       = $resource.Type
                        }
                    }
                }
                break
            }
            { $PSItem -ge 8 } {
                # child-resource level
                $indexOfResourceType = $idElements.IndexOf(($idElements -like 'Microsoft.**')[0])
                $type = $idElements[$indexOfResourceType, ($indexOfResourceType + 1)] -join '/'

                # Concat rest of resource type along the ID
                $partCounter = $indexOfResourceType + 1
                while (-not ($partCounter + 2 -gt $idElements.Count - 1)) {
                    $type += ('/{0}' -f $idElements[($partCounter + 2)])
                    $partCounter = $partCounter + 2
                }

                $formattedResources += @{
                    resourceId = $resourceId
                    name       = $idElements[-1]
                    type       = $type
                }
                break
            }
            Default {
                throw "Failed to process resource ID [$resourceId]"
            }
        }
    }

    return $formattedResources
}
