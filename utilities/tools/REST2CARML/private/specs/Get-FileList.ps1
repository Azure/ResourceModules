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
        [bool] $IgnorePreview = $true
    )

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
    if ($IgnorePreview) {
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
