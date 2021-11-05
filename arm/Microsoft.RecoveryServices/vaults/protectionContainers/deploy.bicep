@description('Required. Name of the Azure Recovery Service Vault')
@minLength(1)
param recoveryVaultName string

@description('Required. Name of the Azure Recovery Service Vault Protection Container')
param protectionContainerName string

@description('Optional. Backup management type to execute the current Protection Container job.')
@allowed([
  'AzureBackupServer'
  'AzureIaasVM'
  'AzureSql'
  'AzureStorage'
  'AzureWorkload'
  'DPM'
  'DefaultBackup'
  'Invalid'
  'MAB'
])
param backupManagementType string = 'Invalid'

@description('Optional. Resource Id of the target resource for the Protection Container ')
param sourceResourceId string = ''

@description('Optional. Friendly name of the Protection Container')
param friendlyName string = ''

@description('Optional. Friendly name of the Protection Container')
param containerType string = ''

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

var backupManagementType_var = ((backupManagementType == 'Invalid') || (backupManagementType == '')) ? '' : backupManagementType

resource vaultProtectionContainer 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers@2021-08-01' = {
  name: '${recoveryVaultName}/Azure/${protectionContainerName}'
  properties: {
    sourceResourceId: (empty(sourceResourceId) ? json('null') : sourceResourceId)
    friendlyName: (empty(friendlyName) ? json('null') : friendlyName)
    backupManagementType: (empty(backupManagementType_var) ? json('null') : backupManagementType_var)
    containerType: (empty(containerType) ? json('null') : containerType)
  }
}

@description('The name of the Resource Group the Protection Container was created in.')
output protectionContainerResourceGroup string = resourceGroup().name

@description('The Resource Id of the Protection Container.')
output protectionContainerId  string = vaultProtectionContainer.id
