function Remove-NetAppAccount {

    [Cmdletbinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false)]
        [string] $moduleName = 'netAppAccounts',

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName = 'validation-rg'
    )

    $resourcesToRemove = Get-AzResource -Tag @{ RemoveModule = $moduleName } -ResourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue'
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
                        (Write-Error 'Failed to remove volumne [{0}] from NetApp account [{1}]' -f $AccountName, $volumne.Name.Split('/')[2])
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
