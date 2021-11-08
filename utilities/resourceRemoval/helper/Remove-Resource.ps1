#region helperScripts
function Remove-ResourceInner {


    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false)]
        [PSObject[]] $resourceToRemove = @()
    )

    $resourcesToRetry = @()
    Write-Verbose '----------------------------------' -Verbose
    foreach ($resource in $resourceToRemove) {


        if (-not ($id = $resource.ResourceId)) {
            $id = $resource.Id
        }
        if (-not ($type = $resource.ResourceType)) {
            $type = $resource.Type
        }
        if (-not ($name = $resource.name)) {
            $name = $resource.ResourceName
        }

        Write-Verbose ('Trying to remove resource [{0}] of type [{1}]' -f $name, $type) -Verbose
        try {
            if ($PSCmdlet.ShouldProcess(('Resource [{0}]' -f $id), 'Remove')) {
                $null = Remove-AzResource -ResourceId $id -Force -ErrorAction 'Stop'
            }
        } catch {
            Write-Warning ('Removal moved back for re-try. Reason: [{0}]' -f $_.Exception.Message)
            $resourcesToRetry += $resource
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
Remove all resources in the provided array from Azure.
All resources for which the removal failed are returned in an array.

.PARAMETER resourceToRemove
Optional. The array of resources to remove. Has to contain objects with at least a 'resourceId' property

.EXAMPLE
Remove-Resource @( @{ 'Name' = 'resourceName'; ResourceType = 'Microsoft.Storage/storageAccounts'; ResourceId = 'subscriptions/.../storageAccounts/resourceName' } )

Remove resource with id 'subscriptions/.../storageAccounts/resourceName'.
#>
function Remove-Resource {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false)]
        [PSObject[]] $resourceToRemove = @(),

        [Parameter(Mandatory = $false)]
        [int] $removalRetryLimit = 3,

        [Parameter(Mandatory = $false)]
        [int] $removalRetryInterval = 15
    )

    $currentRetry = 0
    $resourcesToRetry = $resourceToRemove
    if ($PSCmdlet.ShouldProcess(("[{0}] Resource(s) with a maximum of [$removalRetryLimit] attempts." -f $resourcesToRetry.Count), 'Remove')) {
        while (($resourcesToRetry = Remove-ResourceInner -resourceToRemove $resourcesToRetry -Verbose).Count -gt 0 -and $currentRetry -le $removalRetryLimit) {
            Write-Verbose ('Re-try removal of remaining [{0}] resources. Waiting [{1}] seconds. Round [{2}|{3}]' -f $resourcesToRetry.Count, $removalRetryInterval, $currentRetry, $removalRetryLimit)
            $currentRetry++
            Start-Sleep $removalRetryInterval
        }

        if ($resourcesToRetry.Count -gt 0) {
            throw ('The removal failed for resources [{0}]' -f ($resourcesToRetry.Name -join ', '))
        } else {
            Write-Verbose 'The removal completed successfully'
        }
    } else {
        Remove-ResourceInner -resourceToRemove $resourceToRemove -WhatIf
    }
}
