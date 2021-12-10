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
        'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems' {
            # Remove protected VM
            # Required if e.g. a VM was listed in an RSV and only that VM is removed
            $vaultId = $resourceToRemove.resourceId.split('/backupFabrics/')[0]
            $softDeleteStatus = (Get-AzRecoveryServicesVaultProperty -VaultId $vaultId).SoftDeleteFeatureState
            if ($softDeleteStatus -ne 'Disabled') {
                if ($PSCmdlet.ShouldProcess(('Soft-delete on RSV [{0}]' -f $vaultId), 'Set')) {
                    $null = Set-AzRecoveryServicesVaultProperty -VaultId $vaultId -SoftDeleteFeatureState 'Disable'
                }
            }

            $backupItemInputObject = @{
                BackupManagementType = 'AzureVM'
                WorkloadType         = 'AzureVM'
                VaultId              = $vaultId
                Name                 = $resourceToRemove.name
            }
            if ($backupItem = Get-AzRecoveryServicesBackupItem @backupItemInputObject -ErrorAction 'SilentlyContinue') {
                Write-Verbose ('Removing Backup item [{0}] from RSV [{1}]' -f $backupItem.Name, $vaultId) -Verbose

                if ($backupItem.DeleteState -eq 'ToBeDeleted') {
                    if ($PSCmdlet.ShouldProcess('Soft-deleted backup data removal', 'Undo')) {
                        $null = Undo-AzRecoveryServicesBackupItemDeletion -Item $backupItem -VaultId $vaultId -Force
                    }
                }

                if ($PSCmdlet.ShouldProcess(('Backup item [{0}] from RSV [{1}]' -f $backupItem.Name, $vaultId), 'Remove')) {
                    $null = Disable-AzRecoveryServicesBackupProtection -Item $backupItem -VaultId $vaultId -RemoveRecoveryPoints -Force
                }
            }

            # Undo a potential soft delete state change
            $null = Set-AzRecoveryServicesVaultProperty -VaultId $vaultId -SoftDeleteFeatureState $softDeleteStatus
        }
    }
}
