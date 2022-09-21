function FilterParameters ($putObj, $definitions) {
    # TODO: recheck params
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
    # TODO: check why ref is null here
    Param($params)
    $ref = $params[0]
    $definitions = $params[1]
    $refDef = Split-Path $ref -LeafBase
    if ($refDef -notin $definitions) {
        throw 'ref is not contained in definition'
    } else {
        #TODO: strip $definitions.$refDef and return
    }
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
                $definitions = (ConvertFrom-Json (Get-Content -Raw -Path $jsonFile)).definitions

                $jsonPaths.PSObject.Properties | ForEach-Object {
                    $put = $_.value.put
                    # if ($_.Name -contains $ResourceType) {
                    #     Write-Verbose ('File: [{0}], API: [{1}] JsonKeyPath: [{2}]' -f $jsonFile.Name, $apiversionFolder.Name, $_.Name) -Verbose
                    # }
                    if ($put) {
                        $pathSplit = $_.Name.Split('/')
                        if (($pathSplit[$pathSplit.Count - 3] -eq $ProviderNamespace) -and ($pathSplit[$pathSplit.Count - 2] -eq $ResourceType)) {
                            $arrItem = [pscustomobject] @{}
                            $arrItem | Add-Member -MemberType NoteProperty -Name 'jsonFilePath' -Value $jsonFile.FullName
                            $arrItem | Add-Member -MemberType NoteProperty -Name 'jsonKeyPath' -Value $_.Name
                            # $arrItem | Add-Member -MemberType NoteProperty -Name 'putMethod' -Value $_.value.put

                            # add nested parameters
                            $paramObj = FilterParameters($put, $definitions)
                            # $arrItem | Add-Member -MemberType NoteProperty -Name 'parameters' -Value $paramObj

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

# Get-ModuleDataRestApiSpecs -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'

# Example call for further processing
$result = Get-ModuleDataSource -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults' -IgnorePreview $false | Format-List
$result | Format-List

# Kris: the below code is for debugging only and will be deleted later.
## It is commented out and doesn't run, so it can be ignored

# test function calls
# working calls
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults' -IgnorePreview $false | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Batch' -ResourceType 'batchAccounts' | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Network' -ResourceType 'virtualNetworks' | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Network' -ResourceType 'networkSecurityGroups' | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.CognitiveServices' -ResourceType 'accounts' | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Network' -ResourceType 'applicationGateways' | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Network' -ResourceType 'bastionHosts' | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Network' -ResourceType 'azureFirewalls' | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Sql' -ResourceType 'servers' | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Sql' -ResourceType 'managedInstances' | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.RecoveryServices' -ResourceType 'vaults' | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.AnalysisServices' -ResourceType 'servers' | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'roleAssignments' -IgnorePreview $true | Format-List # no results, special case
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'roleDefinitions' -IgnorePreview $true | Format-List # no results, special case
# repaired calls
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Automation' -ResourceType 'automationAccounts' | Format-List # no results
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Management' -ResourceType 'managementGroups' | Format-List

# not working calls
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Compute' -ResourceType 'virtualMachines' # provider folder structure
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Resources' -ResourceType 'resourceGroups' -IgnorePreview $false | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.ManagedIdentity' -ResourceType 'userAssignedIdentities' -IgnorePreview $false  | Format-List
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.AAD' -ResourceType 'DomainServices' -IgnorePreview $false  | Format-List # provider folder not found
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'locks' -IgnorePreview $false | Format-List # no results, special case
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'policyAssignments' -IgnorePreview $true | Format-List # no results, more than one provider folder, exists in the second folder (to be verified)
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Cache' -ResourceType 'redis' -IgnorePreview $false | Format-List # provider folder not found
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.DBforPostgreSQL' -ResourceType 'flexibleServers' -IgnorePreview $false | Format-List # different provider folder name
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.DocumentDB' -ResourceType 'databaseAccounts' -IgnorePreview $false | Format-List # different provider folder name
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.Insights' -ResourceType 'actionGroups' -IgnorePreview | Format-List $false
# Get-ModuleDataSource -ProviderNamespace 'Microsoft.OperationsManagement' -ResourceType 'solutions' -IgnorePreview $false | Format-List

# running the function against the CARML modules folder
# to collect some statistics.
# It requires some modifications of the function Get-ModuleDataSource, so please don't use it.
# below code is temporary and will be deleted later
exit # protecting from unnecessary run
$carmlModulesRoot = Join-Path $PSScriptRoot '..' '..' '..' 'modules'
$resArray = @()
foreach ($providerFolder in $(Get-ChildItem -Path $carmlModulesRoot -Filter 'Microsoft.*')) {
    foreach ($resourceFolder in $(Get-ChildItem -Path $(Join-Path $carmlModulesRoot $providerFolder.Name) -Directory)) {
        Write-Host ('Processing [{0}/{1}]...' -f $providerFolder.Name, $resourceFolder.Name)
        $res = Get-ModuleDataSource -ProviderNamespace $providerFolder.Name -ResourceType $resourceFolder.Name -IgnorePreview $false
        # Get-ModuleDataSource -ProviderNamespace $providerFolder.Name -ResourceType $resourceFolder.Name

        $resArrItem = [pscustomobject] @{}
        $resArrItem | Add-Member -MemberType NoteProperty -Name 'Provider' -Value $providerFolder.Name
        $resArrItem | Add-Member -MemberType NoteProperty -Name 'ResourceType' -Value $resourceFolder.Name
        $resArrItem | Add-Member -MemberType NoteProperty -Name 'Result' -Value $res
        $resArray += $resArrItem
    }
}



# statistics

$count = $resArray.Count
$resArray | ConvertTo-Json -Depth 99
$numberErrRepo = ($resArray | Where-Object { $_.Result -eq -1 }).Count
$numberErrResourceType = ($resArray | Where-Object { $_.Result -eq -2 }).Count
$numberNoResults = ($resArray | Where-Object { $_.Result -eq 0 }).Count
$numberOK = ($resArray | Where-Object { $_.Result -eq 1 }).Count
$numberTooMuch = ($resArray | Where-Object { $_.Result -gt 1 }).Count

Write-Host ('Too much: {0} of {1}' -f ((($resArray | Where-Object { $_.Result -gt 1 }).Count), $count ))
Write-Host ('Successful: {0}' -f ((($resArray | Where-Object { $_.Result -eq 1 }).Count)))
Write-Host ('No Results: {0}' -f ((($resArray | Where-Object { $_.Result -eq 0 }).Count)))
Write-Host ('Repo Error: {0}' -f ((($resArray | Where-Object { $_.Result -eq -1 }).Count)))
Write-Host ('RT Error  : {0}' -f ((($resArray | Where-Object { $_.Result -eq -2 }).Count)))


