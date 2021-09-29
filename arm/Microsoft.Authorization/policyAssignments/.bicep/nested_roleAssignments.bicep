resource policyAssignmentName_managementGroupId_policyDefinitionID_roleDefinitionIds_roleDefinitionIds_innerRbacSubCopy_placeholder 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for item in roleDefinitionIds: if ((identity == 'SystemAssigned') && (!empty(roleDefinitionIds))) {
  name: guid(policyAssignmentName, managementGroupId, policyDefinitionID, ((!empty(roleDefinitionIds)) ? item : 'placeholder'))
  properties: {
    roleDefinitionId: item
    principalId: reference('Microsoft.Authorization/policyAssignments/${policyAssignmentName}', '2020-09-01', 'Full').identity.principalId
  }
  dependsOn: [
    policyAssignmentName_resource
  ]
}]
