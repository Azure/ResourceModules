<#
.SYNOPSIS
Remove all resources in the provided array from Azure

.DESCRIPTION
Remove all resources in the provided array from Azure.
All resources for which the removal failed are returned in an array.

.PARAMETER resourcesToRemove
Optional. The array of resources to remove. Has to contain objects with at least a 'resourceId' property

.EXAMPLE
Remove-Resource @( @{ 'Name' = 'resourceName'; ResourceType = 'Microsoft.Storage/storageAccounts'; ResourceId = 'subscriptions/.../storageAccounts/resourceName' } )

Remove resource with id 'subscriptions/.../storageAccounts/resourceName'.
#>
function Remove-Resource {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false)]
        [PSObject[]] $resourcesToRemove = @()
    )

    $resourcesToRetry = @()
    Write-Verbose '----------------------------------' -Verbose
    foreach ($resource in $resourcesToRemove) {
        Write-Verbose ('Trying to remove resource [{0}] of type [{1}]' -f $resource.Name, $resource.ResourceType) -Verbose
        try {
            if ($PSCmdlet.ShouldProcess(('Resource [{0}]' -f $resource.ResourceId), 'Remove')) {

            }
            $null = Remove-AzResource -ResourceId $resource.ResourceId -Force -ErrorAction 'Stop'
        } catch {
            Write-Warning ('Removal moved back for re-try. Reason: [{0}]' -f $_.Exception.Message)
            $resourcesToRetry += $resource
        }
    }
    Write-Verbose '----------------------------------' -Verbose
    return $resourcesToRetry
}
