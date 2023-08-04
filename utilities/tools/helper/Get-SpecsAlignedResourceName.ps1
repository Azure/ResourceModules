<#
.SYNOPSIS
Remove a string to its core - i.e. the part the neither indicates plural nor singular.

.DESCRIPTION
Remove a string to its core - i.e. the part the neither indicates plural nor singular.

.PARAMETER StringToReduce
Mandatory. The string to reduce.

.EXAMPLE
Get-ReducedWordString -StringToReduce 'virtualMachines'

Returns 'virtualMachine'.

.EXAMPLE
Get-ReducedWordString -StringToReduce 'factories'

Returns 'factor'.
#>
function Get-ReducedWordString {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $StringToReduce
    )

    if ($StringToReduce -match '(.+?)(y|ii|ies|es|s)$') {
        return $Matches[1]
    }

    return $StringToReduce
}

<#
.SYNOPSIS
Try to find the actual provider namespace and resource type for a given resource identifier.

.DESCRIPTION
Try to find the actual provider namespace and resource type for a given resource identifier.
For example, for 'virtual-machine-images/image-template' it we want to find 'Microsoft.VirtualMachineImages/imageTemplates'.

.PARAMETER ResourceIdentifier
Mandatory. The resource identifier to search for.

.PARAMETER SpecsFilePath
Optional. The path to the specs file that contains all available provider namespaces & resource types. Defaults to 'utilities/src/apiSpecsList.json'.

.EXAMPLE
Get-SpecsAlignedResourceName -ResourceIdentifier 'virtual-machine-images/image-template'.

Returns 'Microsoft.VirtualMachineImages/imageTemplates'.
#>
function Get-SpecsAlignedResourceName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceIdentifier,

        [Parameter(Mandatory = $false)]
        [string] $SpecsFilePath = (Join-Path (Split-Path (Split-Path $PSScriptRoot)) 'src' 'apiSpecsList.json')
    )

    $specs = ConvertFrom-Json (Get-Content $specsFilePath -Raw) -AsHashtable

    $reducedResourceIdentifier = $ResourceIdentifier -replace '-'

    $rawProviderNamespace = $reducedResourceIdentifier.Split('/')[0]
    $foundProviderNamespaceMatches = ($specs.Keys | Sort-Object) | Where-Object { $_ -like "Microsoft.$rawProviderNamespace*" }

    if (-not $foundProviderNamespaceMatches) {
        $providerNamespace = "Microsoft.$rawProviderNamespace"
        Write-Warning "Failed to identifier provider namespace [$rawProviderNamespace]. Falling back to [$providerNamespace]."
    } else {
        $providerNamespace = ($foundProviderNamespaceMatches.Count -eq 1) ? $foundProviderNamespaceMatches : $foundProviderNamespaceMatches[0]
    }

    $innerResourceTypes = $specs[$providerNamespace].Keys | Sort-Object
    $rawResourceType = Get-ReducedWordString -StringToReduce ($reducedResourceIdentifier -replace ('{0}/' -f ($reducedResourceIdentifier.Split('/')[0])), '')
    $foundResourceTypeMatches = $innerResourceTypes | Where-Object { $_ -like "$rawResourceType*" }

    if (-not $foundResourceTypeMatches) {
        $resourceType = $reducedResourceIdentifier.Split('/')[0]
        Write-Warning "Failed to identify resource type [$rawResourceType] in provider namespace [$providerNamespace]. Fallback to [$resourceType]."
    } else {
        $resourceType = ($foundResourceTypeMatches.Count -eq 1) ? $foundResourceTypeMatches : $foundResourceTypeMatches[0]
    }

    return "$providerNamespace/$resourceType"
}
