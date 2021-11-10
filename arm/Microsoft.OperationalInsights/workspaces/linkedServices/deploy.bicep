@description('Required. Name of the Log Analytics workspace')
param logAnalyticsWorkspaceName string

@description('Required. Name of the link')
param name string

@description('Required. The resource id of the resource that will be linked to the workspace. This should be used for linking resources which require read access.')
param resourceId string = ''

@allowed([
  'Deleting'
  'ProvisioningAccount'
  'Succeeded'
  'Updating'
])
@description('Optional. The provisioning state of the linked service.')
param provisioningState string = 'Succeeded'

@description('Optional. The resource id of the resource that will be linked to the workspace. This should be used for linking resources which require write access. ')
param writeAccessResourceId string = ''

@description('Optional. Tags to configure in the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource linkedService 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = {
  name: '${logAnalyticsWorkspaceName}/${name}'
  tags: tags
  properties: {
    resourceId: resourceId
    provisioningState: provisioningState
    writeAccessResourceId: writeAccessResourceId == '' ? null : writeAccessResourceId
  }
}
