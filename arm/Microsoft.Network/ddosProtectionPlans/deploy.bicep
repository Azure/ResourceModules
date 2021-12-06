@description('Required. Name of the DDoS protection plan to assign the VNET to.')
@minLength(1)
param name string = ''

@description('Optional. Location for all resources.')
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

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource ddosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2021-02-01' = {
  name: name
  location: location
  tags: tags
  properties: {}
}

resource ddosProtectionPlan_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${ddosProtectionPlan.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: ddosProtectionPlan
}

module ddosProtectionPlan_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-DDoSProtectionPlan-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: ddosProtectionPlan.id
  }
}]

@description('The resource group the DDOS protection plan was deployed into')
output ddosProtectionPlanResourceGroup string = resourceGroup().name

@description('The resource ID of the DDOS protection plan')
output ddosProtectionPlanResourceId string = ddosProtectionPlan.id

@description('The name of the DDOS protection plan')
output ddosProtectionPlanName string = ddosProtectionPlan.name
