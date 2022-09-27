function compare-versions {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Object] $versionName,

        [Parameter(Mandatory)]
        [string] $currentHighestVersion
    )

    ## Need to account for '-prelease' in version names

    if ($versionName.name.lastIndexof('-') -eq -1) {
        $rightMostInt = [int]$currentHighestVersion.Substring($($currentHighestVersion.lastIndexof('.') + 1), $($currentHighestVersion.length - $($currentHighestVersion.lastIndexof('.') + 1)))

        if ([int]$($versionName.name.Substring($($versionName.name.lastIndexof('.') + 1), $($versionName.name.length - $($versionName.name.lastIndexof('.') + 1)))) -gt $rightMostInt) {
            $LatestVersion = $versionName.name
            return $LatestVersion
        }
    }
    return $currentHighestVersion
}
$registryRepositoryList = $(az acr repository list --name 'adpsxxazacrx001' --output tsv)

$moduleVersionArray = @()
foreach ($module in $registryRepositoryList) {
    $tempVersion = '0'
    $getVersion = $($(az acr repository show-tags --repository $module --name adpsxxazacrx001 --orderby time_desc --top 10 --detail) | ConvertFrom-Json | Select-Object digest, name)
    foreach ($moduleVersion in $getVersion) {
        if ($moduleVersion.name -eq '0') {
            foreach ($moduleVersionDetail in $getVersion) {
                if ($moduleVersionDetail.digest -eq $moduleVersion.digest) {
                    $tempVersion = $(compare-versions $moduleVersionDetail $tempVersion)
                }
            }
            $newModuleObject = [PSCustomObject]@{
                Module  = $module
                Version = $tempVersion
            }
            Write-Output $('Module: {0} -- Version: {1}' -f $module, $tempVersion)
            $moduleVersionArray += $newModuleObject
        }
    }
}

Write-Output $moduleVersionHash
