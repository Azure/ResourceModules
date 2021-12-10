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
Get-ResourceIdsOfDeploymentInner -Name 'keyvault-12356' -Scope 'resourceGroup'

Get all deployments that match name 'keyvault-12356' in scope 'resourceGroup'

.NOTES
Works after the principal:
- Find all deployments for the given deployment name
- If any of them are not a deployments, add their target resource to the result set (as they are e.g. a resource)
- If any of them is are deployments, recursively invoke this function for them to get their contained target resources
#>
function Get-ResourceIdsOfDeploymentInner {

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
                    [array]$resultSet += Get-ResourceIdsOfDeploymentInner -Name $name -ResourceGroupName $ResourceGroupName -Scope 'resourceGroup'
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
                    [array]$resultSet += Get-ResourceIdsOfDeploymentInner -Name $name -ResourceGroupName $ResourceGroupName -Scope 'resourceGroup'
                } else {
                    # Subscription Level Deployments
                    [array]$resultSet += Get-ResourceIdsOfDeploymentInner -name (Split-Path $deployment -Leaf) -Scope 'subscription'
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
                    [array]$resultSet += Get-ResourceIdsOfDeploymentInner -Name (Split-Path $deployment -Leaf) -Scope 'subscription'
                } else {
                    # Management Group Level Deployments
                    [array]$resultSet += Get-ResourceIdsOfDeploymentInner -name (Split-Path $deployment -Leaf) -scope 'managementGroup'
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
                    [array]$resultSet += Get-ResourceIdsOfDeploymentInner -Name (Split-Path $deployment -Leaf) -scope 'managementGroup'
                } else {
                    # Tenant Level Deployments
                    [array]$resultSet += Get-ResourceIdsOfDeploymentInner -name (Split-Path $deployment -Leaf)
                }
            }
        }
    }
    return $resultSet
}
#endregion

<#
.SYNOPSIS
Get all deployments that match a given deployment name in a given scope using a retry mechanic

.DESCRIPTION
Get all deployments that match a given deployment name in a given scope using a retry mechanic.

.PARAMETER ResourceGroupName
Mandatory. The resource group of the resource to remove

.PARAMETER Name
Optional. The deployment name to use for the removal

.PARAMETER scope
Mandatory. The scope to search in

.PARAMETER SearchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag

.PARAMETER SearchRetryInterval
Optional. The time to wait in between the search for resources via their remove tags

.EXAMPLE
Get-ResourceIdsOfDeployment -name 'KeyVault' -ResourceGroupName 'validation-rg' -scope 'resourceGroup'

Get all deployments that match name 'KeyVault' in scope 'resourceGroup' of resource group 'validation-rg'
#>
function Get-ResourceIdsOfDeployment {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [string] $name,

        [Parameter(Mandatory = $true)]
        [string] $scope,

        [Parameter(Mandatory = $false)]
        [int] $SearchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $SearchRetryInterval = 60
    )

    $searchRetryCount = 1
    do {
        [array]$deployments = Get-ResourceIdsOfDeploymentInner -name $name -scope $scope -resourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue'
        if ($deployments) {
            break
        }
        Write-Verbose ('Did not to find deployments by name [{0}] in scope [{1}]. Retrying in [{2}] seconds [{3}/{4}]' -f $name, $scope, $searchRetryInterval, $searchRetryCount, $searchRetryLimit) -Verbose
        Start-Sleep $searchRetryInterval
        $searchRetryCount++
    } while ($searchRetryCount -le $searchRetryLimit)

    if (-not $deployments) {
        throw "No deployment found for [$name]"
    }

    return $deployments
}
