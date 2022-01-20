#region helper
<#
.SYNOPSIS
Get all deployments that match a given deployment name in a given scope

.DESCRIPTION
Get all deployments that match a given deployment name in a given scope. Works recursively through the deployment tree.

.PARAMETER Name
Mandatory. The deployment name to search for

.PARAMETER ResourceGroupName
Optional. The name of the resource group for scope 'resourcegroup'

.PARAMETER Scope
Mandatory. The scope to search in

.EXAMPLE
Get-DeploymentTargetResourceListInner -Name 'keyvault-12356' -Scope 'resourcegroup'

Get all deployments that match name 'keyvault-12356' in scope 'resourcegroup'

.NOTES
Works after the principal:
- Find all deployments for the given deployment name
- If any of them are not a deployments, add their target resource to the result set (as they are e.g. a resource)
- If any of them is are deployments, recursively invoke this function for them to get their contained target resources
#>
function Get-DeploymentTargetResourceListInner {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory)]
        [ValidateSet(
            'resourcegroup',
            'subscription',
            'managementgroup',
            'tenant'
        )]
        [string] $Scope
    )

    $resultSet = [System.Collections.ArrayList]@()
    switch ($Scope) {
        'resourcegroup' {
            if (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction 'SilentlyContinue') {
                [array]$deploymentTargets = (Get-AzResourceGroupDeploymentOperation -DeploymentName $name -ResourceGroupName $resourceGroupName).TargetResource | Where-Object { $_ -ne $null }
                foreach ($deployment in ($deploymentTargets | Where-Object { $_ -notmatch '/deployments/' } )) {
                    Write-Verbose ('Found deployed resource [{0}]' -f $deployment) -Verbose
                    [array]$resultSet += $deployment
                }
                foreach ($deployment in ($deploymentTargets | Where-Object { $_ -match '/deployments/' } )) {
                    $name = Split-Path $deployment -Leaf
                    $resourceGroupName = $deployment.split('/resourceGroups/')[1].Split('/')[0]
                    [array]$resultSet += Get-DeploymentTargetResourceListInner -Name $name -ResourceGroupName $ResourceGroupName -Scope 'resourcegroup'
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
                Write-Verbose ('Found deployed resource [{0}]' -f $deployment) -Verbose
                [array]$resultSet += $deployment
            }
            foreach ($deployment in ($deploymentTargets | Where-Object { $_ -match '/deployments/' } )) {
                [array]$resultSet = $resultSet | Where-Object { $_ -ne $deployment }
                if ($deployment -match '/resourceGroups/') {
                    # Resource Group Level Child Deployments
                    $name = Split-Path $deployment -Leaf
                    $resourceGroupName = $deployment.split('/resourceGroups/')[1].Split('/')[0]
                    [array]$resultSet += Get-DeploymentTargetResourceListInner -Name $name -ResourceGroupName $ResourceGroupName -Scope 'resourcegroup'
                } else {
                    # Subscription Level Deployments
                    [array]$resultSet += Get-DeploymentTargetResourceListInner -name (Split-Path $deployment -Leaf) -Scope 'subscription'
                }
            }
        }
        'managementgroup' {
            [array]$deploymentTargets = (Get-AzManagementGroupDeploymentOperation -DeploymentName $name).TargetResource | Where-Object { $_ -ne $null }
            foreach ($deployment in ($deploymentTargets | Where-Object { $_ -notmatch '/deployments/' } )) {
                Write-Verbose ('Found deployed resource [{0}]' -f $deployment) -Verbose
                [array]$resultSet += $deployment
            }
            foreach ($deployment in ($deploymentTargets | Where-Object { $_ -match '/deployments/' } )) {
                [array]$resultSet = $resultSet | Where-Object { $_ -ne $deployment }
                if ($deployment -match '/managementGroup/') {
                    # Subscription Level Child Deployments
                    [array]$resultSet += Get-DeploymentTargetResourceListInner -Name (Split-Path $deployment -Leaf) -Scope 'subscription'
                } else {
                    # Management Group Level Deployments
                    [array]$resultSet += Get-DeploymentTargetResourceListInner -name (Split-Path $deployment -Leaf) -scope 'managementgroup'
                }
            }
        }
        'tenant' {
            [array]$deploymentTargets = (Get-AzTenantDeploymentOperation -DeploymentName $name).TargetResource | Where-Object { $_ -ne $null }
            foreach ($deployment in ($deploymentTargets | Where-Object { $_ -notmatch '/deployments/' } )) {
                Write-Verbose ('Found deployed resource [{0}]' -f $deployment) -Verbose
                [array]$resultSet += $deployment
            }
            foreach ($deployment in ($deploymentTargets | Where-Object { $_ -match '/deployments/' } )) {
                [array]$resultSet = $resultSet | Where-Object { $_ -ne $deployment }
                if ($deployment -match '/tenant/') {
                    # Management Group Level Child Deployments
                    [array]$resultSet += Get-DeploymentTargetResourceListInner -Name (Split-Path $deployment -Leaf) -scope 'managementgroup'
                } else {
                    # Tenant Level Deployments
                    [array]$resultSet += Get-DeploymentTargetResourceListInner -name (Split-Path $deployment -Leaf)
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

.PARAMETER Scope
Mandatory. The scope to search in

.PARAMETER SearchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag

.PARAMETER SearchRetryInterval
Optional. The time to wait in between the search for resources via their remove tags

.EXAMPLE
Get-DeploymentTargetResourceList -name 'KeyVault' -ResourceGroupName 'validation-rg' -scope 'resourcegroup'

Get all deployments that match name 'KeyVault' in scope 'resourcegroup' of resource group 'validation-rg'
#>
function Get-DeploymentTargetResourceList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'resourcegroup',
            'subscription',
            'managementgroup',
            'tenant'
        )]
        [string] $Scope,

        [Parameter(Mandatory = $false)]
        [int] $SearchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $SearchRetryInterval = 60
    )

    $searchRetryCount = 1
    do {
        [array]$targetResources = Get-DeploymentTargetResourceListInner -Name $name -Scope $scope -ResourceGroupName $resourceGroupName -ErrorAction 'SilentlyContinue'
        if ($targetResources) {
            break
        }
        Write-Verbose ('Did not to find deployments by name [{0}] in scope [{1}]. Retrying in [{2}] seconds [{3}/{4}]' -f $name, $scope, $searchRetryInterval, $searchRetryCount, $searchRetryLimit) -Verbose
        Start-Sleep $searchRetryInterval
        $searchRetryCount++
    } while ($searchRetryCount -le $searchRetryLimit)

    if (-not $targetResources) {
        throw "No deployment target resources found for [$name]"
    }

    return $targetResources
}
