#region helperScripts
<#
.SYNOPSIS
Remove the given resource(s)

.DESCRIPTION
Remove the given resource(s). Resources that the script fails to removed are returned in an array.

.PARAMETER resourceToRemove
Mandatory. The resource(s) to remove. Each resource must have a name (optional), type (optional) & resourceId property.

.EXAMPLE
Remove-ResourceInner -resourceToRemove @( @{ 'Name' = 'resourceName'; Type = 'Microsoft.Storage/storageAccounts'; ResourceId = 'subscriptions/.../storageAccounts/resourceName' } )
#>
function Remove-ResourceInner {


    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false)]
        [PSObject[]] $resourceToRemove = @()
    )

    $resourceToRemove | ForEach-Object { Write-Verbose ('- Remove [{0}]' -f $_.resourceId) -Verbose }
    $resourcesToRetry = @()
    Write-Verbose '----------------------------------' -Verbose

    foreach ($resource in $resourceToRemove) {

        Write-Verbose ('Trying to remove resource [{0}] of type [{1}]' -f $resource.name, $resource.type) -Verbose
        try {
            if ($PSCmdlet.ShouldProcess(('Resource [{0}]' -f $resource.resourceId), 'Remove')) {
                $null = Remove-AzResource -ResourceId $resource.resourceId -Force -ErrorAction 'Stop'
            }

            # If we removed a parent remove its children
            $resourceToRemove = $resourceToRemove | Where-Object { $_.resourceId -notmatch $resource.resourceId }
            $resourcesToRetry = $resourcesToRetry | Where-Object { $_.resourceId -notmatch $resource.resourceId }
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
Remove all resources in the provided array from Azure. Resources are removed with a retry mechanism.

.PARAMETER resourceToRemove
Optional. The array of resources to remove. Has to contain objects with at least a 'resourceId' property

.EXAMPLE
Remove-Resource @( @{ 'Name' = 'resourceName'; Type = 'Microsoft.Storage/storageAccounts'; ResourceId = 'subscriptions/.../storageAccounts/resourceName' } )

Remove resource with ID 'subscriptions/.../storageAccounts/resourceName'.
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

    $removalRetryCount = 1
    $resourcesToRetry = $resourceToRemove

    do {
        if ($PSCmdlet.ShouldProcess(("[{0}] Resource(s) with a maximum of [$removalRetryLimit] attempts." -f (($resourcesToRetry -is [array]) ? $resourcesToRetry.Count : 1)), 'Remove')) {
            $resourcesToRetry = Remove-ResourceInner -resourceToRemove $resourcesToRetry -Verbose
        } else {
            Remove-ResourceInner -resourceToRemove $resourceToRemove -WhatIf
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
