targetScope = 'subscription'
param policyAssignmentName string
param policyAssignmentProperties object
param subscriptionId string
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
  name: guid(subscriptionId, roleDefinitionId, location, policyAssignmentName)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: policyAssignment.identity.principalId
  }
}]

output policyAssignmentId string = subscriptionResourceId(subscriptionId, 'Microsoft.Authorization/policySetDefinitions', policyAssignment.name)
output policyAssignmentPrincipalId string = (policyAssignmentIdentity.type == 'SystemAssigned') ? policyAssignment.identity.principalId : ''
