@description('Required. The name of the customer managed key.')
param cMKKeyName string

@description('Required. The resource ID of the Key Vault hosting the customer managed key.')
param cMKKeyVaultResourceId string

@description('Required. The name of the Synapse Workspace.')
param workspaceName string

@description('Required. The principal ID of the workspace\'s identity.')
param workspacePrincipalId string

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(cMKKeyVaultResourceId)) {
  name: last(split(cMKKeyVaultResourceId, '/'))
  scope: resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4])
}

// Workspace encryption - Assign Synapse Workspace MSI access to encryption key
module workspace_cmk_rbac 'nested_cmkRbac.bicep' = {
  name: '${workspaceName}-cmk-rbac'
  params: {
    workspaceIdentity: workspacePrincipalId
    keyvaultName: cMKKeyVault.name
    usesRbacAuthorization: cMKKeyVault.properties.enableRbacAuthorization
  }
  scope: resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4])
}

// Workspace encryption - Activate Workspace
module workspace_cmk '../keys/deploy.bicep' = {
  name: '${workspaceName}-cmk-activation'
  params: {
    name: cMKKeyName
    isActiveCMK: true
    keyVaultUrl: cMKKeyVault.properties.vaultUri
    workspaceName: workspaceName
  }
  dependsOn: [
    workspace_cmk_rbac
  ]
}
