@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Required. Portal setting name')
param name string = ''

@description('Optional. Portal setting properties.')
param properties object = {}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource portalSetting 'Microsoft.ApiManagement/service/portalsettings@2019-12-01' = if (!empty(properties)) {
  name: '${apiManagementServiceName}/${name}'
  properties: properties
}

@description('The resourceId of the API management service portal settings')
output portalSettingsResourceId string = portalSetting.id

@description('The name of the API management service portal settings')
output portalSettingsName string = portalSetting.name

@description('The resource group the API management service portal settings was deployed into')
output portalSettingsResourceGroup string = resourceGroup().name
