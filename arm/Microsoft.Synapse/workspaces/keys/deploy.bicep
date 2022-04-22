@description('Required. Encryption key name.')
param name string

@description('Required. Synapse workspace name.')
param workspaceName string

@description('Required. Used to activate the workspace after a customer managed key is provided.')
param isActiveCMK bool

@description('Required. The Key Vault Url of the workspace key.')
param keyVaultUrl string

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: workspaceName
}

resource key 'Microsoft.Synapse/workspaces/keys@2021-06-01' = {
  name: name
  parent: workspace
  properties: {
    isActiveCMK: isActiveCMK
    keyVaultUrl: keyVaultUrl
  }
}

@description('The name of the deployed key')
output name string = key.name

@description('The resource ID of the deployed key')
output resourceId string = key.id

@description('The resource group of the deployed key')
output resourceGroupName string = resourceGroup().name
