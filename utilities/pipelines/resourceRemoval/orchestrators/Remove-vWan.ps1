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

        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [int] $searchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $searchRetryInterval = 60
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path (Get-Item -Path $PSScriptRoot).parent.parent.FullName 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-DeploymentByName.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-ResourceIdsAsFormattedObjectList.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-DependencyResourceNameList.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Remove-Resource.ps1')
    }

    process {
        # Prepare data
        # ============
        $deploymentScope = Get-ScopeOfTemplateFile -TemplateFilePath $TemplateFilePath

        # Fetch deployments
        # =================
        $deploymentsInputObject = @{
            name              = $deploymentName
            scope             = $deploymentScope
            resourceGroupName = $resourceGroupName
        }
        $deployments = Get-DeploymentByName @deploymentsInputObject -Verbose

        # Pre-Filter & order items
        # ========================
        $rawResourceIdsToRemove = $deployments | Sort-Object -Property { $_.Split('/').Count } -Descending | Select-Object -Unique

        $orderedResourceIds = @(
            $rawResourceIdsToRemove | Where-Object { $_ -match 'Microsoft.Network/vpnGateways' }
            $rawResourceIdsToRemove | Where-Object { $_ -match 'Microsoft.Network/virtualHubs' }
            $rawResourceIdsToRemove | Where-Object { $_ -match 'Microsoft.Network/vpnSites' }
            $rawResourceIdsToRemove | Where-Object { $_ -match 'Microsoft.Network/virtualWans' }
        )

        # Format items
        # ============
        $resourcesToRemove = Get-ResourceIdsAsFormattedObjectList -resourceIds $orderedResourceIds

        # Filter all dependency resources
        $dependencyResourceNames = Get-DependencyResourceNameList
        $resourcesToRemove = $resourcesToRemove | Where-Object { $_.Name -notin $dependencyResourceNames }

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
