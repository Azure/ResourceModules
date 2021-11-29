@description('Required. Name of the private link scoped resource.')
@minLength(1)
param name string

@description('Required. Name of the parent private link scope.')
@minLength(1)
param privateLinkScopeName string

@description('Required. The resource id of the scoped Azure monitor resource.')
param linkedResourceId string

resource scopedResource 'Microsoft.Insights/privateLinkScopes/scopedResources@2021-07-01-preview' = {
  name: '${privateLinkScopeName}/${name}'
  properties: {
    linkedResourceId: linkedResourceId
  }
}

@description('The resource id of the parent private link scope')
output privateLinkScopeResourceId string = resourceId('Microsoft.Insights/privateLinkScopes', privateLinkScopeName)

@description('The name of the resource group where the resource has been deployed')
output scopedResourceResourceGroup string = resourceGroup().name

@description('The resource ID of the deployed scopedResource')
output scopedResourceResourceId string = scopedResource.id

@description('The full name of the deployed Scoped Resource')
output scopedResourceName string = scopedResource.name
