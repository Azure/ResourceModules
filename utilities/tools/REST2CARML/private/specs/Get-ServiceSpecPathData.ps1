<#
.SYNOPSIS
Get the latest API spec file paths & service/url-PUT paths (in file) for a given ProviderNamespace - ResourceType combination. This includes also child-resources.

.DESCRIPTION
Get the latest API spec file path & service/url-PUT path (in file) for a given ProviderNamespace - ResourceType combination. This includes also child-resources.

.PARAMETER ProviderNamespace
Mandatory. The provider namespace to query the data for

.PARAMETER ResourceType
Mandatory. The resource type to query the data for

.PARAMETER RepositoryPath
Mandatory. The path of the cloned/downloaded API Specs repository

.PARAMETER IncludePreview
Optional. Set to also consider 'preview' versions for the request.

.EXAMPLE
Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Keyvault' -ResourceType 'vaults' -RepositoryPath './temp/azure-rest-api-specs' -IncludePreview

Get the latest API spec file path & service path for the resource type [Microsoft.KeyVault/vaults] - including the latest preview version (if any). Would return (without the JSON format):
[
    {
        "urlPath": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}/keys/{keyName}",
        "jsonFilePath": "azure-rest-api-specs/specification/keyvault/resource-manager/Microsoft.KeyVault/stable/2022-07-01/keys.json"
    },
    {
        "urlPath": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}/accessPolicies/{operationKind}",
        "jsonFilePath": "azure-rest-api-specs/specification/keyvault/resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json"
    },
    {
        "urlPath": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}",
        "jsonFilePath": "azure-rest-api-specs/specification/keyvault/resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json"
    },
    {
        "urlPath": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}/privateEndpointConnections/{privateEndpointConnectionName}",
        "jsonFilePath": "azure-rest-api-specs/specification/keyvault/resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json"
    },
    {
        "urlPath": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}/secrets/{secretName}",
        "jsonFilePath": "azure-rest-api-specs/specification/keyvault/resource-manager/Microsoft.KeyVault/stable/2022-07-01/secrets.json"
    }
]
#>
function Get-ServiceSpecPathData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryPath,

        [Parameter(Mandatory = $false)]
        [switch] $IncludePreview
    )

    #find the resource provider folder
    $resourceProviderFolders = Get-FolderList -rootFolder (Join-Path $RepositoryPath 'specification') -ProviderNamespace $ProviderNamespace

    $pathData = @()
    foreach ($resourceProviderFolder in $resourceProviderFolders) {
        Write-Verbose ('Processing Resource provider folder [{0}]' -f $resourceProviderFolder)
        $apiVersionFolders = @()

        $stablePath = Join-Path $resourceProviderFolder 'stable'
        if (Test-Path -Path $stablePath) { 
            $apiVersionFolders += (Get-ChildItem -Path $stablePath).FullName
        }
        if ($IncludePreview) {
            # adding preview API versions
            $previewPath = Join-Path $resourceProviderFolder 'preview'
            if (Test-Path -Path $previewPath) { 
                $apiVersionFolders += (Get-ChildItem -Path $previewPath).FullName 
            }
        }

        # sorting all API version from the newest to the oldest
        $apiVersionFolders = $apiVersionFolders | Sort-Object -Descending
        if ($apiVersionFolders.Count -eq 0) {
            Write-Warning ('No API folder found in folder [{0}]' -f $resourceProviderFolder)
            continue
        }

        # Get one unique instance of each file - with 'newer' files taking priority
        $specFilePaths = [System.Collections.ArrayList]@()
        foreach ($apiVersionFolder in $apiVersionFolders) {
            $filePaths = (Get-ChildItem $apiVersionFolder -Filter '*.json').FullName | Where-Object { (Split-Path $_ -Leaf) -notin @('common.json') }
            $alreadyIncludedFileNames = $specFilePaths | ForEach-Object { Split-Path $_ -LeafBase }
            foreach ($filePath in ($filePaths | Where-Object { (Split-Path $_ -LeafBase) -notin @($alreadyIncludedFileNames) })) {
                $specFilePaths += $filePath
            }
        }

        # Of those paths, get only those that contain a 'put' statement

        foreach ($specFilePath in $specFilePaths) {

            $urlPathsOfFile = (ConvertFrom-Json (Get-Content -Raw -Path $specFilePath) -AsHashtable).paths
            $urlPUTPathsInFile = $urlPathsOfFile.Keys | Where-Object { $urlPathsOfFile[$_].Keys -contains 'put' }

            foreach ($urlPUTPath in $urlPUTPathsInFile) {

                # Todo create regex dynamic based on count of '/' in RT
                # Build regex based in input
                $formattedProviderNamespace =  $ProviderNamespace -replace '\.', '\.'
                if(($ResourceType -split '/').Count -gt 1) {
                    # Provided a concatinated resource type like 'vaults/secrets'
                    $resourceTypeElements = $ResourceType -split '/'
                    $relevantPathRegex = ".*\/$formattedProviderNamespace\/"
                    # Add each element and incorporate a theoretical 'name' in the path as it is part of each url (e.g. vaults/{vaultName}/keys/{keyName})
                    # '?' is introduced for urls where a hardcoded name (like 'default') is part of it
                    $relevantPathRegex += $resourceTypeElements -join '\/\{?\w+}?\/'
                    $relevantPathRegex += '.*'
                } else {
                    $relevantPathRegex = ".*\/{0}\/{1}\/.*" -f $formattedProviderNamespace, $ResourceType
                }

                # Filter down to Provider Namespace & Resource Type (or children)
                if($urlPUTPath -notmatch $relevantPathRegex) {
                    Write-Debug "Ignoring Path PUT URL [$urlPUTPath]"
                    continue
                }

                # Populate result
                $pathData += @{
                    urlPath      = $urlPUTPath
                    jsonFilePath = $specFilePath
                }
            }
        }
    }

    # Add parent pointers for later reference
    foreach($urlPathBlock in $pathData) {
        $pathElements = $urlPathBlock.urlPath -split '/'
        $rawparentUrlPath = $pathElements[0..($pathElements.Count-3)] -join '/'

        if($pathElements[-3] -like "Microsoft.*") {
            # Top-most element. No parent
            $parentUrlPath = ''
        }
        elseif($rawparentUrlPath -notlike "*}") {
            # Special case: Parent has a default value in url (e.g. 'default'). In this case we need to find a match in the other urls
            $shortenedRef = $pathElements[0..($pathElements.Count-4)] -join '/'
            $formattedRef =  [regex]::Escape($shortenedRef) -replace '\/', '\/'
            $parentUrlPath = $pathData.urlPath | Where-Object { $_ -match "^$formattedRef\/\{\w+\}$"}
        } else {
            $parentUrlPath = $rawparentUrlPath
        }

        $urlPathBlock['parentUrlPath'] = $parentUrlPath
    }

    return $pathData
} 