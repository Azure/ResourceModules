@description('Required. Name of the Azure Recovery Service Vault')
param recoveryVaultName string

@description('Required. Name of the Azure Recovery Service Vault Protection Container')
param name string

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
  ''
])
param backupManagementType string = ''

@description('Optional. Resource ID of the target resource for the Protection Container ')
param sourceResourceId string = ''

@description('Optional. Friendly name of the Protection Container')
param friendlyName string = ''

@description('Optional. Type of the container')
@allowed([
  'AzureBackupServerContainer'
  'AzureSqlContainer'
  'GenericContainer'
  'Microsoft.ClassicCompute/virtualMachines'
  'Microsoft.Compute/virtualMachines'
  'SQLAGWorkLoadContainer'
  'StorageContainer'
  'VMAppContainer'
  'Windows'
  ''
])
param containerType string = ''

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource protectionContainer 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers@2021-08-01' = {
  name: '${recoveryVaultName}/Azure/${name}'
  properties: {
    sourceResourceId: !empty(sourceResourceId) ? sourceResourceId : null
    friendlyName: !empty(friendlyName) ? friendlyName : null
    backupManagementType: !empty(backupManagementType) ? backupManagementType : null
    containerType: !empty(containerType) ? any(containerType) : null
  }
}

@description('The name of the Resource Group the Protection Container was created in.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Protection Container.')
output resourceId string = protectionContainer.id

@description('The Name of the Protection Container.')
output name string = protectionContainer.name
