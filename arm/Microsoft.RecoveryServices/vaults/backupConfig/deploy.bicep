@description('Required. Name of the Azure Recovery Service Vault')
param recoveryVaultName string

@description('Optional. Name of the Azure Recovery Service Vault Backup Policy')
param name string = 'vaultconfig'

@description('Optional. Enable this setting to protect hybrid backups against accidental deletes and add additional layer of authentication for critical operations.')
@allowed([
  'Disabled'
  'Enabled'
])
param enhancedSecurityState string = 'Enabled'

@description('Optional. ResourceGuard Operation Requests')
param resourceGuardOperationRequests array = []

@description('Optional. Enable this setting to protect backup data for Azure VM, SQL Server in Azure VM and SAP HANA in Azure VM from accidental deletes')
@allowed([
  'Disabled'
  'Enabled'
])
param softDeleteFeatureState string = 'Enabled'

@description('Optional. Storage type')
@allowed([
  'GeoRedundant'
  'LocallyRedundant'
  'ReadAccessGeoZoneRedundant'
  'ZoneRedundant'
])
param storageModelType string = 'GeoRedundant'

@description('Optional. Storage type')
@allowed([
  'GeoRedundant'
  'LocallyRedundant'
  'ReadAccessGeoZoneRedundant'
  'ZoneRedundant'
])
param storageType string = 'GeoRedundant'

@description('Optional. Once a machine is registered against a resource, the storageTypeState is always Locked.')
@allowed([
  'Locked'
  'Unlocked'
])
param storageTypeState string = 'Locked'

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource rsv 'Microsoft.RecoveryServices/vaults@2021-08-01' existing = {
  name: recoveryVaultName
}

resource backupConfig 'Microsoft.RecoveryServices/vaults/backupconfig@2021-08-01' = {
  name: name
  parent: rsv
  properties: {
    enhancedSecurityState: enhancedSecurityState
    resourceGuardOperationRequests: resourceGuardOperationRequests
    softDeleteFeatureState: softDeleteFeatureState
    storageModelType: storageModelType
    storageType: storageType
    storageTypeState: storageTypeState
  }
}

@description('The name of the backup config')
output backupConfigName string = backupConfig.name

@description('The resource ID of the backup config')
output backupConfigResourceId string = backupConfig.id

@description('The name of the resource group the backup config was created in.')
output backupConfigResourceGroup string = resourceGroup().name
