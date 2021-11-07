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
