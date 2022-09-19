function Get-ModuleDataRestApiSpecs {

    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [bool] $IgnorePreview = $true
    )

    $initialLocation = (Get-Location).Path
    $repoUrl = 'https://github.com/Azure/azure-rest-api-specs.git'
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
    $resourceProviderFolder = Join-Path $tempFolderPath $repoName 'specification' $shortenedProviderNamespace 'resource-manager' $ProviderNamespace

    # TODO: Get highest API version (preview/non-preview)
    $latestApiFolder = (Get-ChildItem -Path $(Join-Path $resourceProviderFolder 'stable') | Sort-Object -Descending)[0]

    ## Remove temp folder again
    # $null = Remove-Item $tempFolderPath -Recurse -Force
    Set-Location $initialLocation
}

Get-ModuleDataRestApiSpecs -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'
