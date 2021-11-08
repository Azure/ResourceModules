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

        $resourcesToRemove = @()
        if (-not $netAppFilesAccount) {
            Write-Error "No NetApp resouce with Tag { RemoveModule = $moduleName } found in resource group [$resourceGroupName]"
            return
        } else {
            $resourcesToRemove += $netAppFilesAccount
            Write-Verbose ("Found [{0}] account(s) in [$resourceGroupName]" -f (, $netAppFilesAccount).Count)
        }

        foreach ($account in $netAppFilesAccount) {
            $netAppInputObject = @{
                AccountName       = $account.Name
                ResourceGroupName = $ResourceGroupName
            }
            $pools = Get-AzNetAppFilesPool @netAppInputObject -ErrorAction 'SilentlyContinue'
            $resourcesToRemove += $pools
            Write-Verbose ('Found [{0}] pool(s) in account [{1}]' -f $pools.Count, $account.name)
            foreach ($pool in $pools) {

                $volumes = Get-AzNetAppFilesVolume @netAppInputObject -PoolName $pool.Name.Split('/')[1] -ErrorAction 'SilentlyContinue'
                $resourcesToRemove += $volumes
                Write-Verbose ('Found [{0}] volume(s) in pool [{1}]' -f $volumes.Count, $pool.name)
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

            # $currentRetry = 0
            # $resourcesToRetry = @()
            # Write-Verbose ('Init removal of [{0}] resources' -f $resourcesToRemove.Count) -Verbose
            # if ($PSCmdlet.ShouldProcess(('[{0}] resources' -f $resourceGroupToRemove.Count), 'Remove')) {
            #     while (($resourcesToRetry = Remove-Resource -resourceToRemove $resourcesToRemove).Count -gt 0 -and $currentRetry -le $maximumRetries) {
            #         Write-Verbose ('Re-try removal of remaining [{0}] resources. Round [{1}|{2}]' -f $resourcesToRetry.Count, $currentRetry, $maximumRetries) -Verbose
            #         $currentRetry++
            #     }
            # }

            # if ($resourcesToRetry.Count -gt 0) {
            #     throw ('The removal failed for resources [{0}]' -f ($resourcesToRetry.Name -join ', '))
            # }
        }
    }
}
