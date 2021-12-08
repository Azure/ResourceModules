#region helper

<#
.SYNOPSIS
Get all deployments that match a given deployment name in a given scope

.DESCRIPTION
Get all deployments that match a given deployment name in a given scope. Works recursively through the deployment tree.

.PARAMETER Name
Mandatory. The deployment name to search for

.PARAMETER ResourceGroupName
Optional. The name of the resource group for scope 'resourceGroup'

.PARAMETER Scope
Mandatory. The scope to search in

.EXAMPLE
Get-DeploymentByName -Name 'keyvault-12356' -Scope 'resourceGroup'

Get all deployments that match name 'keyvault-12356' in scope 'resourceGroup'

.NOTES
Works after the principal:
- Find all deployments for the given deployment name
- If any of them are not a deployments, add their target resource to the result set (as they are e.g. a resource)
- If any of them is are deployments, recursively invoke this function for them to get their contained target resources
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
            if (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction 'SilentlyContinue') {
                [array]$deploymentTargets = (Get-AzResourceGroupDeploymentOperation -DeploymentName $name -ResourceGroupName $resourceGroupName).TargetResource | Where-Object { $_ -ne $null }
                foreach ($deployment in ($deploymentTargets | Where-Object { $_ -notmatch '/deployments/' } )) {
                    [array]$resultSet += $deployment
                }
                foreach ($deployment in ($deploymentTargets | Where-Object { $_ -match '/deployments/' } )) {
                    $name = Split-Path $deployment -Leaf
                    $resourceGroupName = $deployment.split('/resourceGroups/')[1].Split('/')[0]
                    [array]$resultSet += Get-DeploymentByName -Name $name -ResourceGroupName $ResourceGroupName -Scope 'resourceGroup'
                }
            } else {
                # In case the resource group itself was already deleted, there is no need to try and fetch deployments from it
                # In case we already have any such resources in the list, we should remove them
                [array]$resultSet = $resultSet | Where-Object { $_ -notmatch "/resourceGroups/$resourceGroupName/" }
            }
        }
        'subscription' {
            [array]$deploymentTargets = (Get-AzDeploymentOperation -DeploymentName $name).TargetResource | Where-Object { $_ -ne $null }
            foreach ($deployment in ($deploymentTargets | Where-Object { $_ -notmatch '/deployments/' } )) {
                [array]$resultSet += $deployment
            }
            foreach ($deployment in ($deploymentTargets | Where-Object { $_ -match '/deployments/' } )) {
                [array]$resultSet = $resultSet | Where-Object { $_ -ne $deployment }
                if ($deployment -match '/resourceGroups/') {
                    # Resource Group Level Child Deployments
                    $name = Split-Path $deployment -Leaf
                    $resourceGroupName = $deployment.split('/resourceGroups/')[1].Split('/')[0]
                    [array]$resultSet += Get-DeploymentByName -Name $name -ResourceGroupName $ResourceGroupName -Scope 'resourceGroup'
                } else {
                    # Subscription Level Deployments
                    [array]$resultSet += Get-DeploymentByName -name (Split-Path $deployment -Leaf) -Scope 'subscription'
                }
            }
        }
        'managementGroup' {
            [array]$deploymentTargets = (Get-AzManagementGroupDeploymentOperation -DeploymentName $name).TargetResource | Where-Object { $_ -ne $null }
            foreach ($deployment in ($deploymentTargets | Where-Object { $_ -notmatch '/deployments/' } )) {
                [array]$resultSet += $deployment
            }
            foreach ($deployment in ($deploymentTargets | Where-Object { $_ -match '/deployments/' } )) {
                [array]$resultSet = $resultSet | Where-Object { $_ -ne $deployment }
                if ($deployment -match '/managementGroup/') {
                    # Subscription Level Child Deployments
                    [array]$resultSet += Get-DeploymentByName -Name (Split-Path $deployment -Leaf) -Scope 'subscription'
                } else {
                    # Management Group Level Deployments
                    [array]$resultSet += Get-DeploymentByName -name (Split-Path $deployment -Leaf) -scope 'managementGroup'
                }
            }
        }
        'tenant' {
            [array]$deploymentTargets = (Get-AzTenantDeploymentOperation -DeploymentName $name).TargetResource | Where-Object { $_ -ne $null }
            foreach ($deployment in ($deploymentTargets | Where-Object { $_ -notmatch '/deployments/' } )) {
                [array]$resultSet += $deployment
            }
            foreach ($deployment in ($deploymentTargets | Where-Object { $_ -match '/deployments/' } )) {
                [array]$resultSet = $resultSet | Where-Object { $_ -ne $deployment }
                if ($deployment -match '/tenant/') {
                    # Management Group Level Child Deployments
                    [array]$resultSet += Get-DeploymentByName -Name (Split-Path $deployment -Leaf) -scope 'managementGroup'
                } else {
                    # Tenant Level Deployments
                    [array]$resultSet += Get-DeploymentByName -name (Split-Path $deployment -Leaf)
                }
            }
        }
    }
    return $resultSet
}


<#
.SYNOPSIS
Format the provide resource IDs into objects of resourceID, name & type

