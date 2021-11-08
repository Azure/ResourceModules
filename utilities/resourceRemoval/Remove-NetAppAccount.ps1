<#
.SYNOPSIS
Remove a Azure NetApp files resource with a tag { removeModule = $moduleName }

.DESCRIPTION
Remove a Azure NetApp files resource with a tag { removeModule = $moduleName }


.PARAMETER moduleName
Optional. The name of the module to remove

.PARAMETER ResourceGroupName
Optional. The resourceGroup of the module to remove

.PARAMETER tagSearchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag

.PARAMETER tagSearchRetryInterval
Optional. The time to wait in between the search for resources via their remove tags

.EXAMPLE
Remove-vWan

Remove a virtual WAN with tag { 'removeModule' = 'netAppAccounts' } from resource group 'validation-rg'
#>
function Remove-NetAppAccount {

    [Cmdletbinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false)]
        [string] $moduleName = 'netAppAccounts',

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName = 'validation-rg',

        [Parameter(Mandatory = $false)]
        [int] $tagSearchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $tagSearchRetryInterval = 15
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path $PSScriptRoot 'helper/Remove-Resource.ps1')
    }

    process {
        # Identify resources
        # ------------------
        $tagSearchRetryCount = 1
        while (-not ($netAppFilesAccount = Get-AzResource -Tag @{ removeModule = $moduleName } -ResourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue') -and $tagSearchRetryCount -le $tagSearchRetryLimit) {
            Write-Verbose ('Did not to find resources by tags [removeModule={0}] in resource group [{1}]. Retrying in [{2} seconds] [{3}/{4}]' -f $moduleName, $resourceGroupName, $tagSearchRetryInterval, $tagSearchRetryCount, $tagSearchRetryLimit)
            Start-Sleep $tagSearchRetryInterval
            $tagSearchRetryCount++
        }

        if (-not $netAppFilesAccount) {
            Write-Error "No NetApp resouce with Tag { RemoveModule = $moduleName } found in resource group [$resourceGroupName]"
            return
        }

        Write-Verbose ("Found [{0}] account(s) in [$resourceGroupName]" -f (, $netAppFilesAccount).Count)

        $resourcesToRemove = @()
        foreach ($account in (, $netAppFilesAccount)) {
            $resourcesToRemove += @{
                $resourceId = $account.Id
                $name       = $account.Name
                $type       = $account.Type
            }

            $netAppInputObject = @{
                AccountName       = $account.Name
                ResourceGroupName = $ResourceGroupName
            }
            $pool = Get-AzNetAppFilesPool @netAppInputObject -ErrorAction 'SilentlyContinue'
            Write-Verbose ('Found [{0}] pool(s) in account [{1}]' -f $pool.Count, $account.name)

            foreach ($poolInstance in (, $pool)) {
                $resourcesToRemove += @{
                    $resourceId = $poolInstance.Id
                    $name       = $poolInstance.Name
                    $type       = $poolInstance.Type
                }

                $volume = Get-AzNetAppFilesVolume @netAppInputObject -PoolName $poolInstance.Name.Split('/')[1] -ErrorAction 'SilentlyContinue'
                Write-Verbose ('Found [{0}] volume(s) in pool [{1}]' -f $volume.Count, $poolInstance.name)

                foreach ($volumeInstance in (, $volume)) {
                    $resourcesToRemove += @{
                        $resourceId = $volumeInstance.Id
                        $name       = $volumeInstance.Name
                        $type       = $volumeInstance.Type
                    }
                }
            }
        }

        # Prepare resources
        # -----------------
        # Flip array to remove low-level resources first
        $invertedArray = @()
        for ($i = ($resourcesToRemove.count - 1); $i -ge 0; $i--) {
            $invertedArray += $resourcesToRemove[$i]
        }
        $resourcesToRemove = $invertedArray

        # Remove resources
        # ----------------
        if ($resourcesToRemove) {
            Remove-Resource -resourceToRemove $resourcesToRemove
        }
    }
}
