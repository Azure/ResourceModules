<#
.SYNOPSIS
Remove Automation account, Log analytics link and Update solution deployed with a given deployment name. Resources will be removed even if Log Analytics is in a different resource group than the Automation Account

.DESCRIPTION
Remove Automation account, Log analytics link and Update solution deployed with a given deployment name. Resources will be removed even if Log Analytics is in a different resource group than the Automation Account

.PARAMETER deploymentName
Mandatory. The deployment name to use and find resources to remove

.PARAMETER searchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag

.PARAMETER searchRetryInterval
Optional. The time to wait in between the search for resources via their remove tags

.EXAMPLE
Remove-AutomationAccount -deploymentname 'aa-12345'

Remove Automation account, Log analytics link and Update solution deployed starting with the deployment name 'aa-12345'.
#>
function Remove-AutomationAccount {

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
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-DependencyResourceNameList.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-ResourceIdsAsFormattedObjectList.ps1')
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
            $rawResourceIdsToRemove | Where-Object { $_ -match 'Microsoft.OperationsManagement/solutions/Updates' }
            $rawResourceIdsToRemove | Where-Object { $_ -match 'linkedServices/automation' }
            $rawResourceIdsToRemove | Where-Object { $_ -match '/privateDnsZoneGroups/' }
            $rawResourceIdsToRemove | Where-Object { $_ -match '/Microsoft.Network/privateEndpoints/[^/]+$' }
            $rawResourceIdsToRemove | Where-Object { $_ -match 'Microsoft.Insights/diagnosticSettings' }
            $rawResourceIdsToRemove | Where-Object { $_ -match 'Microsoft.Automation/automationAccounts' }
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
