targetScope = 'resourceGroup'

param roleDefinitionId string
param principalId string
param subscriptionId string
param resourceGroupName string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(subscriptionId, resourceGroupName, roleDefinitionId, principalId)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
  }
}

output roleAssignmentId string = resourceId(resourceGroupName, 'Microsoft.Authorization/roleAssignments', roleAssignment.name)
