@description('Required. The name of the proximity placement group that is being created.')
param name string = ''

@description('Optional. Specifies the type of the proximity placement group.')
@allowed([
  'Standard'
  'Ultra'
])
param proximityPlacementGroupType string = 'Standard'

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

@description('Optional. Tags of the proximity placement group resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource proximityPlacementGroup 'Microsoft.Compute/proximityPlacementGroups@2021-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    proximityPlacementGroupType: proximityPlacementGroupType
  }
}

resource proximityPlacementGroup_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${proximityPlacementGroup.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: proximityPlacementGroup
}

module proximityPlacementGroup_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-ProxPlaceGroup-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: proximityPlacementGroup.id
  }
}]

@description('The name of the proximity placement group')
output proximityPlacementGroupName string = proximityPlacementGroup.name

@description('The resourceId the proximity placement group')
output proximityPlacementGroupResourceId string = proximityPlacementGroup.id

@description('The resource group the proximity placement group was deployed into')
output proximityPlacementGroupResourceGroup string = resourceGroup().name
