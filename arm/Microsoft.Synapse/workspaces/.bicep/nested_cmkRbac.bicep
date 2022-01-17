@description('Required. Keyvault where the encryption key is stored.')
param keyvaultName string

@description('Required. The MSI of the Synapse Workspace.')
param workspaceIdentity string

// [Workspace encryption] - Assign Workspace System Identity Keyvault Crypto Reader at Encryption Keyvault
resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = {
  name: guid(keyVault.name, workspaceIdentity, 'Key Vault Crypto User')
  properties: {
    roleDefinitionId: 'Key Vault Crypto User'
    principalId: workspaceIdentity
  }
}
