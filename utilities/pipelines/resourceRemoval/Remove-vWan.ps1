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
        [Parameter(Mandatory)]
        [string] $deploymentName,

        [Parameter(Mandatory = $false)]
        [string] $templateFilePath = '',

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
        $deployment = Get-AzResourceGroupDeploymentOperation -DeploymentName $deploymentName -ResourceGroupName $resourceGroupName

        if (-not $deployment) {
            Write-Error "No deployment found for [$deploymentName]"
            return
        }

        $resourcesToRemove = @()
        $virtualWANsToRemove = $deployment.TargetResource | Where-Object { $_ -and $_ -notmatch '/deployments/' }

        $resourcesToRemove = @()
        foreach ($vWANResourceId in $virtualWANsToRemove) {

            $virtualWANInstance = Get-AzResource -ResourceId $vWANResourceId

            $resourcesToRemove += @{
                resourceId = $virtualWANInstance.ResourceId
                name       = $virtualWANInstance.Name
                type       = $virtualWANInstance.Type
            }

            $vpnSite = Get-AzVpnSite -ResourceGroupName $ResourceGroupName | Where-Object { $_.VirtualWan.Id -eq $virtualWANInstance.ResourceId }
            Write-Verbose ('Found [{0}] vpnSite(s) in virtual WAN [{1}]' -f $vpnSite.Count, $virtualWANInstance.name)

            foreach ($vpnSiteInstance in $vpnSite) {
                $resourcesToRemove += @{
                    resourceId = $vpnSiteInstance.Id
                    name       = $vpnSiteInstance.Name
                    type       = $vpnSiteInstance.Type
                }
            }

            $virtualHub = Get-AzVirtualHub -ResourceGroupName $ResourceGroupName | Where-Object { $_.VirtualWan.Id -eq $virtualWANInstance.ResourceId }
            Write-Verbose ('Found [{0}] virtual Hub(s) in virtual WAN [{1}]' -f $virtualHub.Count, $virtualWANInstance.name)

            foreach ($virtualHubInstance in $virtualHub) {
                $resourcesToRemove += @{
                    resourceId = $virtualHub.Id
                    name       = $virtualHub.Name
                    type       = $virtualHub.Type
                }

                $vpnGateway = Get-AzVpnGateway -ResourceGroupName $ResourceGroupName | Where-Object { $_.VirtualHub.Id -eq $virtualHubInstance.Id }
                Write-Verbose ('Found [{0}] vpnGateway(s) in virtual virtual Hub [{1}]' -f $vpnGateway.Count, $virtualHubInstance.name)

                foreach ($vpnGatewayInstance in $vpnGateway) {
                    $resourcesToRemove += @{
                        resourceId = $vpnGatewayInstance.Id
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
