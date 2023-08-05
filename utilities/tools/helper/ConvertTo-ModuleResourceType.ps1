<#
.SYNOPSIS
Converts the module folder path to the actual resource type.

.DESCRIPTION
Converts the module folder path to the actual resource type.

.PARAMETER ResourceIdentifier
Mandatory. The resource identifier to search for, i.e. the relative module file path starting from the resource provider folder.

.EXAMPLE
ConvertTo-ModuleResourceType -ResourceIdentifier 'storage/storage-account'.

Returns 'Microsoft.Storage/storageAccounts'.

.EXAMPLE
ConvertTo-ModuleResourceType -ResourceIdentifier 'storage/storage-account/blob-service/container/immutability-policy'.

Returns 'Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies'.
#>
function ConvertTo-ModuleResourceType {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceIdentifier
    )

    . (Join-Path $PSScriptRoot 'Get-SpecsAlignedResourceName.ps1')

    $provider, $parentType, $childTypeString = $ResourceIdentifier -Split '[\/|\\]', 3
    $parentResourceIdentifier = $provider, $parentType -join '/'

    $fullParentResourceType = Get-SpecsAlignedResourceName -ResourceIdentifier $parentResourceIdentifier

    if (-not $childTypeString) {
        $fullResourceType = $fullParentResourceType
    } else {
        $childTypeArray = $childTypeString.Split('/')

        $innerResourceType = $fullParentResourceType
        foreach ($childType in $childTypeArray) {
            # Additonal check for child types non existing on their own (e.g. sites/hybridConnectionNamespaces does not exist, sites/hybridConnectionNamespaces/relays does)
            $innerResourceTypeLeafReduced = Get-ReducedWordString -StringToReduce ($innerResourceType -Split '[\/|\\]')[-1]
            $childTypeReduced = Get-ReducedWordString -StringToReduce $childType
            if ($innerResourceTypeLeafReduced -eq $childTypeReduced) {
                break
            }

            $innerResourceType = $innerResourceType.Replace('Microsoft.', ''), $childType -join '/'
            $fullResourceType = Get-SpecsAlignedResourceName -ResourceIdentifier $innerResourceType
            $innerResourceType = $fullResourceType
        }
    }

    return $fullResourceType
}
