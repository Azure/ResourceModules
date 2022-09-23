function Get-ServiceSpecPathDataChildRes {

    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [switch] $IncludePreview,

        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath,

        [Parameter(Mandatory = $true)]
        [string] $JSONKeyPath
    )

    try {
        # $DebugPreference = 'Continue'
        $resultArr = @()
        $parentPathSplit = $JSONKeyPath.Split('/')
        foreach ($jsonFile in $(Get-ChildItem -Path $(Split-Path $JSONFilePath -Parent) -Filter *.json)) {
            Write-Debug ('Processing [{0}]...' -f $jsonFile.Name)
            $jsonPaths = (ConvertFrom-Json (Get-Content -Raw -Path $jsonFile)).paths
            $jsonPaths.PSObject.Properties | ForEach-Object {
                $put = $_.value.put
                if ($put) {
                    $pathSplit = $_.Name.Split('/')
                    if (($_.Name -like "$JSONKeyPath/*") -and ($pathSplit.Count -gt $parentPathSplit.Count)) {
                        $arrItem = [pscustomobject] @{}
                        $arrItem | Add-Member -MemberType NoteProperty -Name 'jsonFilePath' -Value $jsonFile.FullName
                        $arrItem | Add-Member -MemberType NoteProperty -Name 'jsonKeyPath' -Value $_.Name
                        # $arrItem | Add-Member -MemberType NoteProperty -Name 'putMethod' -Value $_.value.put
                        $resultArr += $arrItem
                    }
                }
            }
        }
    } catch {
        Write-Error "Error processing [$ProviderNamespace/$ResourceType]: $_"
        return -2
    }

    try {
        if ($resultArr.Count -ge 1) {
            return $resultArr
        } else {
            Write-Warning 'No child resources found'
            return $resultArr
        }

    } catch {
        Write-Error "Error processing [$ProviderNamespace/$ResourceType]: $_"
        return -2
    }
}

# . (Join-Path $PSScriptRoot 'Get-ServiceSpecPathData.ps1')

# # $providerNamespace = 'Microsoft.Storage'; $resourceType = 'storageAccounts'
# # $providerNamespace = 'Microsoft.KeyVault'; $resourceType = 'vaults'
# # $providerNamespace = 'Microsoft.Compute'; $resourceType = 'virtualMachines'
# $providerNamespace = 'Microsoft.Network'; $resourceType = 'virtualNetworks'

# $parentResData = Get-ServiceSpecPathData -ProviderNamespace $providerNamespace -ResourceType $resourceType

# Write-Host 'Parent resource data:'
# $parentResData | Format-List

# $childResData = Get-ServiceSpecPathDataChildRes -ProviderNamespace $providerNamespace -ResourceType $resourceType -JSONFilePath $parentResData.JSONFilePath -JSONKeyPath $parentResData.JSONKeyPath

# Write-Host 'Child resource data:'
# $childResData | Format-List

