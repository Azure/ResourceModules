@description('Required. The name of the of the API Management service.')
param apiManagementServiceName string

@description('Required. Identifier of the Cache entity. Cache identifier (should be either \'default\' or valid Azure region identifier).')
param name string

@description('Required. Runtime connection string to cache. Can be referenced by a named value like so, {{<named-value>}}')
param connectionString string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param telemetryCuaId string = ''

@description('Optional. Cache description')
param cacheDescription string = ''

@description('Optional. Original uri of entity in external system cache points to.')
param resourceId string = ''

@description('Required. Location identifier to use cache from (should be either \'default\' or valid Azure region identifier)')
param useFromLocation string

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

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource cache 'Microsoft.ApiManagement/service/caches@2021-08-01' = {
  name: name
  parent: service
  properties: {
    description: !empty(cacheDescription) ? cacheDescription : null
    connectionString: connectionString
    useFromLocation: useFromLocation
    resourceId: !empty(resourceId) ? resourceId : null
  }
}

@description('The resource ID of the API management service cache')
output cacheResourceId string = cache.id

@description('The name of the API management service cache')
output cacheResourceName string = cache.name

@description('The resource group the API management service cache was deployed into')
output cacheResourceGroup string = resourceGroup().name
