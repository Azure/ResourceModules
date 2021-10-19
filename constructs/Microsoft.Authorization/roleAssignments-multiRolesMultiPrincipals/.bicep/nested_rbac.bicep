targetScope = 'managementGroup'

param resourceGroupName string = ''
param subscriptionId string = ''
param managementGroupId string = ''
param location string = deployment().location
param roleAssignmentObj object
param builtInRoleNames object

module roleAssignments_mg '../../../../arm/Microsoft.Authorization/roleAssignments/.bicep/nested_rbac_mg.bicep' = [for principalId in roleAssignmentObj.principalIds: if (!empty(managementGroupId) && empty(subscriptionId) && empty(resourceGroupName)) {
  name: 'roleAssignments_mg-${guid(deployment().name, location, principalId)}'
  scope: managementGroup(managementGroupId)
  params: {
    managementGroupId: managementGroupId
    roleDefinitionIdOrName: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
    location: location
  }
}]

module roleAssignments_sub '../../../../arm/Microsoft.Authorization/roleAssignments/.bicep/nested_rbac_sub.bicep' = [for principalId in roleAssignmentObj.principalIds: if (empty(managementGroupId) && !empty(subscriptionId) && empty(resourceGroupName)) {
  name: 'roleAssignments_sub-${guid(deployment().name, location, principalId)}'
  scope: subscription(subscriptionId)
  params: {
    subscriptionId: subscriptionId
    roleDefinitionIdOrName: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
    location: location
  }
}]

module roleAssignments_rg '../../../../arm/Microsoft.Authorization/roleAssignments/.bicep/nested_rbac_rg.bicep' = [for principalId in roleAssignmentObj.principalIds: if (empty(managementGroupId) && !empty(resourceGroupName) && !empty(subscriptionId)) {
  name: 'roleAssignments_rg-${guid(deployment().name, location, principalId)}'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    subscriptionId: subscriptionId
    roleDefinitionIdOrName: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
    location: location
  }
}]

output roleAssignmentScope string = !empty(managementGroupId) ? roleAssignments_mg[0].outputs.roleAssignmentScope : (!empty(resourceGroupName) ? roleAssignments_rg[0].outputs.roleAssignmentScope : roleAssignments_sub[0].outputs.roleAssignmentScope)
