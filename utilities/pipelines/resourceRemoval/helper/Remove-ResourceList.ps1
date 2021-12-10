#region helperScripts
<#
.SYNOPSIS
Remove the given resource(s)

.DESCRIPTION
Remove the given resource(s). Resources that the script fails to removed are returned in an array.

.PARAMETER resourcesToRemove
Mandatory. The resource(s) to remove. Each resource must have a name (optional), type (optional) & resourceId property.

.EXAMPLE
Remove-ResourceListInner -resourcesToRemove @( @{ 'Name' = 'resourceName'; Type = 'Microsoft.Storage/storageAccounts'; ResourceId = 'subscriptions/.../storageAccounts/resourceName' } )
#>
function Remove-ResourceListInner {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false)]
        [Hashtable[]] $resourcesToRemove = @()
    )

    # Load functions
    . (Join-Path $PSScriptRoot 'Initialize-PreResourceRemoval.ps1')
    . (Join-Path $PSScriptRoot 'Initialize-PostResourceRemoval.ps1')

    $resourcesToRemove | ForEach-Object { Write-Verbose ('- Remove [{0}]' -f $_.resourceId) -Verbose }
    $resourcesToRetry = @()
    $processedResources = @()
    Write-Verbose '----------------------------------' -Verbose

    foreach ($resource in $resourcesToRemove) {

        $alreadyProcessed = $processedResources.count -gt 0 ? (($processedResources | Where-Object { $resource.resourceId -like ('{0}*' -f $_) }).Count -gt 0) : $false

        if ($alreadyProcessed) {
            # Skipping
            Write-Verbose ('Skipping resource [{0}] of type [{1}] as a parent resource was already processed' -f $resource.name, $resource.type) -Verbose
            [array]$processedResources += $resource.resourceId
            [array]$resourcesToRetry = $resourcesToRetry | Where-Object { $_.resourceId -notmatch $resource.resourceId }
        } else {
            Write-Verbose ('Removing resource [{0}] of type [{1}]' -f $resource.name, $resource.type) -Verbose
            try {
                if ($PSCmdlet.ShouldProcess(('Pre-resource-removal for [{0}]' -f $resource.resourceId), 'Execute')) {
                    Initialize-PreResourceRemoval -resourceToRemove $resource
                }

                if ($PSCmdlet.ShouldProcess(('Resource [{0}]' -f $resource.resourceId), 'Remove')) {
                    $null = Remove-AzResource -ResourceId $resource.resourceId -Force -ErrorAction 'Stop'
                }

                # If we removed a parent remove its children
                [array]$processedResources += $resource.resourceId
                [array]$resourcesToRetry = $resourcesToRetry | Where-Object { $_.resourceId -notmatch $resource.resourceId }
            } catch {
                Write-Warning ('Removal moved back for re-try. Reason: [{0}]' -f $_.Exception.Message)
                [array]$resourcesToRetry += $resource
            }
        }

        if ($PSCmdlet.ShouldProcess(('Post-resource-removal for [{0}]' -f $resource.resourceId), 'Execute')) {
            Initialize-PostResourceRemoval -resourceToRemove $resource
        }
    }
    Write-Verbose '----------------------------------' -Verbose
    return $resourcesToRetry
}
#endregion

<#
.SYNOPSIS
Remove all resources in the provided array from Azure

.DESCRIPTION
Remove all resources in the provided array from Azure. Resources are removed with a retry mechanism.

.PARAMETER resourcesToRemove
Optional. The array of resources to remove. Has to contain objects with at least a 'resourceId' property

.EXAMPLE
Remove-ResourceList @( @{ 'Name' = 'resourceName'; Type = 'Microsoft.Storage/storageAccounts'; ResourceId = 'subscriptions/.../storageAccounts/resourceName' } )

Remove resource with ID 'subscriptions/.../storageAccounts/resourceName'.
#>
function Remove-ResourceList {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false)]
        [PSObject[]] $ResourcesToRemove = @(),

        [Parameter(Mandatory = $false)]
        [int] $RemovalRetryLimit = 3,

        [Parameter(Mandatory = $false)]
        [int] $RemovalRetryInterval = 15
    )

    $removalRetryCount = 1
    $resourcesToRetry = $resourcesToRemove

    do {
        if ($PSCmdlet.ShouldProcess(("[{0}] Resource(s) with a maximum of [$removalRetryLimit] attempts." -f (($resourcesToRetry -is [array]) ? $resourcesToRetry.Count : 1)), 'Remove')) {
            $resourcesToRetry = Remove-ResourceListInner -resourcesToRemove $resourcesToRetry -Verbose
        } else {
            Remove-ResourceListInner -resourcesToRemove $resourcesToRemove -WhatIf
        }

        if (-not $resourcesToRetry) {
            break
        }
        Write-Verbose ('Re-try removal of remaining [{0}] resources. Waiting [{1}] seconds. Round [{2}|{3}]' -f (($resourcesToRetry -is [array]) ? $resourcesToRetry.Count : 1), $removalRetryInterval, $removalRetryCount, $removalRetryLimit)
        $removalRetryCount++
        Start-Sleep $removalRetryInterval
    } while ($removalRetryCount -le $removalRetryLimit)

    if ($resourcesToRetry.Count -gt 0) {
        throw ('The removal failed for resources [{0}]' -f ($resourcesToRetry.Name -join ', '))
    } else {
        Write-Verbose 'The removal completed successfully'
    }
}
