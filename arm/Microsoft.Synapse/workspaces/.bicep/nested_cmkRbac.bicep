param keyvaultName string
param workspaceIdentity string

// Workspace encryption - Assign Workspace System Identity Keyvault Crypto Reader at Encryption Keyvault
resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultName
}

// Assign role Key Vault Crypto User
resource workspace_cmk_rbac 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = {
  name: guid(deployment().name)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '12338af0-0e69-4776-bea7-57ae8d297424')
    principalId: workspaceIdentity
  }
  scope: keyVault
}
