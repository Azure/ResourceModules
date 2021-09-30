targetScope = 'managementGroup'
param policyAssignmentName string
param properties object
param managementGroupId string
param identity object = {
  type: 'systemAssigned'
}
param location string = deployment().location
param roleDefinitionIds array = []

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: policyAssignmentName
  location: location
  properties: properties
  identity: identity
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for (roleDefinitionId, index) in roleDefinitionIds: if (!empty(roleDefinitionIds) && !empty(identity)) {
  name: guid(managementGroupId, roleDefinitionId, location, policyAssignmentName)
  location: location
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: policyAssignment.identity.principalId
  }
}]

output policyAssignmentId string =   extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups',managementGroupId),'Microsoft.Authorization/policyAssignments',policyAssignment.name)
output policyAssignmentPrincipalId string = (identity.type == 'SystemAssigned') ? policyAssignment.identity.principalId : ''
