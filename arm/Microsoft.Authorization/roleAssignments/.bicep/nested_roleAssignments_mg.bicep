targetScope = 'managementGroup'

param roleDefinitionId string
param principalId string
param managementGroupId string
param location string = deployment().location

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(managementGroupId, roleDefinitionId, principalId)
  //location: location
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
  }
}

output roleAssignmentId string = extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups',managementGroupId),'Microsoft.Authorization/roleAssignments',roleAssignment.name)
