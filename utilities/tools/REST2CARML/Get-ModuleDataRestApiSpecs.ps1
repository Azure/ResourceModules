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


function Get-ModuleDataSource {

    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [bool] $IgnorePreview = $true
    )

    # prepare the repo
    try {
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
            Write-Verbose "Repository [$repoName] already cloned"
        }
    } catch {
        throw "Repo preparation failed: $_"
    }

    #find the resource provider folder
    # Process repository
    $shortenedProviderNamespace = ($ProviderNamespace -split '\.')[1].ToLower()
    $resourceProviderFolder = Join-Path $tempFolderPath $repoName 'specification' $shortenedProviderNamespace 'resource-manager' $ProviderNamespace
    if (-not (Test-Path $resourceProviderFolder)) {
        $resourceProviderFolderSearchResults = Get-ChildItem -Path $specifications -Directory -Recurse -Depth 3 | Where-Object { $_.Name -eq $ProviderNamespace -and $_.Parent.Name -eq 'resource-manager' }
        switch ($resourceProviderFolderSearchResults.Count) {
            { $_ -eq 0 } { throw ('Resource provider folder [{0}] not found' -f $ProviderNamespace); break }
            { $_ -ge 1 } { $resourceProviderFolder = $resourceProviderFolderSearchResults[0].FullName }
            { $_ -gt 1 } {
                Write-Warning ('Other folder(s) with the name [{0}] found.' -f $ProviderNamespace)
                for ($i = 1; $i -lt $resourceProviderFolderSearchResults.Count; $i++) {
                    Write-Warning ('  {0}' -f $resourceProviderFolderSearchResults[$i].FullName)
                }
                break
            }
            Default {}
        }
    }
    Write-Verbose ('Processing Resource provider folder [{0}]' -f $resourceProviderFolder) -Verbose

    try {
        # TODO: Get highest API version (preview/non-preview)
        $apiVersionFoldersArr = @()
        if (Test-Path -Path $(Join-Path $resourceProviderFolder 'stable')) { $apiVersionFoldersArr += Get-ChildItem -Path $(Join-Path $resourceProviderFolder 'stable') }
        if (-not $IgnorePreview) {
            # adding preview API versions if allowed
            if (Test-Path -Path $(Join-Path $resourceProviderFolder 'preview')) { $apiVersionFoldersArr += Get-ChildItem -Path $(Join-Path $resourceProviderFolder 'preview') }
        }

        # sorting all API version from the newest to the oldest
        $apiVersionFoldersArr = $apiVersionFoldersArr | Sort-Object -Property Name -Descending
        if ($apiVersionFoldersArr.Count -eq 0) {
            throw ('No API folder found in folder [{0}]' -f $resourceProviderFolder)
        }

        foreach ($apiversionFolder in $apiVersionFoldersArr) {
            $putMethods = @()
            foreach ($jsonFile in $(Get-ChildItem -Path $apiversionFolder -Filter *.json)) {
                $jsonPaths = (ConvertFrom-Json (Get-Content -Raw -Path $jsonFile)).paths
                $jsonPaths.PSObject.Properties | ForEach-Object {
                    $put = $_.value.put
                    if ($put) {
                        $pathSplit = $_.Name.Split('/')
                        if (($pathSplit[$pathSplit.Count - 3] -eq $ProviderNamespace) -and ($pathSplit[$pathSplit.Count - 2] -eq $ResourceType)) {
                            $arrItem = [pscustomobject] @{}
                            $arrItem | Add-Member -MemberType NoteProperty -Name 'jsonFilePath' -Value $jsonFile.FullName
                            $arrItem | Add-Member -MemberType NoteProperty -Name 'jsonKeyPath' -Value $_.Name
                            # $arrItem | Add-Member -MemberType NoteProperty -Name 'putMethod' -Value $_.value.put
                            $putMethods += $arrItem
                        }
                    }
                }
            }
            if ($putMethods.Count -gt 0) { break }
        }


        Set-Location $initialLocation

        ## Remove temp folder again
        # $null = Remove-Item $tempFolderPath -Recurse -Force

        if ($putMethods.Count -eq 1) {
            # return 1
            return $putMethods[0]
        } elseif ($putMethods.Count -gt 1) {
            # return $putMethods.Count
            Write-Error 'Found too many matching results'
        } else {
            # return 0
            Write-Error 'No results found'
        }

    } catch {
        # return -2
        Write-Error "Error processing [$ProviderNamespace/$ResourceType]: $_"
    }
}

Get-ModuleDataRestApiSpecs -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'

Get-ModuleDataSource -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults' | Format-List

