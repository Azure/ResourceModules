<#
.SYNOPSIS
Remove a specific resource

.DESCRIPTION
Remove a specific resource. Tries to handle different resource types accordingly

.PARAMETER resourceId
Mandatory. The resourceID of the resource to remove

.PARAMETER name
Mandatory. The name of the resource to remove

.PARAMETER type
Mandatory. The type of the resource to remove

.EXAMPLE
Invoke-ResourceRemoval -name 'sxx-vm-linux-001-nic-01-diagnosticSettings' -type 'Microsoft.Insights/diagnosticSettings' -resourceId '/subscriptions/a7439831-1cd9-435d-a091-4aa863c96556/resourceGroups/validation-rg/providers/Microsoft.Network/networkInterfaces/sxx-vm-linux-001-nic-01/providers/Microsoft.Insights/diagnosticSettings/sxx-vm-linux-001-nic-01-diagnosticSettings'

Remove the resource 'sxx-vm-linux-001-nic-01-diagnosticSettings' of type 'Microsoft.Insights/diagnosticSettings' from resource '/subscriptions/a7439831-1cd9-435d-a091-4aa863c96556/resourceGroups/validation-rg/providers/Microsoft.Network/networkInterfaces/sxx-vm-linux-001-nic-01'
#>
function Invoke-ResourceRemoval {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $resourceId,

        [Parameter(Mandatory = $true)]
        [string] $name,

        [Parameter(Mandatory = $true)]
        [string] $type
    )

    switch ($type) {
        'Microsoft.Insights/diagnosticSettings' {
            $parentResourceId = $resourceId.Split('/providers/{0}' -f $type)[0]
            if ($PSCmdlet.ShouldProcess("Diagnostic setting [$name]", 'Remove')) {
                $null = Remove-AzDiagnosticSetting -ResourceId $parentResourceId -Name $name
            }
            break
        }
        'Microsoft.RecoveryServices/vaults' {
            # Pre-Removal
            # -----------
            # Remove protected VMs
            if ((Get-AzRecoveryServicesVaultProperty -VaultId $resourceId).SoftDeleteFeatureState -ne 'Disabled') {
                if ($PSCmdlet.ShouldProcess(('Soft-delete on RSV [{0}]' -f $resourceId), 'Set')) {
                    $null = Set-AzRecoveryServicesVaultProperty -VaultId $resourceId -SoftDeleteFeatureState 'Disable'
                }
            }

            $backupItems = Get-AzRecoveryServicesBackupItem -BackupManagementType 'AzureVM' -WorkloadType 'AzureVM' -VaultId $resourceId
            foreach ($backupItem in $backupItems) {
                Write-Verbose ('Removing Backup item [{0}] from RSV [{1}]' -f $backupItem.Name, $resourceId) -Verbose

                if ($backupItem.DeleteState -eq 'ToBeDeleted') {
                    if ($PSCmdlet.ShouldProcess('Soft-deleted backup data removal', 'Undo')) {
                        $null = Undo-AzRecoveryServicesBackupItemDeletion -Item $backupItem -VaultId $resourceId -Force
                    }
                }

                if ($PSCmdlet.ShouldProcess(('Backup item [{0}] from RSV [{1}]' -f $backupItem.Name, $resourceId), 'Remove')) {
                    $null = Disable-AzRecoveryServicesBackupProtection -Item $backupItem -VaultId $resourceId -RemoveRecoveryPoints -Force
                }
            }

            # Actual removal
            # --------------
            $null = Remove-AzResource -ResourceId $resourceId -Force -ErrorAction 'Stop'
        }
        Default {
            $null = Remove-AzResource -ResourceId $resourceId -Force -ErrorAction 'Stop'
        }
    }
}
