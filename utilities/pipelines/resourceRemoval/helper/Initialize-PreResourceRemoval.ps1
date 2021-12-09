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
                if ($PSCmdlet.ShouldProcess(('Soft-delete on RSV [{0}]' -f $resourceToRemove.resourceId), 'Set')) {
                    $null = Set-AzRecoveryServicesVaultProperty -VaultId $resourceToRemove.resourceId -SoftDeleteFeatureState 'Disable'
                }
            }

            $backupItems = Get-AzRecoveryServicesBackupItem -BackupManagementType 'AzureVM' -WorkloadType 'AzureVM' -VaultId $resourceToRemove.resourceId
            foreach ($backupItem in $backupItems) {
                Write-Verbose ('Removing Backup item [{0}] from RSV [{1}]' -f $backupItem.Name, $resourceToRemove.resourceId) -Verbose

                if ($backupItem.DeleteState -eq 'ToBeDeleted') {
                    if ($PSCmdlet.ShouldProcess('Soft-deleted backup data removal', 'Undo')) {
                        $null = Undo-AzRecoveryServicesBackupItemDeletion -Item $backupItem -VaultId $resourceToRemove.resourceId -Force
                    }
                }

                if ($PSCmdlet.ShouldProcess(('Backup item [{0}] from RSV [{1}]' -f $backupItem.Name, $resourceToRemove.resourceId), 'Remove')) {
                    $null = Disable-AzRecoveryServicesBackupProtection -Item $backupItem -VaultId $resourceToRemove.resourceId -RemoveRecoveryPoints -Force
                }
            }
        }
    }
}
