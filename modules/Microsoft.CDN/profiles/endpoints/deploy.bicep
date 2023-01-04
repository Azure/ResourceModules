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

resource endpoint 'microsoft.cdn/profiles/endpoints@2021-06-01' = if (!empty(endpointName)) {
  parent: profile
  name: endpointName
  location: location
  properties: endpointProperties
  tags: tags
}

module profile_EndpointOrigin 'origins/deploy.bicep' = {
  name: '${endpointName}-origins'
  params: {
    profileName: profile.name
    endpointName: endpointName
    originsProperties: endpointProperties.origins
  }
}

@description('The name of the endpoint.')
output name string = endpoint.name

@description('The resource ID of the endpoint.')
output resourceId string = endpoint.id

@description('The name of the resource group the endpoint was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = endpoint.location

@description('The properties of the endpoint.')
output endpointProperties object = endpoint.properties
