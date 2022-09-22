function Get-ResourceProviderFolders {
    param (
        [Parameter(Mandatory = $true)]
        [string] $rootFolder,

        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType
    )
    try {
        #find the resource provider folder
        $resourceProviderFolderSearchResults = Get-ChildItem -Path $rootFolder -Directory -Recurse -Depth 4 | Where-Object { $_.Name -eq $ProviderNamespace -and $_.Parent.Name -eq 'resource-manager' }
        return $resourceProviderFolderSearchResults | ForEach-Object { "$($_.FullName)" }

    } catch {
        Write-Error 'Error detecting provider folder'
    }

}

function Get-ServiceSpecPathData {

    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [switch] $IncludePreview
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

    try {
        #find the resource provider folder
        $resourceProviderFolders = Get-ResourceProviderFolders -rootFolder $(Join-Path $tempFolderPath $repoName 'specification') -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType

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
                throw ('No API folder found in folder [{0}]' -f $resourceProviderFolder)

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
# $result = Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults' -IncludePreview $true | Format-List
# $result | Format-List

# Kris: the below code is for debugging only and will be deleted later.
## It is commented out and doesn't run, so it can be ignored

# test function calls
# working calls
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults' -IncludePreview $true | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Batch' -ResourceType 'batchAccounts' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Network' -ResourceType 'virtualNetworks' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Network' -ResourceType 'networkSecurityGroups' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.CognitiveServices' -ResourceType 'accounts' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Network' -ResourceType 'applicationGateways' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Network' -ResourceType 'bastionHosts' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Network' -ResourceType 'azureFirewalls' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Sql' -ResourceType 'servers' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Sql' -ResourceType 'managedInstances' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.RecoveryServices' -ResourceType 'vaults' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.AnalysisServices' -ResourceType 'servers' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'roleAssignments' -IncludePreview $false | Format-List # no results, special case
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'roleDefinitions' -IncludePreview $false | Format-List # no results, special case
# repaired calls
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Automation' -ResourceType 'automationAccounts' | Format-List # no results
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Management' -ResourceType 'managementGroups' | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.AAD' -ResourceType 'DomainServices' -IncludePreview $true | Format-List # provider folder not found
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'policyAssignments' -IncludePreview $false | Format-List # no results, more than one provider folder, exists in the second folder (to be verified)
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.DocumentDB' -ResourceType 'databaseAccounts' -IncludePreview $true | Format-List # different provider folder name
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.OperationsManagement' -ResourceType 'solutions' -IncludePreview $true | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.ManagedIdentity' -ResourceType 'userAssignedIdentities' -IncludePreview $true | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.DBforPostgreSQL' -ResourceType 'flexibleServers' -IncludePreview $true | Format-List # different provider folder name
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'policyDefinitions' -IncludePreview $false | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'policySetDefinitions' -IncludePreview $false | Format-List
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Cache' -ResourceType 'redis' -IncludePreview $false | Format-List # provider folder not found
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Authorization' -ResourceType 'locks' -IncludePreview $false | Format-List # no results, special case
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Insights' -ResourceType 'actionGroups' -IncludePreview $false | Format-List

# not working calls
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Compute' -ResourceType 'virtualMachines' # provider folder structure
# Get-ServiceSpecPathData -ProviderNamespace 'Microsoft.Resources' -ResourceType 'resourceGroups' -IncludePreview $false | Format-List

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
#         $res = Get-ServiceSpecPathData -ProviderNamespace $providerFolder.Name -ResourceType $resourceFolder.Name -IncludePreview $false
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


