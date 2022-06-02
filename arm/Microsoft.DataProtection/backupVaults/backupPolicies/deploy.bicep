@description('Required. The name of the backup vault.')
param backupVaultName string

@description('Optional. The name of the backup policy.')
param name string = 'DefaultPolicy'

@description('Optional. The properties of the backup policy.')
param backupPolicyProperties object = {}

resource bv 'Microsoft.DataProtection/backupVaults@2022-03-01' existing = {
  name: backupVaultName
}

resource backupPolicy 'Microsoft.DataProtection/backupVaults/backupPolicies@2022-03-01' = {
  name: name
  parent: bv
  properties: backupPolicyProperties
}

@description('The name of the backup policy.')
output name string = backupPolicy.name

@description('The resource ID of the backup policy.')
output resourceId string = backupPolicy.id

@description('The name of the resource group the backup policy was created in.')
output resourceGroupName string = resourceGroup().name
