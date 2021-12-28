@description('Required. Name of the Log Analytics workspace')
param logAnalyticsWorkspaceName string

@description('Required. Name of the link')
param name string

@description('Required. The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require read access.')
param resourceId string = ''

@description('Optional. The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require write access. ')
param writeAccessResourceId string = ''

@description('Optional. Tags to configure in the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource linkedService 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = {
  name: name
  parent: workspace
  tags: tags
  properties: {
    resourceId: resourceId
    writeAccessResourceId: empty(writeAccessResourceId) ? null : writeAccessResourceId
  }
}

@description('The resource ID of the deployed linked service')
output linkedServiceResourceId string = linkedService.id

@description('The resource group where the linked service is deployed')
output linkedServiceResourceGroup string = resourceGroup().name

@description('The name of the deployed linked service')
output linkedServiceName string = linkedService.name
