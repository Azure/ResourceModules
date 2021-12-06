@description('Required. Name of the Azure Recovery Service Vault')
param recoveryVaultName string

@description('Required. Name of the Azure Recovery Service Vault Backup Policy')
param name string

@description('Required. Configuration of the Azure Recovery Service Vault Backup Policy')
param backupPolicyProperties object

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource rsv 'Microsoft.RecoveryServices/vaults@2021-08-01' existing = {
  name: recoveryVaultName
}

resource backupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2021-08-01' = {
  name: name
  parent: rsv
  properties: backupPolicyProperties
}

@description('The name of the backup policy')
output backupPolicyName string = backupPolicy.name

@description('The resource ID of the backup policy')
output backupPolicyResourceId string = backupPolicy.id

@description('The name of the resource group the backup policy was created in.')
output backupPolicyResourceGroup string = resourceGroup().name
