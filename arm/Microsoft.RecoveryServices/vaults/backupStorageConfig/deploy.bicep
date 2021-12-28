@description('Required. Name of the Azure Recovery Service Vault')
param recoveryVaultName string

@description('Optional. The name of the backup storage config')
param name string = 'vaultstorageconfig'

@description('Optional. Change Vault Storage Type (Works if vault has not registered any backup instance)')
@allowed([
  'GeoRedundant'
  'LocallyRedundant'
  'ReadAccessGeoZoneRedundant'
  'ZoneRedundant'
])
param storageModelType string = 'GeoRedundant'

@description('Optional. Opt in details of Cross Region Restore feature')
param crossRegionRestoreFlag bool = true

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource rsv 'Microsoft.RecoveryServices/vaults@2021-08-01' existing = {
  name: recoveryVaultName
}

resource backupStorageConfig 'Microsoft.RecoveryServices/vaults/backupstorageconfig@2021-08-01' = {
  name: name
  parent: rsv
  properties: {
    storageModelType: storageModelType
    crossRegionRestoreFlag: crossRegionRestoreFlag
  }
}

@description('The name of the backup storage config')
output backupStorageConfigName string = backupStorageConfig.name

@description('The resource ID of the backup storage config')
output backupStorageConfigResourceId string = backupStorageConfig.id

@description('The name of the Resource Group the backup storage configuration was created in.')
output backupStorageConfigResourceGroup string = resourceGroup().name
