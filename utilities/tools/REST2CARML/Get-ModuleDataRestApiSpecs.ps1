function FilterPutPaths {
    Param($params)
    $putObj = $params[0]
    $definitions = $params[1]
    $obj = {}
    $putObj.parameters | ForEach-Object {
        if ($_.name -eq 'parameters') {
            $newObj = Get-NestedParams($_.schema.$ref, $definitions)
            # $obj | Add-Member -MemberType NoteProperty -Name $newObj.name -Value $newObj
        } elseif ($null -ne $_.name) {
            $paramItem = [PSCustomObject]@{
                name        = $_.name
                type        = $_.type
                description = $_.description
            }

            $obj | Add-Member -MemberType NoteProperty -Name $paramItem.name -Value $paramItem
        } elseif ($null -ne $_.$ref) {
            $newObj = Get-NestedParams($_.$ref, $definitions)
            # $obj | Add-Member -MemberType NoteProperty -Name $newObj.name -Value $newObj
        }

    }
    return $obj
}

function Get-NestedParams {
    # check why ref is null here
    Param($params)
    $ref = $params[0]
    $definitions = $params[1]
    $refDef = Split-Path $ref -LeafBase
    if ($refDef -notin $definitions) {
        throw 'ref is not contained in definition'
    } else {
        # strip $definitions.$refDef and return
    }
}

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

    $putMethods = @()
    foreach ($jsonFile in $(Get-ChildItem -Path $latestApiFolder -Filter *.json)) {
        $jsonPaths = (ConvertFrom-Json (Get-Content -Raw -Path $jsonFile)).paths

        $jsonPaths.PSObject.Properties | ForEach-Object {
            $put = $_.value.put
            $definitions = (ConvertFrom-Json (Get-Content -Raw -Path $jsonFile)).definitions

            if ($put) {
                $arrItem = [pscustomobject] @{}
                $arrItem | Add-Member -MemberType NoteProperty -Name 'jsonFile' -Value $jsonFile.Name
                $arrItem | Add-Member -MemberType NoteProperty -Name 'path' -Value $_.Name
                # $arrItem | Add-Member -MemberType NoteProperty -Name 'putMethod' -Value $_.value.put

                $filteredObj = FilterPutPaths($put, $definitions)
                $arrItem | Add-Member -MemberType NoteProperty -Name 'properties' -Value $filteredObj

                $putMethods += $arrItem
            }
        }
    }

    $putMethods | ConvertTo-Json

    ## process file


    ## Remove temp folder again
    # $null = Remove-Item $tempFolderPath -Recurse -Force
    Set-Location $initialLocation
}


Get-ModuleDataRestApiSpecs -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'
