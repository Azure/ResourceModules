@description('Required. Name of the CDN profile which is unique within the resource group.')
param profileName string

@description('Required. Name of the endpoint under the profile which is unique globally.')
param endpointName string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Required. Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details).')
param endpointProperties object

@description('Optional. Endpoint tags.')
param tags object = {}

resource profile 'Microsoft.Cdn/profiles@2021-06-01' existing = {
  name: profileName
}

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

resource profileName_endpoint 'microsoft.cdn/profiles/endpoints@2021-06-01' = if (!empty(endpointName)){
  parent: profile
  name: endpointName
  location: location
  properties: endpointProperties
  tags: tags
}

resource profile_EndpointOrigins 'Microsoft.Cdn/profiles/endpoints/origins@2021-06-01' = if (!empty(endpointProperties.origins)){
  parent: profileName_endpoint
  name: endpointProperties.origins[0].name
  properties: {
    hostName: endpointProperties.origins[0].properties.hostName
    httpPort: endpointProperties.origins[0].properties.httpPort
    enabled: endpointProperties.origins[0].properties.enabled
    httpsPort: endpointProperties.origins[0].properties.httpsPort
  }
}

@description('The name of the endpoint.')
output name string = profileName_endpoint.name

@description('The resource ID of the endpoint.')
output resourceId string = profileName_endpoint.id

@description('The name of the resource group the endpoint was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = profileName_endpoint.location

@description('The properties of the endpoint.')
output endpointProperties object = profileName_endpoint.properties
