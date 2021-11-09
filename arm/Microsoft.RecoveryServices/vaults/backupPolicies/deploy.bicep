@description('Required. Name of the Azure Recovery Service Vault')
@minLength(1)
param recoveryVaultName string

@description('Required. Name of the Azure Recovery Service Vault Backup Policy')
param policyName string 

@description('Required. Configuration of the Azure Recovery Service Vault Backup Policy')
param backupPolicyProperties object 

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource vaultBackupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2021-08-01' = {
  name: '${recoveryVaultName}/${policyName}'
  properties: backupPolicyProperties
}

@description('The ResourceId of the backup policy')
output backupPolicyName string = vaultBackupPolicy.name

@description('The name of the backup policy')
output backupPolicyId string = vaultBackupPolicy.id

@description('The name of the Resource Group the backup policy was created in.')
output backupPolicyResourceGroup string = resourceGroup().name
