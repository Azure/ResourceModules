@description('Required. The name of the Health Data Services Workspace service.')
@maxLength(50)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Control permission for data plane traffic coming from public networks while private endpoint is enabled.')
param publicNetworkAccess string = 'Disabled'

@description('Optional. Tags of the resource.')
param tags object = {}

// =========== //
// Deployments //
// =========== //

resource health 'Microsoft.HealthcareApis/workspaces@2022-06-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    publicNetworkAccess: publicNetworkAccess
  }
}

resource health_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${health.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: health
}

@description('The name of the health data services workspace.')
output name string = health.name

@description('The resource ID of the health data services workspace.')
output resourceId string = health.id

@description('The resource group where the workspace is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = health.location
