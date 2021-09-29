param protectionContainerName string
param protectionContainerSourceResourceId string
param protectionContainerFriendlyName string
param protectionContainerBackupManagementType string
param protectionContainerContainerType string
param recoveryVaultName string

resource recoveryVaultName_protectionContainers_variables_protectionContainers_copyIndex_name_name 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers@2016-12-01' = {
  name: '${recoveryVaultName}/protectionContainers/${protectionContainerName}'
  location: resourceGroup().location
  properties: {
    sourceResourceId: (empty(protectionContainerSourceResourceId) ? json('null') : protectionContainerSourceResourceId)
    friendlyName: (empty(protectionContainerFriendlyName) ? json('null') : protectionContainerFriendlyName)
    backupManagementType: (empty(protectionContainerBackupManagementType) ? json('null') : protectionContainerBackupManagementType)
    containerType: (empty(protectionContainerContainerType) ? json('null') : protectionContainerContainerType)
  }
}
