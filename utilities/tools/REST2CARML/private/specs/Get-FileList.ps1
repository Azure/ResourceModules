<#
.SYNOPSIS
Get a list of all API Spec files that are relevant for the given Provider Namespace & Resource Type.

.DESCRIPTION
Get a list of all API Spec files that are relevant for the given Provider Namespace & Resource Type.

Paths must contain:
- ProviderNamespace
- Resource-Manager
- API version
- Speicication JSON file
- Preview (if configured)


Paths must NOT contain
- Examples

.PARAMETER RootFolder
Mandatory. The root folder to search from (recursively).

.PARAMETER ProviderNamespace
Mandatory. The ProviderNsmespace to filter for.

.PARAMETER ResourceType
Mandatory. The ResourceType to filter for.

.PARAMETER IncludePreview
Optional. Consider preview versions

.EXAMPLE
Get-FileList -RootFolder './temp/azure-rest-api-specs/specification' -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'

Get the API spec files for [Microsoft.KeyVault/vaults].
#>
function Get-FileList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $rootFolder,

        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [switch] $IncludePreview
    )

    # TODO: Is this file intended to be used anywhere?

    $allFilePaths = (Get-ChildItem -Path $rootFolder -Recurse -File).FullName
    Write-Verbose ('Fetched all [{0}] file paths. Filtering...' -f $allFilePaths.Count) -Verbose
    # Filter
    $filteredFilePaths = $allFilePaths | Where-Object {
        ($_ -replace '\\', '/') -like '*/resource-manager/*'
    }
    $filteredFilePaths = $filteredFilePaths | Where-Object {
        ($_ -replace '\\', '/') -notlike '*/examples/*'
    }
    $filteredFilePaths = $filteredFilePaths | Where-Object {
        ($_ -replace '\\', '/') -like "*/$ProviderNamespace/*"
    }
    if (-not $IncludePreview) {
        $filteredFilePaths = $filteredFilePaths | Where-Object {
            ($_ -replace '\\', '/') -notlike '*/preview/*'
        }
    }
    $filteredFilePaths = $filteredFilePaths | Where-Object {
        ($_ -replace '\\', '/') -like ('*/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]*/*.json')
    }
    $filteredFilePaths = $filteredFilePaths | Where-Object {
        ($_ -replace '\\', '/') -like ('*/*.json')
    }
    if (-not $filteredFilePaths) {
        Write-Warning "No files found for resource type [$ProviderNamespace/$ResourceType]"
        return $filteredFilePaths
    }
    Write-Verbose ('Filtered down to [{0}] files.' -f $filteredFilePaths.Length) -Verbose
    return $filteredFilePaths | Sort-Object
}
