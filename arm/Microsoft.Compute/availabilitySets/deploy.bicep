@description('Required. The name of the availability set that is being created.')
param availabilitySetName string

@description('Optional. The number of fault domains to use.')
param availabilitySetFaultDomain int = 2

@description('Optional. The number of update domains to use.')
param availabilitySetUpdateDomain int = 5

@description('Optional. Sku of the availability set. Use \'Aligned\' for virtual machines with managed disks and \'Classic\' for virtual machines with unmanaged disks.')
param availabilitySetSku string = 'Aligned'

@description('Optional. Resource Id of a proximity placement group.')
param proximityPlacementGroupId string = ''

@description('Optional. Resource location.')
param location string = resourceGroup().location

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the availability set resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource availabilitySet 'Microsoft.Compute/availabilitySets@2021-04-01' = {
  name: availabilitySetName
  location: location
  tags: tags
  properties: {
    platformFaultDomainCount: availabilitySetFaultDomain
    platformUpdateDomainCount: availabilitySetUpdateDomain
    proximityPlacementGroup: (empty(proximityPlacementGroupId) ? json('null') : proximityPlacementGroupId)
  }
  sku: {
    name: availabilitySetSku
  }
}

resource availabilitySet_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${availabilitySet.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: availabilitySet
}

module availabilitySet_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: availabilitySet.name
  }
}]

output availabilitySetResourceName string = availabilitySet.name
output availabilitySetResourceId string = availabilitySet.id
output availabilitySetResourceGroup string = resourceGroup().name
