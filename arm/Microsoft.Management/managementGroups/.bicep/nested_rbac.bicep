targetScope = 'managementGroup'

param roleAssignmentObj object
param builtInRoleNames object
param managementGroupName string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: guid(managementGroupName, principalId, roleAssignmentObj.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
}]
