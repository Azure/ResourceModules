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
        [string] $templateFilePath = '', # Not used here

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
        $unorderedResourceIds = $deployment.TargetResource | Where-Object { $_ -and $_ -notmatch '/deployments/' }

        $orderedResourceIds = @(
            $unorderedResourceIds | Where-Object { $_ -match 'Microsoft.Network/vpnGateways' }
            $unorderedResourceIds | Where-Object { $_ -match 'Microsoft.Network/virtualHubs' }
            $unorderedResourceIds | Where-Object { $_ -match 'Microsoft.Network/vpnSites' }
            $unorderedResourceIds | Where-Object { $_ -match 'Microsoft.Network/virtualWans' }
        )
        $resourcesToRemove = $orderedResourceIds | ForEach-Object {
            @{
                resourceId = $_
                name       = $_.Split('/')[-1]
                type       = $_.Split('/')[6..7] -join '/'
            }
        }

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
