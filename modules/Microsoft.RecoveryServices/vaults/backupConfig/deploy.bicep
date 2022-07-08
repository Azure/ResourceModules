@description('Conditional. The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.')
param recoveryVaultName string

@description('Optional. Name of the Azure Recovery Service Vault Backup Policy.')
param name string = 'vaultconfig'

@description('Optional. Enable this setting to protect hybrid backups against accidental deletes and add additional layer of authentication for critical operations.')
@allowed([
  'Disabled'
  'Enabled'
])
param enhancedSecurityState string = 'Enabled'

@description('Optional. ResourceGuard Operation Requests.')
param resourceGuardOperationRequests array = []

@description('Optional. Enable this setting to protect backup data for Azure VM, SQL Server in Azure VM and SAP HANA in Azure VM from accidental deletes.')
@allowed([
  'Disabled'
  'Enabled'
])
param softDeleteFeatureState string = 'Enabled'

@description('Optional. Storage type.')
@allowed([
  'GeoRedundant'
  'LocallyRedundant'
  'ReadAccessGeoZoneRedundant'
  'ZoneRedundant'
])
param storageModelType string = 'GeoRedundant'

@description('Optional. Storage type.')
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

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource rsv 'Microsoft.RecoveryServices/vaults@2021-12-01' existing = {
  name: recoveryVaultName
}

resource backupConfig 'Microsoft.RecoveryServices/vaults/backupconfig@2021-10-01' = {
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

@description('The name of the backup config.')
output name string = backupConfig.name

@description('The resource ID of the backup config.')
output resourceId string = backupConfig.id

@description('The name of the resource group the backup config was created in.')
output resourceGroupName string = resourceGroup().name
