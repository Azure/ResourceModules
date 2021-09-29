targetScope = 'managementGroup'
param policyAssignmentName string
param properties object
param managementGroupId string
param identity object
param location string = deployment().location

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: policyAssignmentName
  properties: properties
  identity: identity
  location: location
}

output policyAssignmentId string =   extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups',managementGroupId),'Microsoft.Authorization/policyAssignments',policyAssignment.name)
output policyAssignmentPrincipalId string = (identity.type == 'SystemAssigned') ? policyAssignment.identity.principalId : ''
