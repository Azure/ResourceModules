@description('Required. Name of the private link scoped resource.')
@minLength(1)
param name string

@description('Required. Name of the parent private link scope.')
@minLength(1)
param privateLinkScopeName string

@description('Required. The resource ID of the scoped Azure monitor resource.')
param linkedResourceId string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param telemetryCuaId string = ''

resource pid_cuaId 'Microsoft.Resources/deployments@2021-04-01' = if (!empty(telemetryCuaId)) {
  name: 'pid-${telemetryCuaId}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource privateLinkScope 'microsoft.insights/privateLinkScopes@2021-07-01-preview' existing = {
  name: privateLinkScopeName
}

resource scopedResource 'Microsoft.Insights/privateLinkScopes/scopedResources@2021-07-01-preview' = {
  name: name
  parent: privateLinkScope
  properties: {
    linkedResourceId: linkedResourceId
  }
}

@description('The name of the resource group where the resource has been deployed')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the deployed scopedResource')
output resourceId string = scopedResource.id

@description('The full name of the deployed Scoped Resource')
output name string = scopedResource.name
