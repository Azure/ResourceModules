param roleAssignment object
param builtInRoleNames object
param applicationGatewayName string

resource nested_rbac 'Microsoft.Network/applicationGateways/providers/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignment.principalIds: {
  name: '${applicationGatewayName}/Microsoft.Authorization/${guid(applicationGatewayName, principalId, roleAssignment.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: principalId
  }
  dependsOn: []
}]
