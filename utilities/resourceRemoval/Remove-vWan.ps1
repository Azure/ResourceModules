<#
.SYNOPSIS
Remove a vWAN resource with a tag { removeModule = $moduleName }

.DESCRIPTION
Remove a vWAN resource with a tag { removeModule = $moduleName }

.PARAMETER moduleName
Optional. The name of the module to remove

.PARAMETER ResourceGroupName
Optional. The resourceGroup of the module to remove

.PARAMETER maximumRemovalRetries
Optional. As the removal fetches all resources with the removal tag, and then tries to remove them one by one it can happen that the function tries to removed that as an active dependency on it (e.g. a VM disk of a VM deployment).
If the removal fails, the resource in question is moved back in the removal queue and another attempt is made after processing each other resource found.
This parameter controls, how often we want to push resources back in the queue and retry a removal.

.PARAMETER tagSearchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag

.PARAMETER tagSearchRetryInterval
Optional. The time to wait in between the search for resources via their remove tags

.EXAMPLE
Remove-vWan

Remove a virtual WAN with tag { 'removeModule' = 'virtualWans' } from resource group 'validation-rg'
#>
function Remove-vWan {

    [Cmdletbinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false)]
        [string] $moduleName = 'virtualWans',

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName = 'validation-rg',

        [Parameter(Mandatory = $false)]
        [int] $maximumRemovalRetries = 3,

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
        while (-not ($virtualWAN = Get-AzResource -Tag @{ removeModule = $moduleName } -ResourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue') -and $tagSearchRetryCount -le $tagSearchRetryLimit) {
            Write-Verbose ('Did not to find resources by tags [removeModule={0}] in resource group [{1}]. Retrying in [{2} seconds] [{3}/{4}]' -f $moduleName, $resourceGroupName, $tagSearchRetryInterval, $tagSearchRetryCount, $tagSearchRetryLimit)
            Start-Sleep $tagSearchRetryInterval
            $tagSearchRetryCount++
        }

        if ($virtualWAN) {
            $vWANResourceId = $virtualWAN.ResourceId

            $virtualHub = Get-AzVirtualHub -ResourceGroupName validation-rg | Where-Object { $_.VirtualWan.Id -eq $vWANResourceId }
            if ($virtualHub) {
                $virtualHubResourceId = $virtualHub.Id

                $vpnGateway = Get-AzVpnGateway -ResourceGroupName validation-rg | Where-Object { $_.VirtualHub.Id -eq $virtualHubResourceId }
                if ($vpnGateway) {
                    $vpnGatewayResourceId = $vpnGateway.Id
                }
            }

            $vpnSite = Get-AzVpnSite -ResourceGroupName validation-rg | Where-Object { $_.VirtualWan.Id -eq $vWANResourceId }
            if ($vpnSite) {
                $vpnSiteResourceId = $vpnSite.Id
            }
        }

        #Building array of resources to remove (in the required order)
        $resourcesToRemove = @()
        if ($vpnGatewayResourceId) { $resourcesToRemove += Get-AzResource -ResourceId $vpnGatewayResourceId }
        if ($virtualHubResourceId) { $resourcesToRemove += Get-AzResource -ResourceId $virtualHubResourceId }
        if ($vpnSiteResourceId) { $resourcesToRemove += Get-AzResource -ResourceId $vpnSiteResourceId }
        if ($vWANResourceId) { $resourcesToRemove += Get-AzResource -ResourceId $vWANResourceId }

        Remove-Resource -resourceToRemove $resourcesToRemove

        # # Remove resources
        # # ----------------
        # if ($resourcesToRemove) {
        #     $currentRetry = 0
        #     $resourcesToRetry = @()
        #     Write-Verbose ('Init removal of [{0}] resources' -f $resourcesToRemove.Count) -Verbose
        #     if ($PSCmdlet.ShouldProcess(('[{0}] resources' -f $resourceGroupToRemove.Count), 'Remove')) {
        #         while (($resourcesToRetry = Remove-Resource -resourceToRemove $resourcesToRemove).Count -gt 0 -and $currentRetry -le $maximumRetries) {
        #             Write-Verbose ('Re-try removal of remaining [{0}] resources. Round [{1}|{2}]' -f $resourcesToRetry.Count, $currentRetry, $maximumRetries) -Verbose
        #             $currentRetry++
        #         }
        #     }

        #     if ($resourcesToRetry.Count -gt 0) {
        #         throw ('The removal failed for resources [{0}]' -f ($resourcesToRetry.Name -join ', '))
        #     }
        # }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
