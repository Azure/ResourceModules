@description('Required. The name of the proximity placement group that is being created.')
param name string

@description('Optional. Specifies the type of the proximity placement group.')
@allowed([
  'Standard'
  'Ultra'
])
param type string = 'Standard'

@description('Optional. Resource location.')
param location string = resourceGroup().location

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the proximity placement group resource.')
param tags object = {}

@description('Optional. Specifies the Availability Zone where virtual machine, virtual machine scale set or availability set associated with the proximity placement group can be created.')
param zones array = []

@description('Optional. Describes colocation status of the Proximity Placement Group.')
param colocationStatus object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Specifies the user intent of the proximity placement group.')
param intent object = {}

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

resource proximityPlacementGroup 'Microsoft.Compute/proximityPlacementGroups@2022-08-01' = {
  name: name
  location: location
  tags: tags
  zones: zones
  properties: {
    proximityPlacementGroupType: type
    colocationStatus: colocationStatus
    intent: !empty(intent) ? intent : null
  }
}

resource proximityPlacementGroup_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${proximityPlacementGroup.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: proximityPlacementGroup
}

module proximityPlacementGroup_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-ProxPlaceGroup-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: proximityPlacementGroup.id
  }
}]

@description('The name of the proximity placement group.')
output name string = proximityPlacementGroup.name

@description('The resourceId the proximity placement group.')
output resourceId string = proximityPlacementGroup.id

@description('The resource group the proximity placement group was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = proximityPlacementGroup.location
