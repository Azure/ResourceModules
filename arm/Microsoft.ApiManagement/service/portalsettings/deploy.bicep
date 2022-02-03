@description('Required. The name of the of the API Management service.')
param apiManagementServiceName string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Required. Portal setting name')
@allowed([
  'delegation'
  'signin'
  'signup'
])
param name string

@description('Optional. Portal setting properties.')
param properties object = {}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource portalSetting 'Microsoft.ApiManagement/service/portalsettings@2021-08-01' = if (!empty(properties)) {
  name: any(name)
  parent: service
  properties: properties
}

@description('The resource ID of the API management service portal setting')
output resourceId string = portalSetting.id

@description('The name of the API management service portal setting')
output name string = portalSetting.name

@description('The resource group the API management service portal setting was deployed into')
output resourceGroupName string = resourceGroup().name
