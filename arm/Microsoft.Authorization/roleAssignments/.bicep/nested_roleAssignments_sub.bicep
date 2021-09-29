targetScope = 'subscription'

param roleDefinitionId string
param principalId string
param subscriptionId string
param location string = deployment().location

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(subscriptionId, roleDefinitionId, principalId)
  location: location
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
  }
}

output roleAssignmentId string = subscriptionResourceId(subscriptionId,'Microsoft.Authorization/roleAssignments',roleAssignment.name)
