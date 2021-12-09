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
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-ScopeOfTemplateFile.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-DeploymentByName.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-DependencyResourceNames.ps1')
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
        $deployments = Get-DeploymentByName @deploymentsInputObject

        # Pre-Filter & order items
        # ========================
        $resourcesToRemove = @()
        $unorderedResourceIds = $deployments.TargetResource | Where-Object { $_ -and $_ -notmatch '/deployments/' }
        $childDeploymentsIds = $deployments.TargetResource | Where-Object { $_ -and $_ -match '/deployments/' }

        foreach ($childDeploymentId in $childDeploymentsIds) {
            $searchRetryCount = 1
            $childDeploymentTokens = $childDeploymentId.Split('/')
            $childDeploymentName = $childDeploymentTokens[8]
            $childDeploymentResourceGroup = $childDeploymentTokens[4]
            do {
                Write-Verbose ('Searching child deployment named [{0}] in resource group [{1}]. Attempt [{2}/{3}]' -f $childDeploymentName, $childDeploymentResourceGroup, $searchRetryCount, $searchRetryLimit) -Verbose
                $childDeployment = Get-AzResourceGroupDeploymentOperation -DeploymentName $childDeploymentName -ResourceGroupName $childDeploymentResourceGroup -ErrorAction 'SilentlyContinue'
                if ($childDeployment) {
                    Write-Verbose ('[Success] Child deployment named [{0}] in resource group [{1}] found' -f $childDeploymentName, $childDeploymentResourceGroup) -Verbose
                    $unorderedResourceIds += $childDeployment.TargetResource
                    break
                }
                Write-Verbose ('[Failure] Did not to find child deployment named [{0}] in resource group [{1}]. Retrying in [{2}] seconds [{3}/{4}]' -f $childDeploymentName, $childDeploymentResourceGroup, $searchRetryInterval, $searchRetryCount, $searchRetryLimit) -Verbose
                Start-Sleep $searchRetryInterval
                $searchRetryCount++
            } while ($searchRetryCount -le $searchRetryLimit)
        }

        $unorderedResourceIds = $unorderedResourceIds | Where-Object { $_ `
                -and ($_ -notmatch '/Microsoft.Insights/diagnosticSettings/') `
                -and ($_ -notmatch '/variables/') `
                -and ($_ -notmatch '/softwareUpdateConfigurations/') `
                -and ($_ -notmatch '/jobSchedules/') `
                -and ($_ -notmatch '/schedules/') `
                -and ($_ -notmatch '/runbooks/') `
                -and ($_ -notmatch '/modules/') `
                -and ($_ -notmatch '/Microsoft.Authorization/roleAssignments/') `
        } | Select-Object -Unique

        $orderedResourceIds = @(
            $unorderedResourceIds | Where-Object { $_ -match 'Microsoft.OperationsManagement/solutions/Updates' }
            $unorderedResourceIds | Where-Object { $_ -match 'linkedServices/automation' }
            $unorderedResourceIds | Where-Object { $_ -match 'Microsoft.Insights/diagnosticSettings' }
            $unorderedResourceIds | Where-Object { $_ -match 'Microsoft.Automation/automationAccounts' }
        )

        # Format items
        # ============
        $resourcesToRemove = Get-ResourceIdsAsFormattedObjectLists -resourceIds $orderedResourceIds

        # Filter all dependency resources
        $dependencyResourceNames = Get-DependencyResourceNames
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
