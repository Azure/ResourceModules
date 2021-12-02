@description('Required. Name of the link')
param name string

@description('Required. Name of the Log Analytics workspace')
param logAnalyticsWorkspaceName string

@description('Required. The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require read access.')
param resourceId string = ''

@description('Optional. The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require write access. ')
param writeAccessResourceId string = ''

@description('Optional. Tags to configure in the resource.')
param tags object = {}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource linkedService 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-03-01-preview' = {
  name: name
  parent: logAnalyticsWorkspace
  tags: tags
  properties: {
    resourceId: empty(resourceId) ? null : resourceId
    writeAccessResourceId: empty(writeAccessResourceId) ? null : writeAccessResourceId
  }
}

@description('The name of the deployed linked service')
output linkedServiceName string = linkedService.name

@description('The resource ID of the deployed linked service')
output linkedServiceResourceId string = linkedService.id

@description('The resource group where the linked service is deployed')
output linkedServiceResourceGroup string = resourceGroup().name
