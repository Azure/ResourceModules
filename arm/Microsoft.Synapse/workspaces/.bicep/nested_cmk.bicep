param encryptionKeyVaultName string
param encryptionKeyVaultResourceGroupName string
param encryptionKeyName string
param workspaceName string
param workspacePrincipalId string

var keyVaultUrl = 'https://${encryptionKeyVaultName}${environment().suffixes.keyvaultDns}/keys/${encryptionKeyName}'

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: encryptionKeyVaultName
  scope: resourceGroup(encryptionKeyVaultResourceGroupName)
}

// Workspace encryption - Assign Synapse Workspace MSI access to encryption key
module workspace_cmk_rbac 'nested_cmkRbac.bicep' = {
  name: '${workspaceName}-cmk-rbac'
  params: {
    workspaceIdentity: workspacePrincipalId
    keyvaultName: encryptionKeyVaultName
    usesRbacAuthorization: keyVault.properties.enableRbacAuthorization
  }
  scope: resourceGroup(encryptionKeyVaultResourceGroupName)
}

// Workspace encryption - Activate Workspace
module workspace_cmk '../keys/deploy.bicep' = {
  name: '${workspaceName}-cmk-activation'
  params: {
    isActiveCMK: true
    keyVaultUrl: keyVaultUrl
    name: encryptionKeyName
    workspaceName: workspaceName
  }
  dependsOn: [
    workspace_cmk_rbac
  ]
}
