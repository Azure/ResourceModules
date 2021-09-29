targetScope = 'resourceGroup'
param policyAssignmentName string
param properties object
param resourceGroupName string
param identity object
param location string = resourceGroup().location
param subscriptionId string

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: policyAssignmentName
  properties: properties
  identity: identity
  location: location
}

output policyAssignmentId string = resourceId(subscriptionId, resourceGroupName, 'Microsoft.Authorization/policyAssignments', policyAssignment.name)
output policyAssignmentPrincipalId string = (identity.type == 'SystemAssigned') ? policyAssignment.identity.principalId : ''
