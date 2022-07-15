@description('Required. Encryption key name.')
param name string

@description('Required. Synapse workspace name.')
param workspaceName string

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Required. Used to activate the workspace after a customer managed key is provided.')
param isActiveCMK bool

@description('Required. The Key Vault URL of the workspace key.')
param keyVaultUrl string

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = false

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

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

@description('The name of the deployed key.')
output name string = key.name

@description('The resource ID of the deployed key.')
output resourceId string = key.id

@description('The resource group of the deployed key.')
output resourceGroupName string = resourceGroup().name
