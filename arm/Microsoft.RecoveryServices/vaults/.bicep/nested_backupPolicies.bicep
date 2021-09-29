param protectionPolicyName string
param protectionPolicyProperties object
param recoveryVaultName string

resource protectionPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2019-06-15' = {
  name: '${recoveryVaultName}/${protectionPolicyName}'
  location: resourceGroup().location
  properties: protectionPolicyProperties
}
