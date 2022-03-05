@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Required. Name of the Virtual Wan.')
param name string

@description('Optional. Sku of the Virtual Wan.')
@allowed([
  'Standard'
  'Basic'
])
param type string = 'Standard'

@description('Optional. True if branch to branch traffic is allowed.')
param allowBranchToBranchTraffic bool = false

@description('Optional. True if branch to branch traffic is allowed.')
param allowVnetToVnetTraffic bool = false

@description('Optional. True if branch to branch traffic is allowed.')
param disableVpnEncryption bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource virtualWan 'Microsoft.Network/virtualWans@2021-03-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    allowBranchToBranchTraffic: allowBranchToBranchTraffic
    allowVnetToVnetTraffic: allowVnetToVnetTraffic
    disableVpnEncryption: disableVpnEncryption
    type: type
  }
}

resource virtualWan_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${virtualWan.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: virtualWan
}

module virtualWan_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-VWan-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: virtualWan.id
  }
}]

@description('The name of the virtual WAN')
output name string = virtualWan.name

@description('The resource ID of the virtual WAN')
output resourceId string = virtualWan.id

@description('The resource group the virtual WAN was deployed into')
output resourceGroupName string = resourceGroup().name
