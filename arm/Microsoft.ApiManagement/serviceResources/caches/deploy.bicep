@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string

@description('Required. Identifier of the Cache entity. Cache identifier (should be either \'default\' or valid Azure region identifier).')
param cacheName string = ''

@description('Required. Runtime connection string to cache. Can be referenced by a named value like so, {{<named-value>}}')
param connectionString string = ''

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Cache description')
param cacheDescription string = ''

@description('Optional. Original uri of entity in external system cache points to.')
param resourceId string = ''

@description('Required. Location identifier to use cache from (should be either \'default\' or valid Azure region identifier)')
param useFromLocation string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource cache 'Microsoft.ApiManagement/service/caches@2020-06-01-preview' = {
  name: '${apiManagementServiceName}/${cacheName}'
  properties: {
    description: (empty(cacheDescription) ? json('null') : cacheDescription)
    connectionString: connectionString
    useFromLocation: useFromLocation
    resourceId: (empty(resourceId) ? json('null') : resourceId)
  }
}

output cacheResourceId string = cache.id
output cacheResourceName string = cache.name
output cacheResourceGroup string = resourceGroup().name
