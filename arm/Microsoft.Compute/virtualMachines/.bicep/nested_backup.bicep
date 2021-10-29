param backupResourceName string

@allowed([
  'AzureFileShareProtectedItem'
  'AzureVmWorkloadSAPAseDatabase'
  'AzureVmWorkloadSAPHanaDatabase'
  'AzureVmWorkloadSQLDatabase'
  'DPMProtectedItem'
  'GenericProtectedItem'
  'MabFileFolderProtectedItem'
  'Microsoft.ClassicCompute/virtualMachines'
  'Microsoft.Compute/virtualMachines'
  'Microsoft.Sql/servers/databases'
])
param protectedItemType string
param backupPolicyId string
param sourceResourceId string

resource backup 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-06-01' = {
  name: backupResourceName
  location: resourceGroup().location
  properties: {
    protectedItemType: protectedItemType
    policyId: backupPolicyId
    sourceResourceId: sourceResourceId
  }
}
