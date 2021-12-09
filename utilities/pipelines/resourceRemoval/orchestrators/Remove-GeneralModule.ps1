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
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Remove-Resource.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-DependencyResourceNames.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-DeploymentByName.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-ResourceIdsAsFormattedObjectList.ps1')
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
        $rawResourceIdsToRemove = $deployments | Sort-Object -Property { $_.Split('/').Count } -Descending | Select-Object -Unique

        if ($rawResourceIdsToRemove.Count -eq 0) {
            Write-Verbose 'Found no relevant resources to remove' -Verbose
            return
        }

        # Format items
        # ============
        $resourcesToRemove = Get-ResourceIdsAsFormattedObjectLists -resourceIds $rawResourceIdsToRemove

        # Filter all dependency resources
        # ===============================
        $dependencyResourceNames = Get-DependencyResourceNames
        $resourcesToRemove = $resourcesToRemove | Where-Object { $_.Name -notin $dependencyResourceNames }

        # Order resources
        # ===============
        # If virtual machines are contained, remove them first
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
