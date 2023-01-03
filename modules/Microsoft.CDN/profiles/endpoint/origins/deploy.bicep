@description('Required. Object containing endpoint origin properties.')
param originsProperties array

@description('Required. The name of the CDN Endpoint.')
param endpointName string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

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

resource endpoint 'Microsoft.Cdn/profiles/endpoints@2021-06-01' existing = {
  name: endpointName
}

resource origins 'Microsoft.Cdn/profiles/endpoints/origins@2021-06-01' = [for (originProperties, index) in originsProperties: {
  parent: endpoint
  name: originProperties.name
  properties: {
    hostName: originProperties.properties.hostName
    httpPort: originProperties.properties.httpPort
    enabled: originProperties.properties.enabled
    httpsPort: originProperties.properties.httpsPort
  }
}]

@description('The name of the endpoint.')
output name string = origins[0].name

@description('The resource ID of the endpoint.')
output resourceId string = origins[0].id

@description('The name of the resource group the endpoint was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = endpoint.location
