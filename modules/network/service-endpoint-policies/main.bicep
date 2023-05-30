@description('Required. Service Endpoint Policy name.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. An Array of service endpoint policy definitions.')
param serviceEndpointPolicyDefinitions array = []

@description('Optional. An Array of contextual service endpoint policy.')
param contextualServiceEndpointPolicies array = []

@description('Optional. The alias indicating if the policy belongs to a service.')
param serviceAlias string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource serviceEndpointPolicy 'Microsoft.network/ServiceEndpointPolicies@2022-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    serviceAlias: !empty(serviceAlias) ? serviceAlias : null
    contextualServiceEndpointPolicies: !empty(contextualServiceEndpointPolicies) ? contextualServiceEndpointPolicies : null
    serviceEndpointPolicyDefinitions: !empty(serviceEndpointPolicyDefinitions) ? serviceEndpointPolicyDefinitions : null
  }
}

@description('The resource group the Service Endpoint Policy was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Service Endpoint Policy.')
output name string = serviceEndpointPolicy.name

@description('The resource ID of the Service Endpoint Policy.')
output resourceId string = serviceEndpointPolicy.id

@description('The location the resource was deployed into.')
output location string = serviceEndpointPolicy.location
