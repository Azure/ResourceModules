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

    try {
        #find the resource provider folder
        $resourceProviderFolders = Get-FolderList -rootFolder (Join-Path $RepositoryPath 'specification') -ProviderNamespace $ProviderNamespace

        $resultArr = @()
        foreach ($resourceProviderFolder in $resourceProviderFolders) {
            Write-Verbose ('Processing Resource provider folder [{0}]' -f $resourceProviderFolder)
            # TODO: Get highest API version (preview/non-preview)
            $apiVersionFoldersArr = @()
            if (Test-Path -Path $(Join-Path $resourceProviderFolder 'stable')) { $apiVersionFoldersArr += Get-ChildItem -Path $(Join-Path $resourceProviderFolder 'stable') }
            if ($IncludePreview) {
                # adding preview API versions if allowed
                if (Test-Path -Path $(Join-Path $resourceProviderFolder 'preview')) { $apiVersionFoldersArr += Get-ChildItem -Path $(Join-Path $resourceProviderFolder 'preview') }
            }

            # sorting all API version from the newest to the oldest
            $apiVersionFoldersArr = $apiVersionFoldersArr | Sort-Object -Property Name -Descending
            if ($apiVersionFoldersArr.Count -eq 0) {
                Write-Warning ('No API folder found in folder [{0}]' -f $resourceProviderFolder)
                continue
            }

            foreach ($apiversionFolder in $apiVersionFoldersArr) {
                $putMethods = @()
                foreach ($jsonFile in $(Get-ChildItem -Path $apiversionFolder -Filter *.json)) {
                    $jsonPaths = (ConvertFrom-Json (Get-Content -Raw -Path $jsonFile)).paths
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
                                $putMethods += $arrItem
                            }
                        }
                    }
                }
                if ($putMethods.Count -gt 0) { break } # no scanning of older API folders if a put method already found
            }
            $resultArr += $putMethods # adding result of this provider folder to the overall result array
        }
    } catch {
        Write-Error "Error processing [$ProviderNamespace/$ResourceType]: $_"
        return -2
    }

    try {
        Set-Location $initialLocation

        ## Remove temp folder again
        # $null = Remove-Item $tempFolderPath -Recurse -Force

        if ($resultArr.Count -ge 1) {
            return $resultArr
        } else {
            Write-Error 'No results found'
            return $resultArr
        }

    } catch {
        Write-Error "Error processing [$ProviderNamespace/$ResourceType]: $_"
        return -2
    }
}

# Example call for further processing
# $result = Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults' | Format-List
# $result | Format-List

# Kris: the below code is for debugging only and will be deleted later.
## It is commented out and doesn't run, so it can be ignored

# test function calls
# two examples of working calls for testing
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Storage' -ResourceType 'storageAccounts' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Compute' -ResourceType 'virtualMachines' | Format-List

# working, multiple results
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'locks' | Format-List # no results, special case
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'policyDefinitions' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'policySetDefinitions' | Format-List

# no results (different ResourceId schema, to be repaired)
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Resources' -ResourceType 'resourceGroups' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Security' -ResourceType 'azureSecurityCenter' | Format-List

# working with preview only
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'policyExemptions' -IncludePreview | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Insights' -ResourceType 'privateLinkScopes' -IncludePreview | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.OperationsManagement' -ResourceType 'solutions' -IncludePreview | Format-List

# working. If run without preview, returning one result, with preview: four results
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Insights' -ResourceType 'diagnosticSettings' -IncludePreview | Format-List



# running the function against the CARML modules folder
# to collect some statistics.
# It requires some modifications of the function Get-ServiceSpecPathData, so please don't use it.
# below code is temporary and will be deleted later
# exit # protecting from unnecessary run
# $carmlModulesRoot = Join-Path $PSScriptRoot '..' '..' '..' 'modules'
# $resArray = @()
# foreach ($providerFolder in $(Get-ChildItem -Path $carmlModulesRoot -Filter 'Microsoft.*')) {
#     foreach ($resourceFolder in $(Get-ChildItem -Path $(Join-Path $carmlModulesRoot $providerFolder.Name) -Directory)) {
#         Write-Host ('Processing [{0}/{1}]...' -f $providerFolder.Name, $resourceFolder.Name)
#         $res = Get-ServiceSpecPathData -ProviderNamespace $providerFolder.Name -ResourceType $resourceFolder.Name -IncludePreview
#         # Get-ServiceSpecPathData -ProviderNamespace $providerFolder.Name -ResourceType $resourceFolder.Name

#         $resArrItem = [pscustomobject] @{}
#         $resArrItem | Add-Member -MemberType NoteProperty -Name 'Provider' -Value $providerFolder.Name
#         $resArrItem | Add-Member -MemberType NoteProperty -Name 'ResourceType' -Value $resourceFolder.Name
#         if ($null -eq $res) {
#             $resArrItem | Add-Member -MemberType NoteProperty -Name 'Result' -Value 0
#         } elseif ($res -is [array]) {
#             $resArrItem | Add-Member -MemberType NoteProperty -Name 'Result' -Value $res.Count
#         } elseif ($res.GetType().Name -eq 'pscustomobject') {
#             $resArrItem | Add-Member -MemberType NoteProperty -Name 'Result' -Value 1
#         } else {
#             $resArrItem | Add-Member -MemberType NoteProperty -Name 'Result' -Value $res
#         }
#         $resArray += $resArrItem
#     }
# }



# # statistics

# $count = $resArray.Count
# $resArray | ConvertTo-Json -Depth 99

# Write-Host ('Success, more than one result: {0} of {1}' -f ((($resArray | Where-Object { $_.Result -gt 1 }).Count), $count ))
# Write-Host ('Success, one result: {0} of {1}' -f ((($resArray | Where-Object { $_.Result -eq 1 }).Count), $count))
# Write-Host ('No Results: {0} of {1}' -f ((($resArray | Where-Object { $_.Result -eq 0 }).Count), $count))
# Write-Host ('RT Error  : {0} of {1}' -f ((($resArray | Where-Object { $_.Result -eq -2 }).Count), $count))


