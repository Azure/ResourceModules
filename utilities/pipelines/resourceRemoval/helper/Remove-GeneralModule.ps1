#region helper

<#
.SYNOPSIS
Get all deployments that match a given deployment name in a given scope

.DESCRIPTION
Get all deployments that match a given deployment name in a given scope

.PARAMETER name
Mandatory. The deployment name to search for

.PARAMETER resourceGroupName
Optional. The name of the resource group for scope 'resourceGroup'

.PARAMETER scope
Mandatory. The scope to search in

.EXAMPLE
Get-DeploymentByName name 'keyvault-12356' -scope 'resourceGroup'

Get all deployments that match name 'keyvault-12356' in scope 'resourceGroup'
#>
function Get-DeploymentByName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $name,

        [Parameter(Mandatory = $false)]
        [string] $resourceGroupName,

        [Parameter(Mandatory)]
        [ValidateSet(
            'resourceGroup',
            'subscription',
            'managementGroup',
            'tenant'
        )]
        [string] $scope
    )

    switch ($deploymentScope) {
        'resourceGroup' {
            return = Get-AzResourceGroupDeploymentOperation -DeploymentName $name -resourceGroupName $resourceGroupName
        }
        'subscription' {
            return Get-AzDeploymentOperation -DeploymentName $name
        }
        'managementGroup' {
            return Get-AzManagementGroupDeploymentOperation -DeploymentName $name
        }
        'tenant' {
            return Get-AzTenantDeploymentOperation -DeploymentName $name
        }
        default {
            throw "[$deploymentScope] is a non-supported template scope"
        }
    }
}

#endregion

<#
.SYNOPSIS
Invoke the removal of a deployed module

.DESCRIPTION
Invoke the removal of a deployed module.
Requires the resource in question to be tagged with 'removeModule = <moduleName>'

.PARAMETER moduleName
Mandatory. The name of the module to remove

.PARAMETER resourceGroupName
Mandatory. The resource group of the resource to remove

.PARAMETER deploymentsSearchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag

.PARAMETER deploymentsSearchRetryInterval
Optional. The time to wait in between the search for resources via their remove tags

.PARAMETER deploymentName
Optional. The deployment name to use for the removal

.PARAMETER templateFilePath
Optional. The path to the deployment file

.EXAMPLE
Remove-GeneralModule -deploymentName 'KeyVault' -resourceGroupName 'validation-rg'

Remove a virtual WAN with deployment name 'keyvault-12345' from resource group 'validation-rg'
#>
function Remove-GeneralModule {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $resourceGroupName,

        [Parameter(Mandatory = $true)]
        [string] $deploymentName,

        [Parameter(Mandatory = $true)]
        [string] $templateFilePath,

        [Parameter(Mandatory = $false)]
        [int] $deploymentsSearchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $deploymentsSearchRetryInterval = 60
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path $PSScriptRoot 'Remove-Resource.ps1')
    }

    process {

        #####################
        ## Process Removal ##
        #####################
        Write-Verbose ('Handling resource removal with deployment name [{0}]' -f $deploymentName) -Verbose

        # Gather deployments
        # ==================
        if ((Split-Path $templateFilePath -Extension) -eq '.bicep') {
            # Bicep
            $bicepContent = Get-Content $templateFilePath
            $bicepScope = $bicepContent | Where-Object { $_ -like '*targetscope =*' }
            if (-not $bicepScope) {
                $deploymentScope = 'resourceGroup'
            } else {
                $deploymentScope = $bicepScope.ToLower().Replace('targetscope = ', '').Replace("'", '').Trim()
            }
        } else {
            # ARM
            $armSchema = (ConvertFrom-Json (Get-Content -Raw -Path $templateFilePath)).'$schema'
            switch -regex ($armSchema) {
                '\/deploymentTemplate.json#$' { $deploymentScope = 'resourceGroup' }
                '\/subscriptionDeploymentTemplate.json#$' { $deploymentScope = 'subscription' }
                '\/managementGroupDeploymentTemplate.json#$' { $deploymentScope = 'managementGroup' }
                '\/tenantDeploymentTemplate.json#$' { $deploymentScope = 'tenant' }
                Default { throw "[$armSchema] is a non-supported ARM template schema" }
            }
        }

        $deploymentsSearchRetryCount = 1
        while (-not ($deployments = Get-DeploymentByName -name $deploymentName -scope $deploymentScope -resourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue') -and $deploymentsSearchRetryCount -le $deploymentsSearchRetryLimit) {
            Write-Verbose ('Did not to find deployments by name [{0}] in scope [{1}]. Retrying in [{2}] seconds [{3}/{4}]' -f $deploymentName, $deploymentScope, $deploymentsSearchRetryInterval, $deploymentsSearchRetryCount, $deploymentsSearchRetryLimit)
            Start-Sleep $deploymentsSearchRetryInterval
            $deploymentsSearchRetryCount++
        }

        if (-not $deployments) {
            Write-Error "No deployment found for [$deploymentName]"
            return
        }

        $resourcesToRemove = @()
        $rawResourceIdsToRemove = $depldeploymentsoyment.TargetResource | Where-Object { $_ -and $_ -notmatch '/deployments/' }
        # Process removal
        # ===============
        if ($deploymentScope -eq 'ResourceGroup') {
            Write-Verbose 'Handle subscription level removal'

            foreach ($rawResourceIdsToRemove in $rawResourceIdsToRemove) {
                $resourcesToRemove += @{
                    resourceId = $rawResourceIdsToRemove
                    name       = $rawResourceIdsToRemove.Split('/')[-1]
                    type       = $rawResourceIdsToRemove.Split('/')[6..7] -join '/'
                }
            }
        } else {
            $allResources = Get-AzResource -ResourceGroupName $resourceGroupName -Name '*'
            # Get all child resources and sort from child to parent
            foreach ($topLevelResource in $rawResourceIdsToRemove) {
                $expandedResources = $allResources | Where-Object { $_.ResourceId.startswith($topLevelResource) } | Sort-Object -Descending -Property { $_.ResourceId.Split('/').Count }
                foreach ($resource in $expandedResources) {
                    $resourcesToRemove += @{
                        resourceId = $resource.ResourceId
                        name       = $resource.Name
                        type       = $resource.Type
                    }
                }
            }
            if ($resourcesToRemove.Count -gt 1) {
                $resourcesToRemove = $resourcesToRemove | Select-Object -Unique
            }

            # If VMs are available, delete those first
            if ($vmsContained = $resourcesToRemove | Where-Object { $_.type -eq 'Microsoft.Compute/virtualMachines' }) {

                $intermediateResources = @()
                foreach ($vmInstance in $vmsContained) {
                    $intermediateResources += @{
                        resourceId = $vmInstance.ResourceId
                        name       = $vmInstance.Name
                        type       = $vmInstance.Type
                    }
                }
                Remove-Resource -resourceToRemove $intermediateResources -Verbose
                # refresh
                $resourcesToRemove = $resourcesToRemove | Where-Object { $_.ResourceId -notin $intermediateResources.resourceId }
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
