@description('Required. The name of the availability set that is being created.')
param name string

@description('Optional. The number of fault domains to use.')
param platformFaultDomainCount int = 2

@description('Optional. The number of update domains to use.')
param platformUpdateDomainCount int = 5

@description('''Optional. SKU of the availability set.
- Use \'Aligned\' for virtual machines with managed disks.
- Use \'Classic\' for virtual machines with unmanaged disks.
''')
param skuName string = 'Aligned'

@description('Optional. Resource ID of a proximity placement group.')
param proximityPlacementGroupResourceId string = ''

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

@description('Optional. Tags of the availability set resource.')
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

resource availabilitySet 'Microsoft.Compute/availabilitySets@2022-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    platformFaultDomainCount: platformFaultDomainCount
    platformUpdateDomainCount: platformUpdateDomainCount
    proximityPlacementGroup: !empty(proximityPlacementGroupResourceId) ? {
      id: proximityPlacementGroupResourceId
    } : null
  }
  sku: {
    name: skuName
  }
}

resource availabilitySet_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${availabilitySet.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: availabilitySet
}

module availabilitySet_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AvSet-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: availabilitySet.id
  }
}]

@description('The name of the availability set.')
output name string = availabilitySet.name

@description('The resource ID of the availability set.')
output resourceId string = availabilitySet.id

@description('The resource group the availability set was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = availabilitySet.location
