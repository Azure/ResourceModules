metadata name = 'Express Route Gateways'
metadata description = 'This module deploys an Express Route Gateway.'
metadata owner = 'Azure/module-maintainers'

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

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

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

resource expressRouteGateway 'Microsoft.Network/expressRouteGateways@2023-04-01' = {
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

resource expressRouteGateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${expressRouteGateway.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: expressRouteGateway
}

module expressRouteGateway_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-ExpressRouteGateway-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: expressRouteGateway.id
  }
}]

@description('The resource ID of the ExpressRoute Gateway.')
output resourceId string = expressRouteGateway.id

@description('The resource group of the ExpressRoute Gateway was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the ExpressRoute Gateway.')
output name string = expressRouteGateway.name

@description('The location the resource was deployed into.')
output location string = expressRouteGateway.location
