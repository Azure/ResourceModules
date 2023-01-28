<#
.SYNOPSIS
Remove a specific resource

.DESCRIPTION
Remove a specific resource. Tries to handle different resource types accordingly

.PARAMETER ResourceId
Mandatory. The resourceID of the resource to remove

.PARAMETER Type
Mandatory. The type of the resource to remove

.EXAMPLE
Invoke-ResourceRemoval -Type 'Microsoft.Insights/diagnosticSettings' -ResourceId '/subscriptions/.../resourceGroups/validation-rg/providers/Microsoft.Network/networkInterfaces/sxx-vm-linux-001-nic-01/providers/Microsoft.Insights/diagnosticSettings/sxx-vm-linux-001-nic-01-diagnosticSettings'

Remove the resource 'sxx-vm-linux-001-nic-01-diagnosticSettings' of type 'Microsoft.Insights/diagnosticSettings' from resource '/subscriptions/.../resourceGroups/validation-rg/providers/Microsoft.Network/networkInterfaces/sxx-vm-linux-001-nic-01'
#>
function Invoke-ResourceRemoval {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceId,

        [Parameter(Mandatory = $true)]
        [string] $Type
    )

    switch ($type) {
        'Microsoft.Insights/diagnosticSettings' {
            $parentResourceId = $resourceId.Split('/providers/{0}' -f $type)[0]
            $resourceName = Split-Path $ResourceId -Leaf
            if ($PSCmdlet.ShouldProcess("Diagnostic setting [$resourceName]", 'Remove')) {
                $null = Remove-AzDiagnosticSetting -ResourceId $parentResourceId -Name $resourceName
            }
            break
        }
        'Microsoft.Authorization/locks' {
            $lockName = ($resourceId -split '/')[-1]
            $lockScope = ($resourceId -split '/providers/Microsoft.Authorization/locks')[0]

            $null = Remove-AzResourceLock -LockName $lockName -Scope $lockScope -Force
            Write-Verbose "Removed lock [$resourceName]. Waiting 10 seconds for propagation." -Verbose
            Start-Sleep 10
            break
        }
        'Microsoft.KeyVault/vaults/keys' {
            Write-Verbose ('Skip resource removal for type [{0}]. Reason: handled by different logic.' -f $type) -Verbose
            # Also, we don't want to accidently remove keys of the dependency key vault
            break
        }
        'Microsoft.KeyVault/vaults/accessPolicies' {
            Write-Verbose ('Skip resource removal for type [{0}]. Reason: handled by different logic.' -f $type) -Verbose
            break
        }
        'Microsoft.ServiceBus/namespaces/authorizationRules' {
            if ((Split-Path $ResourceId '/')[-1] -eq 'RootManageSharedAccessKey') {
                Write-Verbose ('Skip resource removal for type [{0}]. Reason: The Service Bus''s default authorization key [RootManageSharedAccessKey] cannot be removed.' -f $type) -Verbose
            } else {
                $null = Remove-AzResource -ResourceId $resourceId -Force -ErrorAction 'Stop'
            }
            break
        }
        'Microsoft.Compute/diskEncryptionSets' {
            # Pre-Removal
            # -----------
            # Remove access policies on key vault
            $resourceGroupName = $resourceId.Split('/')[4]
            $resourceName = Split-Path $resourceId -Leaf

            $diskEncryptionSet = Get-AzDiskEncryptionSet -Name $resourceName -ResourceGroupName $resourceGroupName
            $keyVaultResourceId = $diskEncryptionSet.ActiveKey.SourceVault.Id
            $keyVaultName = Split-Path $keyVaultResourceId -Leaf
            $objectId = $diskEncryptionSet.Identity.PrincipalId

            Write-Verbose ('keyVaultResourceId [{0}]' -f $keyVaultResourceId) -Verbose
            Write-Verbose ('objectId [{0}]' -f $objectId) -Verbose
            if ($PSCmdlet.ShouldProcess(('Access policy [{0}] from key vault [{1}]' -f $objectId, $keyVaultName), 'Remove')) {
                $null = Remove-AzKeyVaultAccessPolicy -VaultName $keyVaultName -ObjectId $objectId
            }

            # Actual removal
            # --------------
            $null = Remove-AzResource -ResourceId $resourceId -Force -ErrorAction 'Stop'
            break
        }
        'Microsoft.RecoveryServices/vaults/backupstorageconfig' {
            # Not a 'resource' that can be removed, but represents settings on the RSV. The config is deleted with the RSV
            break
        }
        'Microsoft.Authorization/roleAssignments' {
            $idElem = $ResourceId.Split('/')
            $scope = $idElem[0..($idElem.Count - 5)] -join '/'
            $roleAssignmentsOnScope = Get-AzRoleAssignment -Scope $scope
            $null = $roleAssignmentsOnScope | Where-Object { $_.RoleAssignmentId -eq $ResourceId } | Remove-AzRoleAssignment
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
            break
        }
        'Microsoft.OperationalInsights/workspaces' {
            $resourceGroupName = $resourceId.Split('/')[4]
            $resourceName = Split-Path $resourceId -Leaf
            # Force delete workspace (cannot be recovered)
            if ($PSCmdlet.ShouldProcess("Log Analytics Workspace [$resourceName]", 'Remove')) {
                $null = Remove-AzOperationalInsightsWorkspace -ResourceGroupName $resourceGroupName -Name $resourceName -Force -ForceDelete
            }
            break
        }
        'Microsoft.DevTestLab/labs' {
            $resourceGroupName = $resourceId.Split('/')[4]
            $resourceName = Split-Path $resourceId -Leaf
            if ($PSCmdlet.ShouldProcess("DevTestLab Lab [$resourceName]", 'Remove')) {
                Get-AzResourceLock -ResourceGroupName $resourceGroupName |
                    Where-Object -FilterScript { $PSItem.properties.notes -eq "Reserved resource locked by '$resourceName' lab." } |
                    ForEach-Object {
                        $null = Remove-AzResourceLock -LockId $PSItem.LockId -Force
                        Write-Verbose "Removed lock [$($PSItem.Name)] created by the DevTest Lab [$resourceName] on resource [$($PSItem.ResourceName)]. Waiting 10 seconds for propagation." -Verbose
                        Start-Sleep 10
                    }
                $null = Remove-AzResource -ResourceId $resourceId -Force -ErrorAction 'Stop'
            }
            break
        }

        ### CODE LOCATION: Add custom removal action here
        Default {
            $null = Remove-AzResource -ResourceId $resourceId -Force -ErrorAction 'Stop'
        }
    }
}
