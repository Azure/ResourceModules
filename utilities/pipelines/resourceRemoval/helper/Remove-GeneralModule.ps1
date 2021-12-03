#region helper

<#
.SYNOPSIS
Get all deployments that match a given deployment name in a given scope

.DESCRIPTION
Get all deployments that match a given deployment name in a given scope

.PARAMETER Name
Mandatory. The deployment name to search for

.PARAMETER ResourceGroupName
Optional. The name of the resource group for scope 'resourceGroup'

.PARAMETER Scope
Mandatory. The scope to search in

.EXAMPLE
Get-DeploymentByName -Name 'keyvault-12356' -Scope 'resourceGroup'

Get all deployments that match name 'keyvault-12356' in scope 'resourceGroup'
#>
function Get-DeploymentByName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory)]
        [ValidateSet(
            'resourceGroup',
            'subscription',
            'managementGroup',
            'tenant'
        )]
        [string] $Scope
    )

    $resultSet = [System.Collections.ArrayList]@()
    switch ($Scope) {
        'resourceGroup' {
            $resultSet += (Get-AzResourceGroupDeploymentOperation -DeploymentName $name -ResourceGroupName $resourceGroupName).TargetResource
        }
        'subscription' {
            $resultSet += (Get-AzDeploymentOperation -DeploymentName $name).TargetResource
            foreach ($deployment in ($resultSet | Where-Object { $_ -match '/deployments/' } )) {
                $resultSet = $resultSet | Where-Object { $_ -ne $deployment }
                if ($deployment -match '/resourceGroups/') {
                    # Resource Group Level Child Deployments
                    $name = Split-Path $deployment -Leaf
                    $resourceGroupName = $deployment.split('/resourceGroups/')[1].Split('/')[0]
                    $resultSet += Get-DeploymentByName -Name $name -ResourceGroupName $ResourceGroupName -Scope 'resourceGroup'
                } else {
                    # Subscription Level Deployments
                    $resultSet += Get-DeploymentByName -name (Split-Path $deployment -Leaf) -Scope 'subscription'
                }
            }
        }
        'managementGroup' {
            $resultSet += (Get-AzManagementGroupDeploymentOperation -DeploymentName $name).TargetResource
            foreach ($deployment in ($resultSet | Where-Object { $_ -match '/deployments/' } )) {
                $resultSet = $resultSet | Where-Object { $_ -ne $deployment }
                if ($deployment -match '/managementGroup/') {
                    # Subscription Level Child Deployments
                    $resultSet += Get-DeploymentByName -Name (Split-Path $deployment -Leaf) -Scope 'subscription'
                } else {
                    # Management Group Level Deployments
                    $resultSet += Get-DeploymentByName -name (Split-Path $deployment -Leaf) -scope 'managementGroup'
                }
            }
        }
        'tenant' {
            $resultSet = (Get-AzTenantDeploymentOperation -DeploymentName $name).TargetResource
            foreach ($deployment in ($resultSet | Where-Object { $_ -match '/deployments/' } )) {
                $resultSet = $resultSet | Where-Object { $_ -ne $deployment }
                if ($deployment -match '/tenant/') {
                    # Management Group Level Child Deployments
                    $resultSet += Get-DeploymentByName -Name (Split-Path $deployment -Leaf) -scope 'managementGroup'
                } else {
                    # Tenant Level Deployments
                    $resultSet += Get-DeploymentByName -name (Split-Path $deployment -Leaf)
                }
            }
        }
    }
    return $resultSet
}

#endregion

<#
.SYNOPSIS
Invoke the removal of a deployed module

.DESCRIPTION
Invoke the removal of a deployed module.
Requires the resource in question to be tagged with 'removeModule = <moduleName>'

.PARAMETER ModuleName
Mandatory. The name of the module to remove

.PARAMETER ResourceGroupName
Mandatory. The resource group of the resource to remove

.PARAMETER SearchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag

.PARAMETER SearchRetryInterval
Optional. The time to wait in between the search for resources via their remove tags

.PARAMETER DeploymentName
Optional. The deployment name to use for the removal

.PARAMETER TemplateFilePath
Optional. The path to the deployment file

.EXAMPLE
Remove-GeneralModule -DeploymentName 'KeyVault' -ResourceGroupName 'validation-rg'

