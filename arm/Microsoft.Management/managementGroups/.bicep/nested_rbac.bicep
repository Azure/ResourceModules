targetScope = 'managementGroup'

param roleAssignmentObj object
param builtInRoleNames object
param managementGroupName string


resource roleAssignment 'Microsoft.Management/managementGroups/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: '${managementGroupName}/Microsoft.Authorization/${guid(managementGroupName, principalId, roleAssignmentObj.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
}]
