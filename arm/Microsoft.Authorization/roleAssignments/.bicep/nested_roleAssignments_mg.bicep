targetScope = 'managementGroup'

param roleDefinitionId string
param principalId string
param managementGroupId string
param location string = deployment().location

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(managementGroupId, location, roleDefinitionId, principalId)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
  }
}

output roleAssignmentScope string = tenantResourceId('Microsoft.Management/managementGroups',managementGroupId)
output roleAssignmentId string = extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups',managementGroupId),'Microsoft.Authorization/roleAssignments',roleAssignment.name)
