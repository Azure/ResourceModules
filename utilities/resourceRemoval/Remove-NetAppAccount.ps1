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

# TODO: Check if Remove-AzResource can be used to. Then we just need to bring the resources in order and can use a central function to remove them
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
        # Identifying resources
        $tagSearchRetryCount = 1
        while (-not ($resourcesToRemove = Get-AzResource -Tag @{ removeModule = $moduleName } -ResourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue') -and $tagSearchRetryCount -le $tagSearchRetryLimit) {
            Write-Verbose ('Did not to find resources by tags [removeModule={0}] in resource group [{1}]. Retrying in [{2} seconds] [{3}/{4}]' -f $moduleName, $resourceGroupName, $tagSearchRetryInterval, $tagSearchRetryCount, $tagSearchRetryLimit)
            Start-Sleep $tagSearchRetryInterval
            $tagSearchRetryCount++
        }

        if (-not $resourcesToRemove) {
            Write-Error "No NetApp resouce with Tag { RemoveModule = $moduleName } found in resource group [$resourceGroupName]"
            return
        } else {
            $accounts = Get-AzNetAppFilesAccount -ResourceGroupName $resourceGroupName
            Write-Verbose ("Found [{0}] NetAppFilesAccount in [$resourceGroupName]" -f $accounts.Count)
        }
        foreach ($account in $accounts) {
            $netAppInputObject = @{
                AccountName       = $account.Name
                ResourceGroupName = $ResourceGroupName
            }
            $pools = Get-AzNetAppFilesPool @netAppInputObject -ErrorAction 'SilentlyContinue'
            Write-Verbose ('Found [{0}] pools' -f $pools.Count)
            foreach ($pool in $pools) {

                $volumes = Get-AzNetAppFilesVolume @netAppInputObject -PoolName $pool.Name.Split('/')[1] -ErrorAction 'SilentlyContinue'
                Write-Verbose ('Found [{0}] volumes' -f $volumes.Count)
                foreach ($volumne in $volumes) {
                    if ($PSCmdlet.ShouldProcess(('Azure NetApp account volume [{0}]' -f $volumne.Name.Split('/')[2]), 'Remove')) {
                        $retries = 0
                        $maxRetries = 10
                        do {
                            $retries++
                            $null = Remove-AzNetAppFilesVolume @netAppInputObject -PoolName $pool.Name.Split('/')[1] -Name $volumne.Name.Split('/')[2]
                            Write-Verbose ('Waiting 15 seconds for volumne removal [{0}/{1}]' -f $retries, $maxRetries)
                            Start-Sleep 15
                        }
                        while ((Get-AzNetAppFilesVolume @netAppInputObject -PoolName $pool.Name.Split('/')[1] -Name $volumne.Name.Split('/')[2] -ErrorAction 'SilentlyContinue') -and $retries -le $maxRetries)

                        if ($retries -gt $maxRetries) {
                            Write-Error 'Failed to remove volumne [{0}] from NetApp account [{1}]' -f $AccountName, $volumne.Name.Split('/')[2]
                        }
                    }
                }
                if ($PSCmdlet.ShouldProcess(('Azure NetApp account pool [{0}]' -f $pool.Name.Split('/')[1]), 'Remove')) {
                    Remove-AzNetAppFilesPool @netAppInputObject -PoolName $pool.Name.Split('/')[1]
                }
            }
            if ($PSCmdlet.ShouldProcess(('Azure NetApp account [{0}]' -f $account.Name), 'Remove')) {
                Remove-AzNetAppFilesAccount @netAppInputObject
            }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
