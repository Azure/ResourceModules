@description('Required. Name of the Express Route Gateway.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the Firewall policy resource.')
param tags object = {}

@description('Optional. Configures this gateway to accept traffic from non Virtual WAN networks.')
param allowNonVirtualWanTraffic bool = false

@description('Optional. Maximum number of scale units deployed for ExpressRoute gateway.')
param autoScaleConfigurationBoundsMax int = 2

@description('Optional. Minimum number of scale units deployed for ExpressRoute gateway.')
param autoScaleConfigurationBoundsMin int = 2

@description('Optional. List of ExpressRoute connections to the ExpressRoute gateway.')
param expressRouteConnections array = []

@description('Required. Resource ID of the Virtual Wan Hub.')
param virtualHubId string

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

resource expressRouteGateway 'Microsoft.Network/expressRouteGateways@2022-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    allowNonVirtualWanTraffic: allowNonVirtualWanTraffic
    autoScaleConfiguration: {
      bounds: {
        max: autoScaleConfigurationBoundsMax
        min: autoScaleConfigurationBoundsMin
      }
    }
    expressRouteConnections: expressRouteConnections
    virtualHub: {
      id: virtualHubId
    }
  }
}

@description('The resource ID of the ExpressRoute Gateway.')
output resourceId string = expressRouteGateway.id

@description('The resource group of the ExpressRoute Gateway was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the ExpressRoute Gateway.')
output name string = expressRouteGateway.name

@description('The location the resource was deployed into.')
output location string = expressRouteGateway.location
