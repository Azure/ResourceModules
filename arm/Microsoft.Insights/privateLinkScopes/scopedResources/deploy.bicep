@description('Required. Name of the private link scoped resource.')
@minLength(1)
param name string

@description('Required. Name of the parent private link scope.')
@minLength(1)
param privateLinkScopeName string

@description('Required. The resource ID of the scoped Azure monitor resource.')
param linkedResourceId string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
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
output scopedResourceResourceGroup string = resourceGroup().name

@description('The resource ID of the deployed scopedResource')
output scopedResourceResourceId string = scopedResource.id

@description('The full name of the deployed Scoped Resource')
output scopedResourceName string = scopedResource.name
