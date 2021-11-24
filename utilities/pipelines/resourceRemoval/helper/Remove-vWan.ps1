<#
.SYNOPSIS
Remove a vWAN resource with a given deployment name

.DESCRIPTION
Remove a vWAN resource with a given deployment name

.PARAMETER deploymentName
Mandatory. The deployment name to use and find resources to remove

.PARAMETER deploymentSearchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag

.PARAMETER deploymentSearchRetryInterval
Optional. The time to wait in between the search for resources via their remove tags

.EXAMPLE
Remove-vWan -deploymentname 'keyvault-12345'

Remove a virtual WAN with deployment name 'keyvault-12345' from resource group 'validation-rg'
#>
function Remove-vWan {

    [Cmdletbinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string] $deploymentName,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName = 'validation-rg',

        [Parameter(Mandatory = $false)]
        [int] $deploymentSearchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $deploymentSearchRetryInterval = 60
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path $PSScriptRoot 'helper/Remove-Resource.ps1')
    }

    process {

        # Identify resources
        # ------------------
        $deploymentsSearchRetryCount = 1
        while (-not ($deployments = Get-AzResourceGroupDeploymentOperation -DeploymentName $deploymentName -ResourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue') -and $deploymentsSearchRetryCount -le $deploymentsSearchRetryLimit) {
            Write-Verbose ('Did not to find vWAN deployment resources by name [{0}] in scope [{1}]. Retrying in [{2}] seconds [{3}/{4}]' -f $deploymentName, $deploymentScope, $deploymentSearchRetryInterval, $deploymentSearchRetryCount, $deploymentSearchRetryLimit)
            Start-Sleep $deploymentSearchRetryInterval
            $deploymentSearchRetryCount++
        }

        if (-not $deployments) {
            Write-Error "No deployment found for [$deploymentName]"
            return
        }

        $resourcesToRemove = @()
        $unorderedResourceIds = $deployments.TargetResource | Where-Object { $_ -and $_ -notmatch '/deployments/' }

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
