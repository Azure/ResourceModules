@description('Required. Name of the Azure Recovery Service Vault')
@minLength(1)
param recoveryVaultName string

@description('Optional. Change Vault Storage Type (Works if vault has not registered any backup instance)')
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
])
param vaultStorageType string = 'GeoRedundant'

@description('Optional. Enable CRR (Works if vault has not registered any backup instance)')
param enableCRR bool = true

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource vaultstorageconfig 'Microsoft.RecoveryServices/vaults/backupstorageconfig@2021-08-01' = {
  name: '${recoveryVaultName}/vaultstorageconfig'
  properties: {
    storageModelType: vaultStorageType
    crossRegionRestoreFlag: enableCRR
  }
}

@description('The name of the Resource Group the backup storage configuration was created in.')
output vaultStorageConfigRgName string = resourceGroup().name
