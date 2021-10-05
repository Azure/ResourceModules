targetScope = 'managementGroup'
param policyAssignmentName string
param policyAssignmentProperties object
param managementGroupId string
param policyAssignmentIdentity object = {
  type: 'systemAssigned'
}
param location string = deployment().location
param roleDefinitionIds array = []

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: policyAssignmentName
  location: location
  properties: policyAssignmentProperties
  identity: policyAssignmentIdentity
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for roleDefinitionId in roleDefinitionIds: if (!empty(roleDefinitionIds) && !empty(policyAssignmentIdentity)) {
  name: guid(managementGroupId, roleDefinitionId, location, policyAssignmentName)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: policyAssignment.identity.principalId
  }
}]

output policyAssignmentId string = extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', managementGroupId), 'Microsoft.Authorization/policyAssignments', policyAssignment.name)
output policyAssignmentPrincipalId string = (policyAssignmentIdentity.type == 'SystemAssigned') ? policyAssignment.identity.principalId : ''
