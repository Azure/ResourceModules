<#
.SYNOPSIS
Get a list of all API Spec folders that are relevant for the given Provider Namespace.

.DESCRIPTION
Get a list of all API Spec folders that are relevant for the given Provider Namespace.

Paths must contain:
- ProviderNamespace
- Resource-Manager
- Stable or Preview

Paths must NOT contain
- Examples

.PARAMETER RootFolder
Mandatory. The root folder to search from (recursively).

.PARAMETER ProviderNamespace
Mandatory. The ProviderNsmespace to filter for.

.EXAMPLE
Get-FolderList -RootFolder './temp/azure-rest-api-specs/specification' -ProviderNamespace 'Microsoft.KeyVault'

Get all folders of the 'Microsoft.KeyVault' provider namespace that exist in the 'specifications' folder
#>
function Get-FolderList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $RootFolder,

        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace
    )

    $allFolderPaths = (Get-ChildItem -Path $RootFolder -Recurse -Directory).FullName
    Write-Verbose ('Fetched all [{0}] folder paths. Filtering...' -f $allFolderPaths.Count)
    # Filter
    $filteredFolderPaths = $allFolderPaths | Where-Object {
        ($_ -replace '\\', '/') -like '*/resource-manager/*'
    }
    $filteredFilePaths = $filteredFilePaths | Where-Object {
        ($_ -replace '\\', '/') -notlike '*/examples/*'
    }
    $filteredFolderPaths = $filteredFolderPaths | Where-Object {
        ($_ -replace '\\', '/') -like "*/$ProviderNamespace/*"
    }
    $filteredFolderPaths = $filteredFolderPaths | Where-Object {
        (($_ -replace '\\', '/') -like '*/stable') -or (($_ -replace '\\', '/') -like '*/preview')
    }

    $filteredFolderPaths = $filteredFolderPaths | ForEach-Object { Split-Path -Path $_ -Parent }
    $filteredFolderPaths = $filteredFolderPaths | Select-Object -Unique

    if (-not $filteredFolderPaths) {
        Write-Warning "No folders found for provider namespace [$ProviderNamespace]"
        return $filteredFolderPaths
    }

    Write-Verbose ('Filtered down to [{0}] folders.' -f $filteredFolderPaths.Length)
    return $filteredFolderPaths | Sort-Object
}
