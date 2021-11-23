@description('Required. Name of the Azure Recovery Service Vault')
@minLength(1)
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

resource backupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2021-08-01' = {
  name: '${recoveryVaultName}/${name}'
  properties: backupPolicyProperties
}

@description('The name of the backup policy')
output backupPolicyName string = backupPolicy.name

@description('The resource ID of the backup policy')
output backupPolicyId string = backupPolicy.id

@description('The name of the Resource Group the backup policy was created in.')
output backupPolicyResourceGroup string = resourceGroup().name
