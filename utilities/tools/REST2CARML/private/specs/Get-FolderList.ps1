function Get-FolderList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $rootFolder,

        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace
    )

    $allFolderPaths = (Get-ChildItem -Path $rootFolder -Recurse -Directory).FullName
    Write-Verbose ('Fetched all [{0}] folder paths. Filtering...' -f $allFolderPaths.Count)
    # Filter
    $filteredFolderPaths = $allFolderPaths | Where-Object {
        ($_ -replace '\\', '/') -like '*/resource-manager/*'
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
