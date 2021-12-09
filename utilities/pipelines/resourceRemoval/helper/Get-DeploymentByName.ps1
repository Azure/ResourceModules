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
