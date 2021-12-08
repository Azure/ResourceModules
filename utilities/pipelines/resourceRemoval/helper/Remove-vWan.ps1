<#
.SYNOPSIS
Remove a vWAN resource with a given deployment name
.DESCRIPTION
Remove a vWAN resource with a given deployment name
.PARAMETER deploymentName
Mandatory. The deployment name to use and find resources to remove
.PARAMETER searchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag
.PARAMETER searchRetryInterval
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
        [int] $searchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $searchRetryInterval = 60
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path $PSScriptRoot 'Remove-Resource.ps1')
    }

    process {

        # Identify resources
        # ------------------
        $searchRetryCount = 1
        do {
            $deployments = Get-AzResourceGroupDeploymentOperation -DeploymentName $deploymentName -ResourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue'
            if ($deployments) {
                break
            }
            Write-Verbose ('Did not to find vWAN deployment resources by name [{0}] in scope [{1}]. Retrying in [{2}] seconds [{3}/{4}]' -f $deploymentName, $deploymentScope, $searchRetryInterval, $searchRetryCount, $searchRetryLimit) -Verbose
            Start-Sleep $searchRetryInterval
            $searchRetryCount++
        } while ($searchRetryCount -le $searchRetryLimit)

        if (-not $deployments) {
            throw "No deployment found for [$deploymentName]"
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
}<#
.SYNOPSIS
Remove a Virtual Machine resource with a given deployment name

.DESCRIPTION
Remove a Virtual Machine resource with a given deployment name

.PARAMETER deploymentName
Mandatory. The deployment name to use and find resources to remove

.PARAMETER searchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag

.PARAMETER searchRetryInterval
Optional. The time to wait in between the search for resources via their remove tags

.EXAMPLE
Remove-VirtualMachine -deploymentname 'keyvault-12345'

Remove a virtual machine with deployment name 'keyvault-12345' from resource group 'validation-rg'
#>
function Remove-VirtualMachine {

    [Cmdletbinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string] $deploymentName,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName = 'validation-rg',

        [Parameter(Mandatory = $false)]
        [int] $searchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $searchRetryInterval = 60
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path $PSScriptRoot 'Remove-Resource.ps1')
        . (Join-Path $PSScriptRoot 'Get-DependencyResourceNames.ps1')
    }

    process {

        # Identify resources
        # ------------------
        $searchRetryCount = 1
        do {
            $deployments = Get-AzResourceGroupDeploymentOperation -DeploymentName $deploymentName -ResourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue'
            if ($deployments) {
                break
            }
            Write-Verbose ('Did not to find VirtualMachine deployment resources by name [{0}] in scope [{1}]. Retrying in [{2}] seconds [{3}/{4}]' -f $deploymentName, $deploymentScope, $searchRetryInterval, $searchRetryCount, $searchRetryLimit) -Verbose
            Start-Sleep $searchRetryInterval
            $searchRetryCount++
        } while ($searchRetryCount -le $searchRetryLimit)

        if (-not $deployments) {
            throw "No deployment found for [$deploymentName]"
        }

        $unorderedResourceIds = $deployments.TargetResource | Where-Object { $_ -and $_ -notmatch '/deployments/' }
        $resourcesToRemove = [System.Collections.ArrayList] @()


        # Handle VM resources
        $vmIds = $unorderedResourceIds | Where-Object { $_ -match '/virtualMachines/' }
        if ($vmIds.Count -gt 0) {
            $vmName = ($unorderedResourceIds | Where-Object { $_ -match '/virtualMachines/' }).Split('/')[-1]

            # Fetch all resources that match the VM
            $allResources = Get-AzResource -ResourceGroupName $resourceGroupName -Name "$vmName*"

            # Sort ascending as we need to remove the VM first
            $orderedResourceIds = $allResources | Sort-Object -Property { $_.ResourceId.Split('/').Count }
            $resourcesToRemove += $orderedResourceIds | ForEach-Object {
                @{
                    resourceId = $_.ResourceId
                    name       = $_.Name
                    type       = $_.Type
                }
            }
        }

        # Handle non-vm resources that are deployed with the VM
        $otherIds = $unorderedResourceIds | Where-Object { $_ -notmatch '/virtualMachines/' }
        foreach ($otherResourceId in $otherIds) {
            $resourcesToRemove += @{
                resourceId = $otherResourceId
                name       = $otherResourceId.Split('/')[-1]
                type       = $otherResourceId.Split('/')[6..7] -join '/'
            }
        }

        # Filter all dependency resources
        $dependencyResourceNames = Get-DependencyResourceNames
        $resourcesToRemove = $resourcesToRemove | Where-Object { $_.Name -notin $dependencyResourceNames }

        # Remove resources
        # ----------------
        if ($resourcesToRemove.count -gt 0) {
            if ($PSCmdlet.ShouldProcess(('[{0}] resources' -f $resourcesToRemove.Count), 'Remove')) {
                Remove-Resource -resourceToRemove $resourcesToRemove -Verbose
            }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
