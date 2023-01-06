@description('Required. The name of the CDN Endpoint.')
param endpointName string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Required. The name of the origin.')
param name string

@description('Optional. Whether the origin is enabled for load balancing.')
param enabled bool = true

@description('Required. The host name of the origin.')
param hostName string

@description('Optional. The HTTP port of the origin.')
param httpPort int = 80

@description('Optional. The HTTPS port of the origin.')
param httpsPort int = 443

@description('Optional. The priority of origin in given origin group for load balancing.')
param priority int = 1

@description('Optional. The weight of the origin used for load balancing.')
param weight int = 50

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

@description('Optional. The name of the CDN profile. Default to "default".')
param profileName string = 'default'

resource profile 'Microsoft.Cdn/profiles@2021-06-01' existing = {
  name: profileName
}

resource endpoint 'Microsoft.Cdn/profiles/endpoints@2021-06-01' existing = {
  parent: profile
  name: endpointName
}

resource origins 'Microsoft.Cdn/profiles/endpoints/origins@2021-06-01' = {
  parent: endpoint
  name: name
  properties: {
    hostName: hostName
    httpPort: httpPort
    enabled: enabled
    httpsPort: httpsPort
    priority: priority
    weight: weight
  }
}

@description('The name of the endpoint.')
output name string = origins.name

@description('The resource ID of the endpoint.')
output resourceId string = origins.id

@description('The name of the resource group the endpoint was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = endpoint.location
