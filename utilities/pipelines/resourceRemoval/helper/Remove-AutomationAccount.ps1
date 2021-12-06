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
Remove-automationAccount -deploymentname 'aa-12345'

Remove Automation account, Log analytics link and Update solution deployed starting with the deployment name 'aa-12345'.
#>
function Remove-automationAccount {

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
            Write-Verbose ('Did not to find Automation Account deployment resources by name [{0}] in scope [{1}]. Retrying in [{2}] seconds [{3}/{4}]' -f $deploymentName, $deploymentScope, $searchRetryInterval, $searchRetryCount, $searchRetryLimit) -Verbose
            Start-Sleep $searchRetryInterval
            $searchRetryCount++
        } while ($searchRetryCount -le $searchRetryLimit)

        if (-not $deployments) {
            throw "No deployment found for [$deploymentName]"
        }

        $resourcesToRemove = @()
        $unorderedResourceIds = @()
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

        $unorderedResourceIds = $unorderedResourceIds | Where-Object { $_ -and ($_ -notmatch '/variables/') -and ($_ -notmatch '/variables/') }

        $orderedResourceIds = @(
            $unorderedResourceIds | Where-Object { $_ -match 'Microsoft.OperationsManagement/solutions/Updates' }
            $unorderedResourceIds | Where-Object { $_ -match 'linkedServices/automation' }
            $unorderedResourceIds | Where-Object { $_ -match 'Microsoft.Insights/diagnosticSettings' }
            $unorderedResourceIds | Where-Object { $_ -match 'Microsoft.Automation/automationAccounts' }
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
