<#
.SYNOPSIS
Get module configuration data based on the latest API information available


.DESCRIPTION
Get module configuration data based on the latest API information available. If you want to use a nested resource type, just concatinate the identifiers like 'storageAccounts/blobServices/containers'

.PARAMETER ProviderNamespace
Mandatory. The provider namespace to query the data for

.PARAMETER ResourceType
Mandatory. The resource type to query the data for

.PARAMETER RepositoryPath
Mandatory. The path to the API Specs repository to fetch the data from.

.PARAMETER ExcludeChildren
Optional. Don't include child resource types in the result

.PARAMETER IncludePreview
Optional. Include preview API versions

.EXAMPLE
Get-AzureApiSpecsData -ProviderNamespace 'Microsoft.Storage' -ResourceType 'storageAccounts/blobServices/containers' -RepositoryPath (Join-Path $script:temp $repoName)

Get the data for [Microsoft.Storage/storageAccounts/blobServices/containers] based on the data stored in the provided API Specs rpository path
#>
function Get-AzureApiSpecsData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryPath,

        [Parameter(Mandatory = $false)]
        [switch] $ExcludeChildren,

        [Parameter(Mandatory = $false)]
        [switch] $IncludePreview
    )

    ##############################################
    ##   Find relevant Spec-Files & URL Paths   ##
    ##############################################
    $getPathDataInputObject = @{
        ProviderNamespace = $ProviderNamespace
        ResourceType      = $ResourceType
        RepositoryPath    = $RepositoryPath
        IncludePreview    = $IncludePreview
    }
    $pathData = Get-ServiceSpecPathData @getPathDataInputObject

    # Filter Children if desired
    if ($ExcludeChildren) {
        $pathData = $pathData | Where-Object { [String]::IsNullOrEmpty($_.parentUrlPath) }
    }

    #################################################################
    #   Iterate through parent & child-paths and extract the data   #
    #################################################################
    $moduleData = @()
    foreach ($pathBlock in $pathData) {
        $resolveInputObject = @{
            JSONFilePath = $pathBlock.jsonFilePath
            urlPath      = $pathBlock.urlPath
            ResourceType = $ResourceType
        }
        $resolvedParameters = Resolve-ModuleData @resolveInputObject

        # Calculate simplified identifier
        $identifier = ($pathBlock.urlPath -split '\/providers\/')[1]
        $identifierElem = $identifier -split '\/'
        $identifier = $identifierElem[0] # E.g. Microsoft.Storage

        if ($identifierElem.Count -gt 1) {
            # Add the remaining elements (every 2nd as everything in between represents a 'name')
            $remainingRelevantElem = $identifierElem[1..($identifierElem.Count)]
            for ($index = 0; $index -lt $remainingRelevantElem.Count; $index++) {
                if ($index % 2 -eq 0) {
                    $identifier += ('/{0}' -f $remainingRelevantElem[$index])
                }
            }
        }

        # Build result
        $moduleData += @{
            data       = $resolvedParameters
            # identifier = ($pathBlock.urlPath -split '\/providers\/')[1]
            identifier = $identifier
            metadata   = @{
                urlPath       = $pathBlock.urlPath
                jsonFilePath  = $pathBlock.jsonFilePath
                parentUrlPath = $pathBlock.parentUrlPath
            }
        }
    }

    return $moduleData
}