Remove a virtual WAN with deployment name 'keyvault-12345' from resource group 'validation-rg'
#>
function Remove-GeneralModule {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [string] $DeploymentName,

        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [int] $SearchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $SearchRetryInterval = 60
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path $PSScriptRoot 'Remove-Resource.ps1')
        . (Join-Path $PSScriptRoot 'Get-DependencyResourceNames.ps1')
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
                $deploymentScope = $bicepScope.ToLower().Split('=')[-1].Replace("'", '').Trim()
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

        # Identify resources
        # ------------------
        $searchRetryCount = 1
        do {
            $deployments = Get-DeploymentByName -name $deploymentName -scope $deploymentScope -resourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue'
            if ($deployments) {
                break
            }
            Write-Verbose ('Did not to find deployments by name [{0}] in scope [{1}]. Retrying in [{2}] seconds [{3}/{4}]' -f $deploymentName, $deploymentScope, $searchRetryInterval, $searchRetryCount, $searchRetryLimit) -Verbose
            Start-Sleep $searchRetryInterval
            $searchRetryCount++
        } while ($searchRetryCount -le $searchRetryLimit)

        if (-not $deployments) {
            throw "No deployment found for [$deploymentName]"
        }

        $resourcesToRemove = @()
        $rawResourceIdsToRemove = $deployments | Where-Object { $_ -and $_ -notmatch '/deployments/' }
        $rawResourceIdsToRemove = $rawResourceIdsToRemove | Sort-Object -Descending -Unique

        # Process removal
        # ===============
        if ($deploymentScope -eq 'subscription') {
            Write-Verbose 'Handle subscription level removal'

            foreach ($rawResourceIdsToRemove in $rawResourceIdsToRemove) {
                if ($rawResourceIdsToRemove.Split('/').count -lt 7) {
                    # resource group
                    $resourcesToRemove += @{
                        resourceId = $rawResourceIdsToRemove
                        name       = $rawResourceIdsToRemove.Split('/')[-1]
                        type       = 'Microsoft.Resources/resourceGroups'
                    }
                } else {
                    $resourcesToRemove += @{
                        resourceId = $rawResourceIdsToRemove
                        name       = $rawResourceIdsToRemove.Split('/')[-1]
                        type       = $rawResourceIdsToRemove.Split('/')[4, 5] -join '/'
                    }
                }
            }
        } elseif ($deploymentScope -eq 'resourceGroup') {
            $allResources = Get-AzResource -ResourceGroupName $resourceGroupName -Name '*'
            # Get all child resources and sort from child to parent
            foreach ($topLevelResource in $rawResourceIdsToRemove) {
                $expandedResources = $allResources | Where-Object { $_.ResourceId.startswith($topLevelResource) }
                $expandedResources = $expandedResources | Sort-Object -Descending -Property { $_.ResourceId.Split('/').Count }
                foreach ($resource in $expandedResources) {
                    $resourcesToRemove += @{
                        resourceId = $resource.ResourceId
                        name       = $resource.Name
                        type       = $resource.Type
                    }
                }
            }
            if ($resourcesToRemove.Count -gt 1) {
                $resourcesToRemove = $resourcesToRemove | Sort-Object -Descending -Property 'ResourceId' -Unique
            }
        }

        # Filter all dependency resources
        $dependencyResourceNames = Get-DependencyResourceNames
        $resourcesToRemove = $resourcesToRemove | Where-Object { $_.Name -notin $dependencyResourceNames }

        # Order resources
        # If virutal machines are contained, remove them first
        if ($vmsContained = $resourcesToRemove | Where-Object { $_.type -eq 'Microsoft.Compute/virtualMachines' }) {
            $resourcesToRemove = $vmsContained + ($resourcesToRemove | Where-Object { $_.type -ne 'Microsoft.Compute/virtualMachines' })
        }

        # If resource groups are contained, remove them second
        if ($rgsContained = $resourcesToRemove | Where-Object { $_.type -eq 'Microsoft.Resources/resourceGroups' }) {
            $resourcesToRemove = $rgsContained + ($resourcesToRemove | Where-Object { $_.type -ne 'Microsoft.Resources/resourceGroups' })
        }

        # Remove resources
        # ----------------
        if ($resourcesToRemove.Count -gt 0) {
            if ($PSCmdlet.ShouldProcess(('[{0}] resources' -f (($resourcesToRemove -is [array]) ? $resourcesToRemove.Count : 1)), 'Remove')) {
                Remove-Resource -resourceToRemove $resourcesToRemove -Verbose
            }
        } else {
            Write-Verbose 'Found [0] resources to remove'
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