.DESCRIPTION
Format the provide resource IDs into objects of resourceID, name & type

.PARAMETER resourceIds
Optional. The resource IDs to process

.EXAMPLE
Get-FormattedResources -resourceIds @('/subscriptions/<subscriptionID>/resourceGroups/test-analysisServices-parameters.json-rg/providers/Microsoft.Storage/storageAccounts/adpsxxazsaaspar01')

Returns an object @{
    resourceId = '/subscriptions/<subscriptionID>/resourceGroups/test-analysisServices-parameters.json-rg/providers/Microsoft.Storage/storageAccounts/adpsxxazsaaspar01'
    type       = 'Microsoft.Storage/storageAccounts'
    name       = 'adpsxxazsaaspar01'
}
#>
function Get-FormattedResources {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string[]] $resourceIds = @()
    )

    $formattedResources = [System.Collections.ArrayList]@()

    # Optional resourceGroup-level resources to identify implicitly deployed child-resources
    $allResourceGroupResources = @()

    foreach ($resourceId in $resourceIds) {

        $idElements = $resourceId.Split('/')

        switch ($idElements.Count) {
            { $PSItem -eq 5 } {
                # subscription level resource group
                $formattedResources += @{
                    resourceId = $resourceId
                    name       = $idElements[-1]
                    type       = 'Microsoft.Resources/resourceGroups'
                }
                break
            }
            { $PSItem -eq 6 } {
                # subscription level resource
                $formattedResources += @{
                    resourceId = $resourceId
                    name       = $idElements[-1]
                    type       = $idElements[4, 5] -join '/'
                }
                break
            }
            { $PSItem -eq 7 } {
                # resource group level
                if ($allResourceGroupResources.Count -eq 0) {
                    $allResourceGroupResources = Get-AzResource -ResourceGroupName $resourceGroupName -Name '*'
                }
                $expandedResources = $allResources | Where-Object { $_.ResourceId.startswith($resourceId) }
                $expandedResources = $expandedResources | Sort-Object -Descending -Property { $_.ResourceId.Split('/').Count }
                foreach ($resource in $expandedResources) {
                    $formattedResources += @{
                        resourceId = $resource.ResourceId
                        name       = $resource.Name
                        type       = $resource.Type
                    }
                }
                break
            }
            { $PSItem -ge 8 } {
                # child-resource level
                $indexOfResourceType = $idElements.IndexOf(($idElements -like 'Microsoft.**')[0])
                $type = $idElements[$indexOfResourceType, ($indexOfResourceType + 1)] -join '/'

                # Concat rest of resource type along the ID
                $partCounter = $indexOfResourceType + 1
                while (-not ($partCounter + 2 -gt $idElements.Count - 1)) {
                    $type += ('/{0}' -f $idElements[($partCounter + 2)])
                    $partCounter = $partCounter + 2
                }

                $formattedResources += @{
                    resourceId = $resourceId
                    name       = $idElements[-1]
                    type       = $type
                }
                break
            }
            Default {
                throw "Failed to process resource ID [$resourceId]"
            }
        }
    }

    return $formattedResources
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
        Write-Verbose "Determined deployment scope [$deploymentScope]" -Verbose

        # Fundamental checks
        if ($deploymentScope -eq 'resourceGroup' -and -not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction 'SilentlyContinue')) {
            Write-Verbose "Resource group [$ResourceGroupName] does not exist (anymore). Skipping removal of its contained resources" -Verbose
            return
        }

        # Fetch deployments
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

        # Pre-Filter & order items
        # ========================
        $rawResourceIdsToRemove = $deployments | Where-Object { $_ -and $_ -notmatch '/deployments/' }
        $rawResourceIdsToRemove = $rawResourceIdsToRemove | Sort-Object -Property { $_.Split('/').Count } -Unique

        if ($rawResourceIdsToRemove.Count -eq 0) {
            Write-Verbose 'Found no relevant resources to remove' -Verbose
            return
        }

        # Format items
        # ============
        $resourcesToRemove = Get-FormattedResources -resourceIds $rawResourceIdsToRemove

        # Filter all dependency resources
        # ===============================
        $dependencyResourceNames = Get-DependencyResourceNames
        $resourcesToRemove = $resourcesToRemove | Where-Object { $_.Name -notin $dependencyResourceNames }

        # Order resources
        # ===============
        # If virutal machines are contained, remove them first
        if ($vmsContained = $resourcesToRemove | Where-Object { $_.type -eq 'Microsoft.Compute/virtualMachines' }) {
            $resourcesToRemove = @() + $vmsContained + ($resourcesToRemove | Where-Object { $_.type -ne 'Microsoft.Compute/virtualMachines' })
        }

        # If resource groups are contained, remove them second
        if ($rgsContained = $resourcesToRemove | Where-Object { $_.type -eq 'Microsoft.Resources/resourceGroups' }) {
            $resourcesToRemove = @() + $rgsContained + ($resourcesToRemove | Where-Object { $_.type -ne 'Microsoft.Resources/resourceGroups' })
        }

        # Remove resources
        # ================
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
