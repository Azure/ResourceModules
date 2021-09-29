param roleAssignment object
param builtInRoleNames object
param automationAccountName string

resource automationAccountName_Microsoft_Authorization_automationAccountName_roleAssignment_principalIds_innerRbacCopy_roleAssignment_roleDefinitionIdOrName 'Microsoft.Automation/automationAccounts/providers/roleAssignments@2018-09-01-preview' = [for i in range(0, length(roleAssignment.principalIds)): {
  name: '${automationAccountName}/Microsoft.Authorization/${guid(uniqueString(concat(automationAccountName, array(roleAssignment.principalIds)[i], roleAssignment.roleDefinitionIdOrName)))}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName)
    principalId: array(roleAssignment.principalIds)[i]
  }
  dependsOn: []
}]