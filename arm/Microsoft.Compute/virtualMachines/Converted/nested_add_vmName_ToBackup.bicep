param resourceId_Microsoft_RecoveryServices_vaults_backupPolicies_parameters_backupVaultName_parameters_backupPolicyName string
param resourceId_Microsoft_Compute_virtualMachines_parameters_vmName string
param backupVaultName string
param vmName string

resource backupVaultName_Azure_iaasvmcontainer_iaasvmcontainerv2_name_vmName_vm_iaasvmcontainerv2_name_vmName 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2016-12-01' = {
  name: '${backupVaultName}/Azure/iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${vmName}/vm;iaasvmcontainerv2;${resourceGroup().name};${vmName}'
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: resourceId_Microsoft_RecoveryServices_vaults_backupPolicies_parameters_backupVaultName_parameters_backupPolicyName
    sourceResourceId: resourceId_Microsoft_Compute_virtualMachines_parameters_vmName
  }
}