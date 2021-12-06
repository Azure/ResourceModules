<#
.SYNOPSIS
Remove a deployed module along with its child resources.

.DESCRIPTION
The script will fetch the resources deployed by a deployment and will also fetch any associated resources of the deployed resources like OS and data disks of a VM. Then all the resources will be removed.

.PARAMETER ResourceGroupName
Mandatory. Name of the Resource Group.

.PARAMETER DeploymentName
Mandatory. Name of the deployment of the Resource Group.

.EXAMPLE
Remove-DeployedModuleWithChildResources -ResourceGroupName 'validation-rg' `
                                        -DeploymentName 'virtualMachines-20211201T1212185135Z' `
                                        -Verbose

Remove all the deployed resources created as part of the deployment named 'virtualMachines-20211201T1212185135Z' in the 'validation-rg' resource group.
#>

function Get-AssociatedResources {

    [CmdletBinding()]
    param(
        [Parameter (Mandatory = $true)]
        $ResourceGroupName,

        [Parameter (Mandatory = $true)]
        $ParentResourceId
    )
    $resourceJsonFilePath = (Join-Path $PSScriptRoot $ResourceGroupName) + '.json'

    Export-AzResourceGroup -ResourceGroupName $ResourceGroupName `
        -Resource $ParentResourceId `
        -SkipAllParameterization `
        -Path $resourceJsonFilePath `
        -Confirm:$false -Force | Out-Null
    $filteredIds = (Get-Content -Path $resourceJsonFilePath | Select-String -Pattern '"id"') -replace '\s+'
    if ($filteredIds) {
        Write-Verbose '--------------------------Getting associated resources--------------------------'
        # Write-Verbose "Filtered Ids:`n$($filteredIds | Out-String)"
        foreach ($associatedResourceId in $filteredIds) {
            Write-Verbose "Found: $associatedResourceId"
            [Array]$associatedResourceIds += $associatedResourceId.Split('"')[3]
        }
        Return $associatedResourceIds
    } else {
        Write-Verbose "No further associated resource ids found in the parent resource: '$ParentResourceId'."
        Return $null
    }
}

function Get-DeployedModuleWithChildResources {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String] $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [String] $DeploymentName
    )

    $moduleName = $DeploymentName.Split('-')[0]

    $childResources = ((Get-AzResourceGroupDeploymentOperation `
                -DeploymentName $DeploymentName `
                -ResourceGroupName $ResourceGroupName `
                -Verbose | `
                    Where-Object { $null -ne $_.TargetResource }).TargetResource) | `
                Select-Object -Unique

    Write-Verbose "List of all child resources/deployments:`n$($childResources | Out-String)"

    if ($null -ne $childResources) {
        $resourceIdsToRemove = @()
        foreach ($childResource in $childResources) {
            if ($childResource -match 'Microsoft.Resources/deployments') {
                $childDeploymentName = $childResource.Split('/')[8]
                Write-Verbose '--------------------------Getting Child deployment details--------------------------'
                Write-Verbose "Child deployment name: $childDeploymentName"
                $resourceIdsToRemove += Get-DeployedModuleWithChildResources `
                    -ResourceGroupName $ResourceGroupName `
                    -DeploymentName $childDeploymentName `
                    -Verbose
            } elseif ($childResource -match 'Microsoft.Authorization/roleAssignments') {
                Write-Verbose "Found deployment of type 'Microsoft.Authorization/roleAssignments', skipping any action for now."
                Break
            } else {
                $resourceIdsToRemove += $childResource
                if ($childResource -match $moduleName) {
                    Write-Verbose "Checking for any associated resource ids with the parent resource id: '$($childResource)'."
                    $associatedResourceIds = Get-AssociatedResources -ResourceGroupName $ResourceGroupName -ParentResourceId $childResource
                    if ($null -ne $associatedResourceIds) {
                        $resourceIdsToRemove += $associatedResourceIds
                    } else {
                        Write-Verbose "No associated resources found in resource with Id: '$($childResource)'."
                    }
                } else {
                    Write-Verbose "Not going to find child resources for the resource with id: '$($childResource)'."
                }
                Write-Verbose "Accumulated resource(s): '$($resourceIdsToRemove)."
            }
        }
        Return ($resourceIdsToRemove | Select-Object -Unique)

    } else {
        Write-Verbose "No child resources found in the deployment: '$($DeploymentName)'."
    }
}

function Remove-DeployedModuleWithChildResources {

    param (
        [Parameter(Mandatory = $true)]
        [String] $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [String] $DeploymentName
    )

    $resourceIdsToRemove = Get-DeployedModuleWithChildResources `
        -ResourceGroupName $ResourceGroupName `
        -DeploymentName $DeploymentName `
        -Verbose

    $resourcesToRemove = @()
    foreach ($resourceIdToRemove in $resourceIdsToRemove) {
        $resourcesToRemove += @{
            resourceId = $resourceIdToRemove
            name       = $resourceIdToRemove.Split('/')[-1]
            type       = $resourceIdToRemove.Split('/')[6, 7] -join '/'
        }
    }
    # $resourcesToRemove
    # Load Remove-Resource function
    . (Join-Path $PSScriptRoot 'helper' 'Remove-Resource.ps1')
    Remove-Resource -resourceToRemove $resourcesToRemove
    # Remove residual json file
    $resourceJsonFilePath = (Join-Path $PSScriptRoot $ResourceGroupName) + '.json'
    if(Get-Content -Path $resourceJsonFilePath){
        Remove-Item -Path $resourceJsonFilePath -Force
    }
}
