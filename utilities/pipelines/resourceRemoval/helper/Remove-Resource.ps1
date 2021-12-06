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
        [Hashtable[]] $resourceToRemove = @()
    )

    $resourceToRemove | ForEach-Object { Write-Verbose ('- Remove [{0}]' -f $_.resourceId) -Verbose }
    $resourcesToRetry = @()
    $processedResources = @()
    Write-Verbose '----------------------------------' -Verbose

    foreach ($resource in $resourceToRemove) {

        $resource = Assert-PurgeProtectedResource -resourceToAssert $resource

        if (($processedResources | Where-Object { $resource.resourceId -match $_.resourceId }) -and -not (Get-AzResource -ResourceId $resource.resourceId -ErrorAction 'SilentlyContinue')) {
            # Skipping
            Write-Verbose ('Skipping resource [{0}] of type [{1}] as parent resource was already processed' -f $resource.name, $resource.type) -Verbose
            [array]$processedResources += $resource.resourceId
            [array]$resourcesToRetry = $resourcesToRetry | Where-Object { $_.resourceId -notmatch $resource.resourceId }
        } else {

            Write-Verbose ('Removing resource [{0}] of type [{1}]' -f $resource.name, $resource.type) -Verbose
            try {
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

        # Process purge
        Remove-PurgeProtectedResource -resourceToRemove $resource
    }
    Write-Verbose '----------------------------------' -Verbose
    return $resourcesToRetry
}

<#
.SYNOPSIS
Fetch data that is needed to purge the given resource

.DESCRIPTION
Fetch data that is needed to purge the given resource

.PARAMETER resourceToAssert
Mandatory. The resource to fetch the data for
@{
    name        = '...'
    resourceID = '...'
    type        = '...'
}

.EXAMPLE
Assert-PurgeProtectedResource -resourceToAssert  @{ name = 'myVault'; resourceId '(..)/Microsoft.KeyVault/vaults/myVault'; type = 'Microsoft.KeyVault/vaults'}

Fetch required data of the given key vault (e.g. its location that is required for its purge command)
#>
function Assert-PurgeProtectedResource {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable] $resourceToAssert
    )

    switch ($resource.type) {
        'Microsoft.KeyVault/vaults' {
            $name = $resourceToAssert.resourceId.Split('/')[-1]
            $resourceGroupName = $resourceToAssert.resourceId.Split('/')[4]
            Write-Verbose "Fetching key vault [$name] from resource group [$resourceGroupName] to assert properties to enable removal" -Verbose
            $keyVault = Get-AzKeyVault -VaultName $name -ResourceGroupName $resourceGroupName
            $resourceToAssert['location'] = $keyVault.Location
            $resourceToAssert['enablePurgeProtection'] = $keyVault.EnablePurgeProtection
        }
    }

    return $resourceToAssert
}

<#
.SYNOPSIS
Purge the given resource if possible

.DESCRIPTION
Purge the given resource if possible and no protection is enabled

.PARAMETER resourceToRemove
Mandatory. The resource to purge. Should have format
@{
    name        = '...'
    resourceID = '...'
    type        = '...'
}

.EXAMPLE
Remove-PurgeProtectedResource -resourceToRemove @{ name = 'myVault'; resourceId '(..)/Microsoft.KeyVault/vaults/myVault'; type = 'Microsoft.KeyVault/vaults'}

Purge resource 'myVault' of type 'Microsoft.KeyVault/vaults' if no purge protection is enabled
#>
function Remove-PurgeProtectedResource {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [hashtable] $resourceToRemove
    )

    switch ($resource.type) {
        'Microsoft.KeyVault/vaults' {
            if (-not $resource.EnablePurgeProtection) {
                Write-Verbose ('Purging key vault [{0}]' -f $resource.name, $resource.type) -Verbose
                if ($PSCmdlet.ShouldProcess(('Key Vault [{0}]' -f $resource.resourceId), 'Purge')) {
                    $null = Remove-AzKeyVault -ResourceId $resource.resourceId -InRemovedState -Force -Location $resource.Location
                }
            }
        }
    }
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
