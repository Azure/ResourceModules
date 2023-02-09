<#
.SYNOPSIS
Invoke the removal of a deployed module

.DESCRIPTION
Invoke the removal of a deployed module.
Requires the resource in question to be tagged with 'removeModule = <moduleName>'

.PARAMETER ModuleName
Mandatory. The name of the module to remove

.PARAMETER ResourceGroupName
Optional. The resource group of the resource to remove

.PARAMETER ManagementGroupId
Optional. The ID of the management group to fetch deployments from. Relevant for management-group level deployments.

.PARAMETER SearchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag

.PARAMETER SearchRetryInterval
Optional. The time to wait in between the search for resources via their remove tags

.PARAMETER DeploymentNames
Optional. The deployment names to use for the removal

.PARAMETER TemplateFilePath
Mandatory. The path to the deployment file

.PARAMETER RemovalSequence
Optional. The order of resource types to apply for deletion

.EXAMPLE
Remove-Deployment -DeploymentNames @('KeyVault-t1','KeyVault-t2') -TemplateFilePath 'C:/deploy.json'

Remove all resources deployed via the with deployment names 'KeyVault-t1' & 'KeyVault-t2'
#>
function Remove-Deployment {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory = $true)]
        [string[]] $DeploymentNames,

        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [string[]] $RemovalSequence = @(),

        [Parameter(Mandatory = $false)]
        [int] $SearchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $SearchRetryInterval = 60
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path (Get-Item -Path $PSScriptRoot).parent.parent.FullName 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-DeploymentTargetResourceList.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-ResourceIdsAsFormattedObjectList.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-OrderedResourcesList.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Remove-ResourceList.ps1')
    }

    process {
        $azContext = Get-AzContext

        # Prepare data
        # ============
        $deploymentScope = Get-ScopeOfTemplateFile -TemplateFilePath $TemplateFilePath

        # Fundamental checks
        if ($deploymentScope -eq 'resourcegroup' -and -not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction 'SilentlyContinue')) {
            Write-Verbose "Resource group [$ResourceGroupName] does not exist (anymore). Skipping removal of its contained resources" -Verbose
            return
        }

        # Fetch deployments
        # =================
        $deployedTargetResources = @()

        foreach ($deploymentName in $DeploymentNames) {
            $deploymentsInputObject = @{
                Name  = $deploymentName
                Scope = $deploymentScope
            }
            if (-not [String]::IsNullOrEmpty($resourceGroupName)) {
                $deploymentsInputObject['resourceGroupName'] = $resourceGroupName
            }
            if (-not [String]::IsNullOrEmpty($ManagementGroupId)) {
                $deploymentsInputObject['ManagementGroupId'] = $ManagementGroupId
            }
            $deployedTargetResources += Get-DeploymentTargetResourceList @deploymentsInputObject
        }

        [array] $deployedTargetResources = $deployedTargetResources | Select-Object -Unique

        Write-Verbose ('Total number of deployment target resources after fetching deployments [{0}]' -f $deployedTargetResources.Count) -Verbose

        # Pre-Filter & order items
        # ========================
        $rawTargetResourceIdsToRemove = $deployedTargetResources | Sort-Object -Property { $_.Split('/').Count } -Descending | Select-Object -Unique
        Write-Verbose ('Total number of deployment target resources  after pre-filtering (duplicates) & ordering items [{0}]' -f $rawTargetResourceIdsToRemove.Count) -Verbose

        # Format items
        # ============
        [array] $resourcesToRemove = Get-ResourceIdsAsFormattedObjectList -ResourceIds $rawTargetResourceIdsToRemove
        Write-Verbose ('Total number of deployment target resources after formatting items [{0}]' -f $resourcesToRemove.Count) -Verbose

        if ($resourcesToRemove.Count -eq 0) {
            return
        }

        # Filter resources
        # ================

        # Resource IDs in the below list are ignored by the removal
        $resourceIdsToIgnore = @(
            '/subscriptions/{0}/resourceGroups/NetworkWatcherRG' -f $azContext.Subscription.Id
        )

        # Resource IDs starting with a prefix in the below list are ignored by the removal
        $resourceIdPrefixesToIgnore = @(
            '/subscriptions/{0}/providers/Microsoft.Security/autoProvisioningSettings/' -f $azContext.Subscription.Id
            '/subscriptions/{0}/providers/Microsoft.Security/deviceSecurityGroups/' -f $azContext.Subscription.Id
            '/subscriptions/{0}/providers/Microsoft.Security/iotSecuritySolutions/' -f $azContext.Subscription.Id
            '/subscriptions/{0}/providers/Microsoft.Security/pricings/' -f $azContext.Subscription.Id
            '/subscriptions/{0}/providers/Microsoft.Security/securityContacts/' -f $azContext.Subscription.Id
            '/subscriptions/{0}/providers/Microsoft.Security/workspaceSettings/' -f $azContext.Subscription.Id
        )
        [regex] $ignorePrefix_regex = '(?i)^(' + (($resourceIdPrefixesToIgnore | ForEach-Object { [regex]::escape($_) }) –join '|') + ')'


        if ($resourcesToIgnore = $resourcesToRemove | Where-Object { $_.resourceId -in $resourceIdsToIgnore -or $_.resourceId -match $ignorePrefix_regex }) {
            Write-Verbose 'Resources excluded from removal:' -Verbose
            $resourcesToIgnore | ForEach-Object { Write-Verbose ('- Ignore [{0}]' -f $_.resourceId) -Verbose }
        }

        [array] $resourcesToRemove = $resourcesToRemove | Where-Object { $_.resourceId -notin $resourceIdsToIgnore -and $_.resourceId -notmatch $ignorePrefix_regex }
        Write-Verbose ('Total number of deployments after filtering all dependency resources [{0}]' -f $resourcesToRemove.Count) -Verbose

        # Order resources
        # ===============
        [array] $resourcesToRemove = Get-OrderedResourcesList -ResourcesToOrder $resourcesToRemove -Order $RemovalSequence
        Write-Verbose ('Total number of deployments after final ordering of resources [{0}]' -f $resourcesToRemove.Count) -Verbose

        # Remove resources
        # ================
        if ($resourcesToRemove.Count -gt 0) {
            if ($PSCmdlet.ShouldProcess(('[{0}] resources' -f (($resourcesToRemove -is [array]) ? $resourcesToRemove.Count : 1)), 'Remove')) {
                Remove-ResourceList -ResourcesToRemove $resourcesToRemove
            }
        } else {
            Write-Verbose 'Found [0] resources to remove'
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
