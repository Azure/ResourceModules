<#
.SYNOPSIS
Remove a vWAN resource with a tag { removeModule = $moduleName }

.DESCRIPTION
Remove a vWAN resource with a tag { removeModule = $moduleName }

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
        [int] $tagSearchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $tagSearchRetryInterval = 30
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

        if (-not $virtualWAN) {
            Write-Error "No virtual WAN resouce with Tag { RemoveModule = $moduleName } found in resource group [$resourceGroupName]"
            return
        }
        Write-Verbose ("Found [{0}] vWAN(s) in [$resourceGroupName]" -f $virtualWAN.Count)

        $resourcesToRemove = @()
        foreach ($virtualWANInstance in $virtualWAN) {

            $resourcesToRemove += @{
                resourceId = $virtualWANInstance.ResourceId
                name       = $virtualWANInstance.Name
                type       = $virtualWANInstance.Type
            }

            $vpnSite = Get-AzVpnSite -ResourceGroupName $ResourceGroupName | Where-Object { $_.VirtualWan.ID -eq $virtualWANInstance.ResourceId }
            Write-Verbose ('Found [{0}] vpnSite(s) in virtual WAN [{1}]' -f $vpnSite.Count, $virtualWANInstance.name)

            foreach ($vpnSiteInstance in $vpnSite) {
                $resourcesToRemove += @{
                    resourceId = $vpnSiteInstance.ID
                    name       = $vpnSiteInstance.Name
                    type       = $vpnSiteInstance.Type
                }
            }

            $virtualHub = Get-AzVirtualHub -ResourceGroupName $ResourceGroupName | Where-Object { $_.VirtualWan.ID -eq $virtualWANInstance.ResourceId }
            Write-Verbose ('Found [{0}] virtual Hub(s) in virtual WAN [{1}]' -f $virtualHub.Count, $virtualWANInstance.name)

            foreach ($virtualHubInstance in $virtualHub) {
                $resourcesToRemove += @{
                    resourceId = $virtualHub.ID
                    name       = $virtualHub.Name
                    type       = $virtualHub.Type
                }

                $vpnGateway = Get-AzVpnGateway -ResourceGroupName $ResourceGroupName | Where-Object { $_.VirtualHub.ID -eq $virtualHubInstance.ID }
                Write-Verbose ('Found [{0}] vpnGateway(s) in virtual virtual Hub [{1}]' -f $vpnGateway.Count, $virtualHubInstance.name)

                foreach ($vpnGatewayInstance in $vpnGateway) {
                    $resourcesToRemove += @{
                        resourceId = $vpnGatewayInstance.ID
                        name       = $vpnGatewayInstance.Name
                        type       = $vpnGatewayInstance.Type
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
        if ($PSCmdlet.ShouldProcess(('[{0}] resources' -f $resourcesToRemove.Count), 'Remove')) {
            Remove-Resource -resourceToRemove $resourcesToRemove -Verbose
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
