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

        if (($processedResources | Where-Object { $resource.resourceId -match $_.resourceId }) -and -not (Get-AzResource -ResourceId $resource.resourceId -ErrorAction 'SilentlyContinue')) {
            # Skipping
            Write-Verbose ('Skipping resource [{0}] of type [{1}] as parent resource was already processed' -f $resource.name, $resource.type) -Verbose
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

<#
.SYNOPSIS
Prepare the given resource for removal

.DESCRIPTION
Prepare the given resource for removal. This is required for some resource such as the RSV where we first have to remove its protected items before the RSV itself can be removed

.PARAMETER resourceToRemove
MAndatory. The resource to prepare.Should have format
@{
    name        = '...'
    resourceID = '...'
    type        = '...'
}

.EXAMPLE
Initialize-PreResourceRemoval -resourceToRemove @{ name = 'myVault'; resourceId '(..)/Microsoft.RecoveryServices/vaults/myVault'; type = 'Microsoft.RecoveryServices/vaults'}

Prepare resource 'myVault' of type 'Microsoft.RecoveryServices/vaults' for removal
#>
function Initialize-PreResourceRemoval {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [hashtable] $resourceToRemove
    )

    switch ($resourceToRemove.type) {
        'Microsoft.RecoveryServices/vaults' {
            # Remove protected VMs

            if ((Get-AzRecoveryServicesVaultProperty -VaultId $resourceToRemove.resourceId).SoftDeleteFeatureState -ne 'Disabled') {
                if ($PSCmdlet.ShouldProcess(('Soft-delete on RSV [{0}]' -f $resourceToRemove.name), 'Set')) {
                    $null = Set-AzRecoveryServicesVaultProperty -VaultId $resourceToRemove.resourceId -SoftDeleteFeatureState 'Disable'
                }
            }

            $backupItems = Get-AzRecoveryServicesBackupItem -BackupManagementType 'AzureVM' -WorkloadType 'AzureVM' -VaultId $resourceToRemove.resourceId
            foreach ($backupItem in $backupItems) {
                Write-Verbose ('Removing Backup item [{0}] from RSV [{1}]' -f $backupItem.Name, $resourceToRemove.name) -Verbose

                if ($PSCmdlet.ShouldProcess('Soft-delete backup data removal', 'Undo')) {
                    $null = Undo-AzRecoveryServicesBackupItemDeletion -Item $backupItem -VaultId $resourceToRemove.resourceId -Force
                }

                if ($PSCmdlet.ShouldProcess(('Backup item [{0}] from RSV [{1}]' -f $backupItem.Name, $resourceToRemove.name), 'Remove')) {
                    $null = Disable-AzRecoveryServicesBackupProtection -Item $backupItem -VaultId $resourceToRemove.resourceId -RemoveRecoveryPoints -Force
                }
            }
        }
    }
}

<#
.SYNOPSIS
Remove any artifacts that remain of the given resource

.DESCRIPTION
Remove any artifacts that remain of the given resource. For example, some resources such as key vaults usually go into a soft-delete state from which we want to purge them from.

.PARAMETER resourceToRemove
Mandatory. The resource to remove. Should have format
@{
    name        = '...'
    resourceID = '...'
    type        = '...'
}

.EXAMPLE
Initialize-PostResourceRemoval -resourceToRemove @{ name = 'myVault'; resourceId '(..)/Microsoft.KeyVault/vaults/myVault'; type = 'Microsoft.KeyVault/vaults'}

Purge resource 'myVault' of type 'Microsoft.KeyVault/vaults' if no purge protection is enabled
#>
function Initialize-PostResourceRemoval {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [hashtable] $resourceToRemove
    )

    switch ($resourceToRemove.type) {
        'Microsoft.KeyVault/vaults' {
            $name = $resourceToRemove.resourceId.Split('/')[-1]
            $resourceGroupName = $resourceToRemove.resourceId.Split('/')[4]

            $matchingKeyVault = Get-AzKeyVault -InRemovedState | Where-Object { $_.VaultName -eq $name -and $resourceGroupName -eq $resourceGroupName }
            if ($matchingKeyVault -and -not $resource.EnablePurgeProtection) {
                Write-Verbose "Purging key vault [$name]" -Verbose
                if ($PSCmdlet.ShouldProcess(('Key Vault with ID [{0}]' -f $matchingKeyVault.Id), 'Purge')) {
                    $null = Remove-AzKeyVault -ResourceId $matchingKeyVault.Id -InRemovedState -Force -Location $matchingKeyVault.Location
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
