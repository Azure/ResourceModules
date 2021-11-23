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

.PARAMETER tagSearchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag

.PARAMETER tagSearchRetryInterval
Optional. The time to wait in between the search for resources via their remove tags

.PARAMETER deploymentName
Optional. The deployment name to use for the removal

.PARAMETER templateFilePath
Optional. The path to the deployment file

.EXAMPLE
Remove-DeployedModule -moduleName 'KeyVault' -resourceGroupName 'validation-rg'

Remove any resource in the resource group 'validation-rg' with tag 'removeModule = KeyVault'
#>
function Remove-DeployedModule {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ParameterSetName = 'tags')]
        [string] $moduleName,

        [Parameter(Mandatory = $false)]
        [string] $resourceGroupName,

        [Parameter(Mandatory, ParameterSetName = 'deploymentName')]
        [string] $deploymentName,

        [Parameter(Mandatory, ParameterSetName = 'deploymentName')]
        [string] $templateFilePath,

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

        #####################
        ## Process Removal ##
        #####################
        if (-not [String]::IsNullOrEmpty($deploymentName)) {
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

            switch ($deploymentScope) {
                'resourceGroup' {
                    $deployment = Get-AzResourceGroupDeploymentOperation -DeploymentName $deploymentName -ResourceGroupName $resourceGroupName
                    break
                }
                'subscription' {
                    $deployment = Get-AzDeploymentOperation -DeploymentName $deploymentName
                    break
                }
                'managementGroup' {
                    $deployment = Get-AzManagementGroupDeploymentOperation -DeploymentName $deploymentName
                    break
                }
                'tenant' {
                    $deployment = Get-AzTenantDeploymentOperation -DeploymentName $deploymentName
                    break
                }
                default {
                    throw "[$deploymentScope] is a non-supported template scope"
                }
            }

            if (-not $deployment) {
                Write-Error "No deployment found for [$deploymentName]"
                return
            }

            $resourcesToRemove = @()
            $rawResourcesToRemove = $deployment.TargetResource | Where-Object { $_ }
            # Process removal
            # ===============
            if ($deploymentScope -eq 'ResourceGroup') {
                Write-Verbose 'Handle subscription level removal'

                foreach ($rawResourcesToRemove in $rawResourcesToRemove) {
                    $resourcesToRemove += @{
                        resourceId = $rawResourcesToRemove
                        name       = $rawResourcesToRemove.Split('/')[-1]
                        type       = 'Microsoft.Resources/Resources'
                    }
                }
            } else {
                $allResources = Get-AzResource -ResourceGroupName $resourceGroupName -Name '*'
                foreach ($topLevelResource in $rawResourcesToRemove) {
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
                if ($vmsContained = $resourcesToRemove | Where-Object { $_.resourcetype -eq 'Microsoft.Compute/virtualMachines' }) {

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
        } else {

            if ([String]::IsNullOrEmpty($resourceGroupName)) {
                Write-Verbose 'Handle subscription level removal'

                # Identify resources
                # ------------------
                $tagSearchRetryCount = 1
                while (-not ($resourceGroupToRemove = Get-AzResourceGroup -Tag @{ removeModule = $moduleName } -ErrorAction 'SilentlyContinue') -and $tagSearchRetryCount -le $tagSearchRetryLimit) {
                    Write-Verbose ('Did not to find Resource Group by tag [removeModule={0}]. Retrying in [{1}] seconds [{2}/{3}]' -f $moduleName, $tagSearchRetryInterval, $tagSearchRetryCount, $tagSearchRetryLimit)
                    Start-Sleep $tagSearchRetryInterval
                    $tagSearchRetryCount++
                }


                $resourcesToRemove = @()
                if (-not $resourceGroupToRemove) {
                    Write-Error "No resource Group with Tag { RemoveModule = $moduleName } found"
                    return
                }

                foreach ($resourceGroupInstance in $resourceGroupToRemove) {
                    $resourcesToRemove += @{
                        resourceId = $resourceGroupInstance.ResourceId
                        name       = $resourceGroupInstance.ResourceGroupName
                        type       = 'Microsoft.Resources/Resources'
                    }
                }
            } else {
                Write-Verbose 'Handle resource group level removal'

                # Identify resources
                # ------------------
                $tagSearchRetryCount = 1
                while (-not ($rawResourcesToRemove = Get-AzResource -Tag @{ removeModule = $moduleName } -ResourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue') -and $tagSearchRetryCount -le $tagSearchRetryLimit) {
                    Write-Verbose ('Did not to find resources by tags [removeModule={0}] in resource group [{1}]. Retrying in [{2}] seconds [{3}/{4}]' -f $moduleName, $resourceGroupName, $tagSearchRetryInterval, $tagSearchRetryCount, $tagSearchRetryLimit)
                    Start-Sleep $tagSearchRetryInterval
                    $tagSearchRetryCount++
                }

                # Order resources to be removed from child to parent
                $resourcesToRemove = [System.Collections.ArrayList]@()
                $allResources = Get-AzResource -ResourceGroupName $resourceGroupName -Name '*'
                foreach ($topLevelResource in $rawResourcesToRemove) {
                    $expandedResources = $allResources | Where-Object { $_.ResourceId.startswith($topLevelResource.ResourceId) } | Sort-Object -Descending -Property { $_.ResourceId.Split('/').Count }
                    foreach ($resource in $expandedResources) {
                        $resourcesToRemove += @{
                            resourceId = $resource.ResourceId
                            name       = $resource.Name
                            type       = $resource.Type
                        }
                    }
                }

                # If VMs are available, delete those first
                if ($vmsContained = $resourcesToRemove | Where-Object { $_.resourcetype -eq 'Microsoft.Compute/virtualMachines' }) {

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

                if (-not $resourcesToRemove) {
                    Write-Error "No resource with Tag { RemoveModule = $moduleName } found in resource group [$resourceGroupName]"
                    return
                }
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

$inputObject = @{
    verbose           = $true
    moduleName        = 'servers'
    deploymentName    = 'servers-20211123T1911421080Z'
    # deploymentName    = 'servers-20211123T1911345345ZZ'
    templateFilePath  = 'C:\dev\ip\Azure-ResourceModules\ResourceModules\arm\Microsoft.AnalysisServices\servers\deploy.bicep'
    resourceGroupName = 'validation-rg'
}
Remove-DeployedModule @inputObject
