<#
.SYNOPSIS
Get module configuration data based on the latest API information available

.DESCRIPTION
Get module configuration data based on the latest API information available. If you want to use a nested resource type, just concatinate the identifiers like 'storageAccounts/blobServices/containers'

.PARAMETER FullResourceType
Mandatory. The full resource type including the provider namespace to query the data for (e.g., Microsoft.Storage/storageAccounts)

.PARAMETER ExcludeChildren
Optional. Don't include child resource types in the result

.PARAMETER IncludePreview
Optional. Include preview API versions

.PARAMETER KeepArtifacts
Optional. Skip the removal of downloaded/cloned artifacts (e.g. the API-Specs repository). Useful if you want to run the function multiple times in a row.

.EXAMPLE
Get-AzureApiSpecsData -FullResourceType 'Microsoft.Keyvault/vaults'

Get the data for [Microsoft.Keyvault/vaults]

.EXAMPLE
Get-AzureApiSpecsData -FullResourceType 'Microsoft.AVS/privateClouds' -Verbose -KeepArtifacts

Get the data for [Microsoft.AVS/privateClouds] and do not delete any downloaded/cloned artifact.

.EXAMPLE
Get-AzureApiSpecsData -FullResourceType 'Microsoft.Storage/storageAccounts/blobServices/containers' -Verbose -KeepArtifacts

Get the data for [Microsoft.Storage/storageAccounts/blobServices/containers] and do not delete any downloaded/cloned artifact.
#>
function Get-AzureApiSpecsData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FullResourceType,

        [Parameter(Mandatory = $false)]
        [switch] $ExcludeChildren,

        [Parameter(Mandatory = $false)]
        [switch] $IncludePreview,

        [Parameter(Mandatory = $false)]
        [switch] $KeepArtifacts
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
        $providerNamespace = ($FullResourceType -split '/')[0]
        $resourceType = $FullResourceType -replace "$providerNamespace/", ''
    }

    process {

        #########################################
        ##   Temp Clone API Specs Repository   ##
        #########################################
        $repoUrl = $script:CONFIG.url_CloneRESTAPISpecRepository
        $repoName = Split-Path $repoUrl -LeafBase
        $repositoryPath = (Join-Path $script:temp $repoName)

        Copy-CustomRepository -RepoUrl $repoUrl -RepoName $repoName

        try {
            ##############################################
            ##   Find relevant Spec-Files & URL Paths   ##
            ##############################################
            $getPathDataInputObject = @{
                ProviderNamespace = $providerNamespace
                ResourceType      = $resourceType
                RepositoryPath    = $repositoryPath
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

                $resolveInputObject = @{
                    JSONFilePath = $pathBlock.jsonFilePath
                    UrlPath      = $pathBlock.urlPath
                    ResourceType = $identifier -replace "$ProviderNamespace/", '' # Using pathBlock-based identifier to support also child-resources
                }
                $resolvedParameters = Resolve-ModuleData @resolveInputObject

                # Build result
                $moduleData += @{
                    data       = $resolvedParameters
                    identifier = $identifier
                    metadata   = @{
                        urlPath       = $pathBlock.urlPath
                        jsonFilePath  = $pathBlock.jsonFilePath
                        parentUrlPath = $pathBlock.parentUrlPath
                    }
                }
            }

            return $moduleData

        } catch {
            throw $_
        } finally {
            ##########################
            ##   Remove Artifacts   ##
            ##########################
            if (-not $KeepArtifacts) {
                Write-Verbose ('Deleting temp folder [{0}]' -f $script:temp)
                $null = Remove-Item $script:temp -Recurse -Force
            }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
