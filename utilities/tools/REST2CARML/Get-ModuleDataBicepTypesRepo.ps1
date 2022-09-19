function Get-ModuleDataBicepTypesRepo {

    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [bool] $IgnorePreview = $true
    )

    $initialLocation = (Get-Location).Path
    $repoUrl = 'https://github.com/Azure/bicep-types-az.git'
    $repoName = Split-Path $repoUrl -LeafBase
    $tempFolderName = 'temp'
    $tempFolderPath = Join-Path $PSScriptRoot $tempFolderName

    # Clone repository
    ## Create temp folder
    if (-not (Test-Path $tempFolderPath)) {
        $null = New-Item -Path $tempFolderPath -ItemType 'Directory'
    }
    ## Switch to temp folder
    Set-Location $tempFolderPath

    ## Clone repository into temp folder
    if (-not (Test-Path (Join-Path $tempFolderPath $repoName))) {
        git clone $repoUrl
    } else {
        Write-Verbose "Repository [$repoName] already cloned" -Verbose
    }

    # Process repository
    $shortenedProviderNamespace = ($ProviderNamespace -split '\.')[1].ToLower()
    $resourceProviderFolder = Join-Path $tempFolderPath $repoName 'generated' $shortenedProviderNamespace $ProviderNamespace.ToLower()

    # TODO: Get highest API version (preview/non-preview)
    $apiVersionPaths = (Get-ChildItem $resourceProviderFolder).FullName | Sort-Object
    if ($IgnorePreview) {
        $apiVersionPaths = $apiVersionPaths | Where-Object { $_ -notmatch '-preview$' }
    }
    $latestAPIVersionPath = $apiVersionPaths[-1]

    $typesMarkdownPath = Join-Path $latestAPIVersionPath 'types.md'
    $typesMarkdownContent = Get-Content -Path $typesMarkdownPath

    # Find resource start (not yet working)
    $regexString = (('## Resource {0}/{1}@{2}' -f $ProviderNamespace, $ResourceType, (Split-Path $latestAPIVersionPath -Leaf)) -replace '\.', '\.') -replace '/', '\/'
    $startingIndex = [array]::IndexOf($typesMarkdownContent, $regexString)

    # Get properties & split accordingly (e.g. name : type : description) + jump recursively to correct child references

    ## Remove temp folder again
    $null = Remove-Item $tempFolderPath -Recurse -Force
    Set-Location $initialLocation
}
Get-ModuleDataBicepTypesRepo -ProviderNamespace 'Microsoft.Storage' -ResourceType 'storageAccounts'
