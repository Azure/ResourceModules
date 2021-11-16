targetScope = 'managementGroup'

param policyAssignmentName string
param policyDefinitionID string
param parameters object = {}
param identity string = 'SystemAssigned'
param roleDefinitionIds array = []
param policyAssignmentDescription string = ''
param displayName string = ''
param metadata object = {}
param nonComplianceMessage string = ''
param enforcementMode string = 'Default'
param notScopes array = []
param managementGroupId string = ''
param location string = deployment().location

var policyAssignmentName_var = replace(policyAssignmentName, ' ', '-')
var nonComplianceMessage_var = {
  message: (empty(nonComplianceMessage) ? 'null' : nonComplianceMessage)
}
var policyAssignmentIdentity_var = {
  type: identity
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: policyAssignmentName_var
  location: location
  properties: {
    displayName: (empty(displayName) ? null : displayName)
    metadata: (empty(metadata) ? null : metadata)
    description: (empty(policyAssignmentDescription) ? null : policyAssignmentDescription)
    policyDefinitionId: policyDefinitionID
    parameters: parameters
    nonComplianceMessages: (empty(nonComplianceMessage) ? [] : array(nonComplianceMessage_var))
    enforcementMode: enforcementMode
    notScopes: (empty(notScopes) ? [] : notScopes)
  }
  identity: policyAssignmentIdentity_var
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for roleDefinitionId in roleDefinitionIds: if (!empty(roleDefinitionIds) && identity != 'None') {
  name: guid(managementGroupId, roleDefinitionId, location, policyAssignmentName_var)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: policyAssignment.identity.principalId
  }
}]

output policyAssignmentName string = policyAssignment.name
output policyAssignmentId string = extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', managementGroupId), 'Microsoft.Authorization/policyAssignments', policyAssignment.name)
output policyAssignmentPrincipalId string = identity == 'SystemAssigned' ? policyAssignment.identity.principalId : ''
